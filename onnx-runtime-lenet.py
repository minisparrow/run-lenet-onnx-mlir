import cv2
import onnxruntime as rt
import numpy as  np

session = rt.InferenceSession("./lenet.onnx")

img = cv2.imread('mnist_0.png')

input = np.array(img[:,:,0], np.dtype(np.float32))
outputs = session.run([],{"import/Placeholder:0":input.reshape(1,1,28,28)})
print(outputs)
