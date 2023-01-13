#!/usr/bin/env python
# coding=utf-8

import numpy as np
from PyCompileAndRuntime import OMCompileExecutionSession

from PyRuntime import OMExecutionSession


# Load onnx model and create OMCompileExecutionSession object.
inputFileName = './onnx-model/lenet.onnx'
# Set the full name of compiled model
sharedLibPath = './so-lib/lenet.so'
# Set the compile option as "-O3"
# session = OMCompileExecutionSession(inputFileName,sharedLibPath,"-O3")
session = OMExecutionSession(sharedLibPath, use_default_entry_point=True)

# Print the models input/output signature, for display.

# Do inference using the default entry point.
a = np.full((1, 1, 28, 28), 1, np.dtype(np.float32))
outputs = session.run(input=[a])

for output in outputs:
    print(output.shape)
    print(output)

