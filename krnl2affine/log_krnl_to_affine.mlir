#map = affine_map<(d0) -> (d0 + 1)>
module  {
  func @test_lower_degenerate_iterate(%arg0: memref<f32>) -> memref<f32> {
    %0 = memref.alloc() : memref<f32>
    %1 = memref.load %arg0[] : memref<f32>
    memref.store %1, %0[] : memref<f32>
    return %0 : memref<f32>
  }
  func @test_krnl_load_store(%arg0: memref<10x10xf32>) -> memref<1xf32> {
    %c0 = constant 0 : index
    %0 = affine.load %arg0[%c0, %c0] : memref<10x10xf32>
    %1 = memref.alloc() : memref<1xf32>
    affine.store %0, %1[%c0] : memref<1xf32>
    return %1 : memref<1xf32>
  }
  func @test_krnl_load_with_krnl_iterate(%arg0: memref<10x10xf32>, %arg1: memref<10x?xf32>) -> memref<10x10xf32> {
    %0 = memref.alloc() : memref<10x10xf32>
    %c0 = constant 0 : index
    %c1 = constant 1 : index
    %1 = memref.dim %arg1, %c1 : memref<10x?xf32>
    affine.for %arg2 = 0 to 10 {
      affine.for %arg3 = 0 to 10 {
        %2 = affine.load %arg0[%arg2, %arg3] : memref<10x10xf32>
        %3 = cmpi sgt, %1, %c1 : index
        %4 = select %3, %arg3, %c0 : index
        %5 = memref.load %arg1[%arg2, %4] : memref<10x?xf32>
        %6 = addf %2, %5 : f32
        affine.store %6, %0[%arg2, %arg3] : memref<10x10xf32>
      }
    }
    return %0 : memref<10x10xf32>
  }
  func @test_krnl_store_with_krnl_iterate(%arg0: memref<10x10xf32>, %arg1: memref<10x?xf32>) -> memref<10x10xf32> {
    %0 = memref.alloc() : memref<10x10xf32>
    %c0 = constant 0 : index
    %c1 = constant 1 : index
    %1 = memref.dim %arg1, %c1 : memref<10x?xf32>
    affine.for %arg2 = 0 to 10 {
      affine.for %arg3 = 0 to 10 {
        %2 = affine.load %arg0[%arg2, %arg3] : memref<10x10xf32>
        %3 = cmpi sgt, %1, %c1 : index
        %4 = select %3, %arg3, %c0 : index
        %5 = memref.load %arg1[%arg2, %4] : memref<10x?xf32>
        %6 = addf %2, %5 : f32
        memref.store %6, %0[%arg2, %4] : memref<10x10xf32>
      }
    }
    return %0 : memref<10x10xf32>
  }
  func @test_krnl_load_store_with_affine(%arg0: memref<10x10xf32>, %arg1: memref<10x?xf32>) -> memref<10x10xf32> {
    %0 = memref.alloc() : memref<10x10xf32>
    %c0 = constant 0 : index
    %c1 = constant 1 : index
    %1 = memref.dim %arg1, %c1 : memref<10x?xf32>
    affine.for %arg2 = 0 to 10 {
      affine.for %arg3 = 0 to 10 {
        %2 = affine.load %arg0[%arg2, %arg3] : memref<10x10xf32>
        %3 = affine.apply #map(%arg3)
        %4 = affine.load %arg1[%arg2, %3] : memref<10x?xf32>
        affine.store %4, %0[%arg2, %3] : memref<10x10xf32>
      }
    }
    return %0 : memref<10x10xf32>
  }
}

