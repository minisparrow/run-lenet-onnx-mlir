import cv2
import onnxruntime as rt
import numpy as  np
import onnx
import time

# model = onnx.load("./resnet50v1.onnx")

img = cv2.imread('kitten.jpg')

print(img.shape)
img.resize(3,224,224)
print(img.shape)
input = np.array(img, np.dtype(np.float32))
# input = model.graph.input

session = rt.InferenceSession("./resnet50v1.onnx")
start = time.perf_counter()
outputs = session.run([],{"data":input.reshape(1,3,224,224)})
end = time.perf_counter()
print("time execute: ")
print(end-start)
print(outputs)
