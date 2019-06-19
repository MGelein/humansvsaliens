import cv2
import numpy as np
from timeit import time
import math
import torch

from imutils.video import FPS, WebcamVideoStream

from data import BaseTransform
from ssd import build_ssd

# Config
webcam_index = 0 # 0 for built-in webcam, 1 for external webcam (generally)
max_face_size = 220 # based on the actual_face_size of people very close to the camera
max_x = 640 # basically the webcam frame width
max_y = 200 # max distance at which we detect people (based on the actual_face_size)

print_fps = True # print FPS to stdout
show_webcam = True
show_map = True # show a map of the people in window while running
map_width = 400
map_height = 400

COLORS = [(255, 0, 0), (0, 255, 0), (0, 0, 255)]
FONT = cv2.FONT_HERSHEY_SIMPLEX

THRESHOLD = 0.2

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

video_capture = cv2.VideoCapture(webcam_index)

fps = 0.0
while True:
    ret, frame = video_capture.read() # frame shape 640*480*3
    if frame.shape[0] == 0:
        break

    t1 = time.time()

    rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

    # bboxes = face_detector.predict(rgb_frame, thresh)
    ann_frame = predict(rgb_frame)

    bg = np.zeros((map_height, map_width, 3))
    
    # for box in bboxes:
    #     actual_face_size = math.sqrt(box[2] * box[3]) # use area of the face size as a measure of distance
    #     distance = max_face_size - actual_face_size # closest faces should be lowest values

    #     x = box[0] / max_x # scale to 0-1
    #     y = distance / max_y # scale to 0-1
    #     # print(str(x) + ", " + str(y))

    #     cv2.circle(bg, (int(map_width - (map_width * x)), int((map_height - map_height * y))), 8, (255, 255, 255), -1)

    if show_map:
        cv2.imshow('map', bg)
    
    if show_webcam:
        # ann_frame = annotate_image(frame, bboxes)
        frame = cv2.resize(ann_frame, (640, 480)) / 255.
        cv2.imshow('annotated_webcam', frame)
    
    if print_fps:
        fps = (fps + (1. / (time.time() - t1))) / 2
        print("fps = %f"%(fps))

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

video_capture.release()
cv2.destroyAllWindows()
