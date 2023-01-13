import onnxruntime as rt
import numpy as  np
data1 = np.array([[1,1],[2,2],[3,3]],np.dtype(np.float32))
data2 = np.array([[1,1],[2,2],[3,3]],np.dtype(np.float32))
sess = rt.InferenceSession('./add.onnx')

out = sess.run([],{"X1":data1.astype(np.float32),"X2":data2.astype(np.float32) })
print(out)
