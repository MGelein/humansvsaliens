from __future__ import absolute_import, division, print_function

import os
import sys
import glob
import argparse
import numpy as np
import PIL.Image as pil
import matplotlib as mpl
import matplotlib.cm as cm
import cv2

from torchvision import transforms, datasets

import networks
from utils import download_model_if_doesnt_exist

from timeit import time
import math
import torch
import requests

from imutils.video import FPS, WebcamVideoStream

from data import BaseTransform
from ssd import build_ssd

# Config
webcam_index = 0 # 0 for built-in webcam, 1 for external webcam (generally)
max_face_size = 220 # based on the actual_face_size of people very close to the camera
max_x = 850 # basically the webcam frame width
max_y = 200 # max distance at which we detect people (based on the actual_face_size)

DEPTH_MODEL_NAME = 'mono_1024x320'

print_fps = True # print FPS to stdout
show_webcam = True
show_map = True # show a map of the people in window while running
map_width = 400
map_height = 400

COLORS = [(255, 0, 0), (0, 255, 0), (0, 0, 255)]
FONT = cv2.FONT_HERSHEY_SIMPLEX

THRESHOLD = 0.15

def get_bounding_boxes(frame):
    x = torch.from_numpy(transform(frame)[0]).permute(2, 0, 1)
    x = torch.autograd.Variable(x.unsqueeze(0))
    y = net(x)  # forward pass
    return y.data

def get_depth_map(frame):
    input_image = transforms.ToTensor()(frame).unsqueeze(0)

    # PREDICTION
    input_image = input_image.to(device)
    features = encoder(input_image)
    outputs = depth_decoder(features)

    disp = outputs[("disp", 0)]
    disp_resized = torch.nn.functional.interpolate(
        disp, (frame.shape[0], frame.shape[1]), mode="bilinear", align_corners=False)
    return disp_resized.squeeze().cpu().numpy()

# Initialize SSD
net = build_ssd('test', 300, 21)
net.load_state_dict(torch.load('data/weights/ssd_300_VOC0712.pth'))
transform = BaseTransform(net.size, (104/256.0, 117/256.0, 123/256.0))

# Initialize Monodepth2
if torch.cuda.is_available():
    device = torch.device("cuda")
else:
    device = torch.device("cpu")

download_model_if_doesnt_exist(DEPTH_MODEL_NAME)
model_path = os.path.join("models", DEPTH_MODEL_NAME)
print("-> Loading model from ", model_path)
encoder_path = os.path.join(model_path, "encoder.pth")
depth_decoder_path = os.path.join(model_path, "depth.pth")

# LOADING PRETRAINED MODEL
print("   Loading pretrained encoder")
encoder = networks.ResnetEncoder(18, False)
loaded_dict_enc = torch.load(encoder_path, map_location=device)

# extract the height and width of image that this model was trained with
feed_height = loaded_dict_enc['height']
feed_width = loaded_dict_enc['width']
filtered_dict_enc = {k: v for k, v in loaded_dict_enc.items() if k in encoder.state_dict()}
encoder.load_state_dict(filtered_dict_enc)
encoder.to(device)
encoder.eval()

print("   Loading pretrained decoder")
depth_decoder = networks.DepthDecoder(
    num_ch_enc=encoder.num_ch_enc, scales=range(4))

loaded_dict = torch.load(depth_decoder_path, map_location=device)
depth_decoder.load_state_dict(loaded_dict)

depth_decoder.to(device)
depth_decoder.eval()

video_capture = cv2.VideoCapture(webcam_index)

fps = 0.0
with torch.no_grad():
    while True:
        ret, frame = video_capture.read() # frame shape 640*480*3
        if frame.shape[0] == 0:
            break

        t1 = time.time()

        input_image = cv2.resize(frame, (feed_width, feed_height))

        bboxes = get_bounding_boxes(input_image)
        depth_map = get_depth_map(input_image)

        bg = np.zeros((map_height, map_width, 3))

        # scale each detection back up to the image
        height, width = input_image.shape[:2]
        scale = torch.Tensor([width, height, width, height])

        # 15 is the index of the person class in the VOC label map
        person_class_idx = 15
        data = {}
        j = 0
        while bboxes[0, person_class_idx, j, 0] >= THRESHOLD:
            pt = (bboxes[0, person_class_idx, j, 1:] * scale).cpu().numpy()

            distance = depth_map[int(pt[1])][int(pt[0])] # closest faces should be lowest values

            cv2.rectangle(input_image, (int(pt[0]), int(pt[1])), (int(pt[2]), int(pt[3])), (255, 128, 0), 1)
            cv2.putText(input_image, str(distance), (int(pt[0]), int(pt[1])), FONT, 0.5, (255, 255, 255), 1, cv2.LINE_AA)

            x = pt[0] / max_x # scale to 0-1
            y = 1.0 - distance # scale to 0-1

            data[j] = [x, y, int(pt[2]), int(pt[3])]

            cv2.circle(bg, (int(map_width - (map_width * x)), int((map_height - map_height * y))), 8, (255, 255, 255), -1)

            j += 1

        try:
            requests.put("http://localhost:3000/people", data=data)
        except requests.exceptions.RequestException as e:
            print('Failed to send people data to the webserver')

        if show_map:
            cv2.imshow('map', bg)

        if show_webcam:
            # ann_frame = annotate_image(frame, bboxes)
            input_image = cv2.resize(input_image, (640, 480)) / 255.
            cv2.imshow('annotated_webcam', input_image)

        if print_fps:
            fps = (fps + (1. / (time.time() - t1))) / 2
            print("fps = %f"%(fps))

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

video_capture.release()
cv2.destroyAllWindows()
