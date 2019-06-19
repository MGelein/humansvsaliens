import cv2
import numpy as np
from timeit import time
import math
from faced import FaceDetector
from faced.utils import annotate_image

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

face_detector = FaceDetector()
video_capture = cv2.VideoCapture(webcam_index)

fps = 0.0
while True:
    ret, frame = video_capture.read() # frame shape 640*480*3
    if frame.shape[0] == 0:
        break

    t1 = time.time()

    rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

    # bboxes = face_detector.predict(rgb_frame, thresh)
    bboxes = face_detector.predict(rgb_frame)

    bg = np.zeros((map_height, map_width, 3))
    
    for box in bboxes:
        actual_face_size = math.sqrt(box[2] * box[3]) # use area of the face size as a measure of distance
        distance = max_face_size - actual_face_size # closest faces should be lowest values

        x = box[0] / max_x # scale to 0-1
        y = distance / max_y # scale to 0-1
        # print(str(x) + ", " + str(y))

        cv2.circle(bg, (int(map_width - (map_width * x)), int((map_height - map_height * y))), 8, (255, 255, 255), -1)

    if show_map:
        cv2.imshow('map', bg)
    
    if show_webcam:
        ann_frame = annotate_image(frame, bboxes)
        frame = cv2.resize(ann_frame, (640, 480)) / 255.
        cv2.imshow('annotated_webcam', frame)
    
    if print_fps:
        fps = (fps + (1. / (time.time() - t1))) / 2
        print("fps = %f"%(fps))

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

video_capture.release()
cv2.destroyAllWindows()
