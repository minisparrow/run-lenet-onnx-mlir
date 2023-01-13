// RUN: onnx-mlir-opt --convert-krnl-to-affine %s -split-input-file | FileCheck %s

// func.func @test_krnl_load_with_krnl_iterate(%arg0: memref<10x10xf32>, %arg1: memref<10x?xf32>) -> memref<10x10xf32> {
//   %0 = memref.alloc() : memref<10x10xf32>
//   %c0 = constant 0 : index
//   %c1 = constant 1 : index
//   %1 = memref.dim %arg1, %c1 : memref<10x?xf32>
//   %2:2 = krnl.define_loops 2
//   krnl.iterate(%2#0, %2#1) with (%2#0 -> %arg2 = 0 to 10, %2#1 -> %arg3 = 0 to 10) {
//     %3 = krnl.load %arg0[%arg2, %arg3] : memref<10x10xf32>
//     %4 = cmpi sgt, %1, %c1 : index
//     %5 = select %4, %arg3, %c0 : index
//     %6 = krnl.load %arg1[%arg2, %5] : memref<10x?xf32>
//     %7 = addf %3, %6 : f32
//     krnl.store %7, %0[%arg2, %arg3] : memref<10x10xf32>
//   }
//   return %0 : memref<10x10xf32>
// 
//   // CHECK-LABEL:  @test_krnl_load_with_krnl_iterate
//   // CHECK:  affine.for {{.*}}
//   // CHECK:    affine.for {{.*}}
//   // CHECK:      {{.*}} = affine.load {{.*}} : memref<10x10xf32>
//   // CHECK:      {{.*}} = memref.load {{.*}} : memref<10x?xf32>
//   // CHECK:      affine.store {{.*}} : memref<10x10xf32>
// }

// func.func @test_krnl_load_store(%arg0: memref<10x10xf32>) -> memref<1xf32> {
//   %c0 = arith.constant 0 : index
//   %1 = krnl.load %arg0[%c0, %c0] : memref<10x10xf32>
//   %2 = memref.alloc() : memref<1xf32>
//   krnl.store %1, %2[%c0] : memref<1xf32>
//   return %2 : memref<1xf32>
// 
//   // CHECK-LABEL: test_krnl_load_store
//   // CHECK: [[C0:%.+]] = constant 0 : index
//   // CHECK: [[LOAD:%.+]] = affine.load %arg0{{\[}}[[C0]], [[C0]]{{\]}} : memref<10x10xf32>
//   // CHECK: [[RES:%.+]]  = memref.alloc() : memref<1xf32>
//   // CHECK: affine.store [[LOAD]], [[RES]]{{\[}}[[C0]]{{\]}} : memref<1xf32>
// 
// }

func.func private @matmulKrnl_full_tiles(%A: memref<4x6xf32>, %B: memref<6x8xf32>, %C: memref<4x8xf32>) {
    %c0 = arith.constant 0: index
    %c4 = arith.constant 4: index // N
    %c6 = arith.constant 6: index // K
    %c8 = arith.constant 8: index // M
    %ii, %jj, %kk = krnl.define_loops 3
    %ib, %il = krnl.block %ii 4 : (!krnl.loop) -> (!krnl.loop, !krnl.loop)
    %jb, %jl = krnl.block %jj 8 : (!krnl.loop) -> (!krnl.loop, !krnl.loop)
    %kb, %kl = krnl.block %kk 6 : (!krnl.loop) -> (!krnl.loop, !krnl.loop)
    krnl.permute(%ib, %il, %jb, %jl, %kb, %kl) [0, 3, 1, 4, 2, 5] : !krnl.loop, !krnl.loop, !krnl.loop, !krnl.loop, !krnl.loop, !krnl.loop
    krnl.iterate(%ib, %jb, %kb) with (%ii -> %i = 0 to 4, %jj -> %j = 0 to 8, %kk -> %k = 0 to 6) {
        //%iii, %jjj, %kkk = krnl.get_induction_var_value(%ib, %jb, %kb) : (!krnl.loop, !krnl.loop, !krnl.loop) -> (index, index, index)
        krnl.matmul %A [%c0, %c0], %B[%c0, %c0], %C[%c0, %c0], (%il, %jl, %kl), (%c0, %c0, %c0), (%c4, %c8, %c6) 
            {unroll=false, simdize=true} : 
            memref<4x6xf32>, memref<6x8xf32>, memref<4x8xf32>, (!krnl.loop, !krnl.loop, !krnl.loop)
    }
    return
}
