import numpy as np
import cv2
import time

from PyRuntime import OMExecutionSession


model = './so-lib/resnet50v1.so'
session = OMExecutionSession(model, use_default_entry_point=True)

img = cv2.imread('kitten.jpg')
img.resize(3,224,224)
input = np.array(img, np.dtype(np.float32))
start = time.perf_counter()
outputs = session.run(input.reshape(1,3,224,224))
end = time.perf_counter()
print("time execute: ")
print(end-start)
print(outputs)
