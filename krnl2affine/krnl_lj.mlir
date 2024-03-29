// RUN: onnx-mlir-opt --convert-krnl-to-affine %s -split-input-file | FileCheck %s

func @test_lower_degenerate_iterate(%arg0: memref<f32>) -> memref<f32> {
  %0 = memref.alloc() : memref<f32>
  krnl.iterate() with () {
    %1 = memref.load %arg0[] : memref<f32>
    memref.store %1, %0[] : memref<f32>
  }
  return %0 : memref<f32>
  // CHECK-LABEL: test_lower_degenerate_iterate
  // CHECK-NEXT: [[ALLOC:%.+]] = memref.alloc() : memref<f32>
  // CHECK-NEXT: [[LOAD:%.+]] = memref.load %{{.*}}[] : memref<f32>
  // CHECK-NEXT: store [[LOAD]], [[ALLOC]][] : memref<f32>
  // CHECK-NEXT: return [[ALLOC]] : memref<f32>
}
