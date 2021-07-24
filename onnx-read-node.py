import onnx 
model = onnx.load('lenet.onnx')
onnx.checker.check_model(model)
output = model.graph.output
input = model.graph.input
print(output)
print(input)
