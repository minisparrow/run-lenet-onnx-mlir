#map0 = affine_map<()[s0, s1] -> (s0 - s1, 4)>
#map1 = affine_map<()[s0, s1] -> (s0 - s1, 6)>
#map2 = affine_map<()[s0, s1] -> (s0 - s1)>
#set0 = affine_set<() : (1 >= 0, 1 >= 0, 1 >= 0)>
#set1 = affine_set<()[s0, s1, s2, s3, s4, s5] : (-s3 + s0 - 4 >= 0, -s5 + s1 - 8 >= 0, -s4 + s2 - 6 >= 0)>
#set2 = affine_set<()[s0, s1] : (-s1 + s0 - 8 >= 0)>
module  {
  func private @matmulKrnl_full_tiles(%arg0: memref<4x6xf32>, %arg1: memref<6x8xf32>, %arg2: memref<4x8xf32>) {
    affine.for %arg3 = 0 to 4 step 4 {
      affine.for %arg4 = 0 to 8 step 8 {
        affine.for %arg5 = 0 to 6 step 6 {
          affine.if #set0() {
            %0 = krnl.vector_type_cast %arg1 : memref<6x8xf32> to memref<6x1xvector<8xf32>>
            %1 = krnl.vector_type_cast %arg2 : memref<4x8xf32> to memref<4x1xvector<8xf32>>
            %2 = memref.alloca() {alignment = 64 : i64} : memref<vector<8xf32>>
            affine.for %arg6 = 0 to 4 {
              %3 = affine.load %1[%arg6, 0] : memref<4x1xvector<8xf32>>
              affine.store %3, %2[] : memref<vector<8xf32>>
              affine.for %arg7 = 0 to 6 {
                %5 = affine.load %arg0[%arg6, %arg7] : memref<4x6xf32>
                %6 = vector.broadcast %5 : f32 to vector<8xf32>
                %7 = affine.load %0[%arg7, 0] : memref<6x1xvector<8xf32>>
                %8 = affine.load %2[] : memref<vector<8xf32>>
                %9 = vector.fma %6, %7, %8 : vector<8xf32>
                affine.store %9, %2[] : memref<vector<8xf32>>
              }
              %4 = affine.load %2[] : memref<vector<8xf32>>
              affine.store %4, %1[%arg6, 0] : memref<4x1xvector<8xf32>>
            }
          }
        }
      }
    }
    return
  }
  func @matmulKrnl_runtime(%arg0: memref<4x6xf32>, %arg1: memref<6x8xf32>, %arg2: memref<4x8xf32>, %arg3: index, %arg4: index, %arg5: index, %arg6: index, %arg7: index, %arg8: index) {
    affine.for %arg9 = 0 to 4 step 4 {
      affine.for %arg10 = 0 to 8 step 8 {
        affine.for %arg11 = 0 to 6 step 6 {
          affine.if #set1()[%arg6, %arg7, %arg8, %arg3, %arg5, %arg4] {
            %0 = krnl.vector_type_cast %arg1 : memref<6x8xf32> to memref<6x1xvector<8xf32>>
            %1 = krnl.vector_type_cast %arg2 : memref<4x8xf32> to memref<4x1xvector<8xf32>>
            %2 = memref.alloca() {alignment = 64 : i64} : memref<vector<8xf32>>
            affine.for %arg12 = 0 to 4 {
              %3 = affine.load %1[%arg12 + symbol(%arg3), symbol(%arg4) floordiv 8] : memref<4x1xvector<8xf32>>
              affine.store %3, %2[] : memref<vector<8xf32>>
              affine.for %arg13 = 0 to 6 {
                %5 = affine.load %arg0[%arg12 + symbol(%arg3), %arg13 + symbol(%arg5)] : memref<4x6xf32>
                %6 = vector.broadcast %5 : f32 to vector<8xf32>
                %7 = affine.load %0[%arg13 + symbol(%arg5), symbol(%arg4) floordiv 8] : memref<6x1xvector<8xf32>>
                %8 = affine.load %2[] : memref<vector<8xf32>>
                %9 = vector.fma %6, %7, %8 : vector<8xf32>
                affine.store %9, %2[] : memref<vector<8xf32>>
              }
              %4 = affine.load %2[] : memref<vector<8xf32>>
              affine.store %4, %1[%arg12 + symbol(%arg3), symbol(%arg4) floordiv 8] : memref<4x1xvector<8xf32>>
            }
          } else {
            affine.if #set2()[%arg7, %arg4] {
              %0 = krnl.vector_type_cast %arg1 : memref<6x8xf32> to memref<6x1xvector<8xf32>>
              %1 = krnl.vector_type_cast %arg2 : memref<4x8xf32> to memref<4x1xvector<8xf32>>
              %2 = memref.alloca() {alignment = 64 : i64} : memref<vector<8xf32>>
              affine.for %arg12 = 0 to min #map0()[%arg6, %arg3] {
                %3 = affine.load %1[%arg12 + symbol(%arg3), symbol(%arg4) floordiv 8] : memref<4x1xvector<8xf32>>
                affine.store %3, %2[] : memref<vector<8xf32>>
                affine.for %arg13 = 0 to min #map1()[%arg8, %arg5] {
                  %5 = affine.load %arg0[%arg12 + symbol(%arg3), %arg13 + symbol(%arg5)] : memref<4x6xf32>
                  %6 = vector.broadcast %5 : f32 to vector<8xf32>
                  %7 = affine.load %0[%arg13 + symbol(%arg5), symbol(%arg4) floordiv 8] : memref<6x1xvector<8xf32>>
                  %8 = affine.load %2[] : memref<vector<8xf32>>
                  %9 = vector.fma %6, %7, %8 : vector<8xf32>
                  affine.store %9, %2[] : memref<vector<8xf32>>
                }
                %4 = affine.load %2[] : memref<vector<8xf32>>
                affine.store %4, %1[%arg12 + symbol(%arg3), symbol(%arg4) floordiv 8] : memref<4x1xvector<8xf32>>
              }
            } else {
              %0 = memref.alloca() {alignment = 64 : i64} : memref<f32>
              affine.for %arg12 = 0 to min #map0()[%arg6, %arg3] {
                affine.for %arg13 = 0 to #map2()[%arg7, %arg4] {
                  %1 = affine.load %arg2[%arg12 + symbol(%arg3), %arg13 + symbol(%arg4)] : memref<4x8xf32>
                  affine.store %1, %0[] : memref<f32>
                  affine.for %arg14 = 0 to min #map1()[%arg8, %arg5] {
                    %3 = affine.load %arg0[%arg12 + symbol(%arg3), %arg14 + symbol(%arg5)] : memref<4x6xf32>
                    %4 = affine.load %arg1[%arg14 + symbol(%arg5), %arg13 + symbol(%arg4)] : memref<6x8xf32>
                    %5 = affine.load %0[] : memref<f32>
                    %6 = mulf %3, %4 : f32
                    %7 = addf %6, %5 : f32
                    affine.store %7, %0[] : memref<f32>
                  }
                  %2 = affine.load %0[] : memref<f32>
                  affine.store %2, %arg2[%arg12 + symbol(%arg3), %arg13 + symbol(%arg4)] : memref<4x8xf32>
                }
              }
            }
          }
        }
      }
    }
    return
  }
}

