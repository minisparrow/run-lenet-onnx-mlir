import cv2
import onnxruntime as rt
import numpy as  np
import time

session = rt.InferenceSession("./lenet.onnx")

img = cv2.imread('mnist_0.png')

input = np.array(img[:,:,0], np.dtype(np.float32))
start = time.perf_counter()
outputs = session.run([],{"import/Placeholder:0":input.reshape(1,1,28,28)})
end = time.perf_counter()
print("time execute: ")
print(end-start)
print(outputs)
