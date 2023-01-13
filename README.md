# run-lenet-onnx-mlir

## 运行lenet

onnx model ->   mlir  ->    runtime  

## 1. 训练lenet网络并保存输出为lenet.onnx模型

lenet.onnx 

## 2. onnx-mlir将onnx 模型转为 mlir-library.

```
$ <onnx-mlir> lenet.onnx --EmitLib -o liblenet
```

python3 RunONNXModel.py --model onnx-model/lenet.onnx  --save-so ./so-lib/lenet.so

## 3. 安装Python依赖库并运行runtime跑推理

pip3 install opencv-python

PyRuntime.cpython-38-x86_64-linux-gnu.so 的库文件是通过软链接，将onnx-mlir/build/Debug/lib/PyRuntime...链接到此

ln -s PyRuntime..... 


## 4. 运行推理吧

```
python3 onnx-mlir-runtime.py 
```

