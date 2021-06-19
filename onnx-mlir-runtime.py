import numpy as np
import cv2

from PyRuntime import ExecutionSession


model = './liblenet.so'
session = ExecutionSession(model, "run_main_graph")

img = cv2.imread('mnist_0.png')

input = np.array(img[:,:,0], np.dtype(np.float32))
outputs = session.run(input)
print(outputs)
