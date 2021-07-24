import numpy as np
from PyRuntime import ExecutionSession


model = './add.so'
session = ExecutionSession(model, "run_main_graph")

input = np.array([[[1,1],[2,2],[3,3]],[[1,2],[2,2],[3,3]]], np.dtype(np.float32))
outputs = session.run(input)
print(outputs)
