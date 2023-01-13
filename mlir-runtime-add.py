import numpy as np
from PyRuntime import OMExecutionSession


model = './so-lib/add.so'
session = OMExecutionSession(shared_lib_path=model) 

input = np.array([[[1,1],[2,2],[3,3]],[[1,2],[2,2],[3,3]]], np.dtype(np.float32))
outputs = session.run(input)
print(outputs)


"""
import numpy as np
from PyRuntime import OMExecutionSession

model = './add.so'

# Create a session for this model.
session = OMExecutionSession(shared_lib_path=model, use_default_entry_point=False) # False to manually set an entry point.

# Query entry points in the model.
entry_points = session.entry_points()

for entry_point in entry_points:
  # Set the entry point to do inference.
  session.set_entry_point(name=entry_point)
  # Input and output signatures of the current entry point.
  print("input signature in json", session.input_signature())
  print("output signature in json",session.output_signature())
  # Do inference using the current entry point.
  a = np.arange(10).astype('float32')
  b = np.arange(10).astype('float32')
  outputs = session.run(input=[a, b])
  for output in outputs:
    print(output.shape)

"""
