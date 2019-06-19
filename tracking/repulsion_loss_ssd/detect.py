from __future__ import print_function
import torch
import cv2
import time
import numpy as np
import os

from imutils.video import FPS, WebcamVideoStream

from data import BaseTransform
from ssd import build_ssd

COLORS = [(255, 0, 0), (0, 255, 0), (0, 0, 255)]
FONT = cv2.FONT_HERSHEY_SIMPLEX

THRESHOLD = 0.2

def sliding_window(image, step_size, window_size):
	# slide a window across the image
	for y in range(0, image.shape[0], step_size):
		for x in range(0, image.shape[1], step_size):
			# yield the current window
			yield (x, y, image[y:y + window_size[1], x:x + window_size[0]])

def detect(img, out_file, steps):
    def predict(frame):
        height, width = frame.shape[:2]
        x = torch.from_numpy(transform(frame)[0]).permute(2, 0, 1)
        x = torch.autograd.Variable(x.unsqueeze(0))
        y = net(x)  # forward pass
        detections = y.data
        # scale each detection back up to the image
        scale = torch.Tensor([width, height, width, height])

        # 15 is the index of the person class in the VOC label map
        person_class_idx = 15
        j = 0
        while detections[0, person_class_idx, j, 0] >= THRESHOLD:
            pt = (detections[0, person_class_idx, j, 1:] * scale).cpu().numpy()
            cv2.rectangle(frame, (int(pt[0]), int(pt[1])), (int(pt[2]), int(pt[3])), (255, 128, 0), 1)
            cv2.putText(frame, str((detections[0, person_class_idx, j, 0]).cpu().numpy()), (int(pt[0]), int(pt[1])), FONT, 0.5, (255, 255, 255), 1, cv2.LINE_AA)
            j += 1
        return frame
        
    net = build_ssd('test', 300, 21)    # initialize SSD
    net.load_state_dict(torch.load('data/weights/ssd_300_VOC0712.pth'))
    transform = BaseTransform(net.size, (104/256.0, 117/256.0, 123/256.0))

    (winW, winH) = (steps, steps)

    combined = np.zeros((img.shape[0], img.shape[1], 3), np.uint8)
    print(combined.shape)

    # Find lowest non-existing index
    # person_index = 0
    # new_fname = '/people/' + str(person_index) + '.png'
    # while os.path.exists(new_fname):
    #     person_index += 1
    #     new_fname = '/people/' + str(person_index) + '.png'

    for (fromX, fromY, window) in sliding_window(img, step_size=steps, window_size=(winW, winH)):
        toX = int(min(fromX+winW, img.shape[1]))
        toY = int(min(fromY+winH, img.shape[0]))
        print('Processing (' + str(fromX) + ', ' + str(fromY) + ') to (' + str(toX) + ', ' + str(toY) + ')...')

        window = predict(window)

        combined[int(fromY):toY, int(fromX):toX] = window
        cv2.imwrite(str(out_file), combined)

        resized = cv2.resize(combined, (800, 450))
        cv2.imshow('output', resized)

        k = cv2.waitKey(1)
        if k == 0xFF & ord("q"):
            break

if __name__ == "__main__":
    detect(cv2.imread('./frames/1560698544.png'), 'out/9_1.png', 608)
