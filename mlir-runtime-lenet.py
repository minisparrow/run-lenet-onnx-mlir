import numpy as np
import cv2

import time
from PyRuntime import OMExecutionSession


model = './so-lib/lenet.so'
session = OMExecutionSession(model, use_default_entry_point=True)

img = cv2.imread('mnist_0.png')

input = np.array(img[:,:,0], np.dtype(np.float32))
start = time.perf_counter()
outputs = session.run(input)
end = time.perf_counter()
print("time execute: ")
print(end-start)
print(outputs)
