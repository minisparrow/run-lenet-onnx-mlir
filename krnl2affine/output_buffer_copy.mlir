#map0 = affine_map<()[s0] -> (-s0 + 39, 4)>
#map1 = affine_map<()[s0] -> (-s0 + 56, 6)>
#map2 = affine_map<(d0) -> (-d0 + 45, 10)>
module  {
  func private @copy_to(%arg0: index, %arg1: index) {
    %0 = memref.alloca() : memref<40x60xf32>
    %1 = memref.alloca() : memref<4x6xf32>
    affine.for %arg2 = 0 to 4 {
      affine.for %arg3 = 0 to 6 {
        %2 = affine.load %0[%arg2 + 10, %arg3 + 12] : memref<40x60xf32>
        affine.store %2, %1[%arg2, %arg3] : memref<4x6xf32>
      }
    }
    return
  }
  func private @copy_to_larger_source(%arg0: index, %arg1: index) {
    %0 = memref.alloca() : memref<5x10x40x60xf32>
    %1 = memref.alloca() : memref<4x6xf32>
    affine.for %arg2 = 0 to 4 {
      affine.for %arg3 = 0 to 6 {
        %2 = affine.load %0[2, 3, %arg2 + 10, %arg3 + 12] : memref<5x10x40x60xf32>
        affine.store %2, %1[%arg2, %arg3] : memref<4x6xf32>
      }
    }
    return
  }
  func private @copy_to_larger_transposed_source(%arg0: index, %arg1: index) {
    %0 = memref.alloca() : memref<5x10x60x40xf32>
    %1 = memref.alloca() : memref<4x6xf32>
    affine.for %arg2 = 0 to 4 {
      affine.for %arg3 = 0 to 6 {
        %2 = affine.load %0[2, 3, %arg3 + 12, %arg2 + 10] : memref<5x10x60x40xf32>
        affine.store %2, %1[%arg2, %arg3] : memref<4x6xf32>
      }
    }
    return
  }
  func private @copy_to_nopad(%arg0: index, %arg1: index) {
    %0 = memref.alloca() : memref<40x60xf32>
    %1 = memref.alloca() : memref<4x6xf32>
    affine.for %arg2 = 0 to 4 {
      affine.for %arg3 = 0 to 6 {
        %2 = affine.load %0[%arg2 + 10, %arg3 + 12] : memref<40x60xf32>
        affine.store %2, %1[%arg2, %arg3] : memref<4x6xf32>
      }
    }
    return
  }
  func private @copy_to_nopad_last_fully_in(%arg0: index, %arg1: index) {
    %0 = memref.alloca() : memref<40x60xf32>
    %1 = memref.alloca() : memref<4x6xf32>
    affine.for %arg2 = 0 to 4 {
      affine.for %arg3 = 0 to 6 {
        %2 = affine.load %0[%arg2 + 36, %arg3 + 54] : memref<40x60xf32>
        affine.store %2, %1[%arg2, %arg3] : memref<4x6xf32>
      }
    }
    return
  }
  func private @copy_to_nopad_runtime_param(%arg0: index, %arg1: index) {
    %0 = memref.alloca() : memref<40x60xf32>
    %1 = memref.alloca() : memref<4x6xf32>
    affine.for %arg2 = 0 to 4 {
      affine.for %arg3 = 0 to 6 {
        %2 = affine.load %0[%arg2 + symbol(%arg0), %arg3 + symbol(%arg1)] : memref<40x60xf32>
        affine.store %2, %1[%arg2, %arg3] : memref<4x6xf32>
      }
    }
    return
  }
  func private @copy_to_nopad_partial(%arg0: index, %arg1: index) {
    %0 = memref.alloca() : memref<39x56xf32>
    %1 = memref.alloca() : memref<4x6xf32>
    affine.for %arg2 = 0 to 3 {
      affine.for %arg3 = 0 to 2 {
        %2 = affine.load %0[%arg2 + 36, %arg3 + 54] : memref<39x56xf32>
        affine.store %2, %1[%arg2, %arg3] : memref<4x6xf32>
      }
    }
    return
  }
  func private @copy_to_pad_partial(%arg0: index, %arg1: index) {
    %cst = constant 0.000000e+00 : f32
    %0 = memref.alloca() : memref<39x56xf32>
    %1 = memref.alloca() : memref<4x6xf32>
    affine.for %arg2 = 0 to 3 {
      affine.for %arg3 = 0 to 2 {
        %2 = affine.load %0[%arg2 + 36, %arg3 + 54] : memref<39x56xf32>
        affine.store %2, %1[%arg2, %arg3] : memref<4x6xf32>
      }
      affine.for %arg3 = 2 to 6 {
        affine.store %cst, %1[%arg2, %arg3] : memref<4x6xf32>
      }
    }
    affine.for %arg2 = 3 to 4 {
      affine.for %arg3 = 0 to 6 {
        affine.store %cst, %1[%arg2, %arg3] : memref<4x6xf32>
      }
    }
    return
  }
  func private @copy_to_pad_partial_transposed(%arg0: index, %arg1: index) {
    %cst = constant 0.000000e+00 : f32
    %0 = memref.alloca() : memref<56x39xf32>
    %1 = memref.alloca() : memref<4x6xf32>
    affine.for %arg2 = 0 to 3 {
      affine.for %arg3 = 0 to 2 {
        %2 = affine.load %0[%arg3 + 54, %arg2 + 36] : memref<56x39xf32>
        affine.store %2, %1[%arg2, %arg3] : memref<4x6xf32>
      }
      affine.for %arg3 = 2 to 6 {
        affine.store %cst, %1[%arg2, %arg3] : memref<4x6xf32>
      }
    }
    affine.for %arg2 = 3 to 4 {
      affine.for %arg3 = 0 to 6 {
        affine.store %cst, %1[%arg2, %arg3] : memref<4x6xf32>
      }
    }
    return
  }
  func private @copy_to_pad_partial_mod3(%arg0: index, %arg1: index) {
    %cst = constant 0.000000e+00 : f32
    %0 = memref.alloca() : memref<39x56xf32>
    %1 = memref.alloca() : memref<4x6xf32>
    affine.for %arg2 = 0 to 3 {
      affine.for %arg3 = 0 to 2 {
        %2 = affine.load %0[%arg2 + 36, %arg3 + 54] : memref<39x56xf32>
        affine.store %2, %1[%arg2, %arg3] : memref<4x6xf32>
      }
      affine.for %arg3 = 2 to 3 {
        affine.store %cst, %1[%arg2, %arg3] : memref<4x6xf32>
      }
    }
    return
  }
  func private @copy_to_runtime_start_indices(%arg0: index, %arg1: index) {
    %0 = memref.alloca() : memref<39x56xf32>
    %1 = memref.alloca() : memref<4x6xf32>
    affine.for %arg2 = 0 to min #map0()[%arg0] {
      affine.for %arg3 = 0 to min #map1()[%arg1] {
        %2 = affine.load %0[%arg2 + symbol(%arg0), %arg3 + symbol(%arg1)] : memref<39x56xf32>
        affine.store %2, %1[%arg2, %arg3] : memref<4x6xf32>
      }
    }
    return
  }
  func private @copy_to_runtime_start_indices_pad3(%arg0: index, %arg1: index) {
    %cst = constant 0.000000e+00 : f32
    %c3 = constant 3 : index
    %0 = memref.alloca() : memref<39x56xf32>
    %1 = memref.alloca() : memref<4x6xf32>
    %2 = affine.min #map0()[%arg0]
    %3 = ceildivi_signed %2, %c3 : index
    %4 = muli %3, %c3 : index
    %5 = affine.min #map1()[%arg1]
    %6 = ceildivi_signed %5, %c3 : index
    %7 = muli %6, %c3 : index
    affine.for %arg2 = 0 to min #map0()[%arg0] {
      affine.for %arg3 = 0 to min #map1()[%arg1] {
        %8 = affine.load %0[%arg2 + symbol(%arg0), %arg3 + symbol(%arg1)] : memref<39x56xf32>
        affine.store %8, %1[%arg2, %arg3] : memref<4x6xf32>
      }
      affine.for %arg3 = max #map1()[%arg1] to %7 {
        affine.store %cst, %1[%arg2, %arg3] : memref<4x6xf32>
      }
    }
    affine.for %arg2 = max #map0()[%arg0] to %4 {
      affine.for %arg3 = 0 to %7 {
        affine.store %cst, %1[%arg2, %arg3] : memref<4x6xf32>
      }
    }
    return
  }
  func private @copy_to_runtime_start_indices_larger_source(%arg0: index, %arg1: index) {
    %cst = constant 0.000000e+00 : f32
    %c3 = constant 3 : index
    %0 = memref.alloca() : memref<5x10x39x56xf32>
    %1 = memref.alloca() : memref<4x6xf32>
    %2 = affine.min #map0()[%arg0]
    %3 = ceildivi_signed %2, %c3 : index
    %4 = muli %3, %c3 : index
    %5 = affine.min #map1()[%arg1]
    %6 = ceildivi_signed %5, %c3 : index
    %7 = muli %6, %c3 : index
    affine.for %arg2 = 0 to min #map0()[%arg0] {
      affine.for %arg3 = 0 to min #map1()[%arg1] {
        %8 = affine.load %0[2, 5, %arg2 + symbol(%arg0), %arg3 + symbol(%arg1)] : memref<5x10x39x56xf32>
        affine.store %8, %1[%arg2, %arg3] : memref<4x6xf32>
      }
      affine.for %arg3 = max #map1()[%arg1] to %7 {
        affine.store %cst, %1[%arg2, %arg3] : memref<4x6xf32>
      }
    }
    affine.for %arg2 = max #map0()[%arg0] to %4 {
      affine.for %arg3 = 0 to %7 {
        affine.store %cst, %1[%arg2, %arg3] : memref<4x6xf32>
      }
    }
    return
  }
  func @copy_to_nested(%arg0: index, %arg1: index) {
    %0 = memref.alloca() : memref<40x60xf32>
    %1 = memref.alloca() : memref<10x60xf32>
    affine.for %arg2 = 0 to 40 step 10 {
      affine.for %arg3 = 0 to 10 {
        affine.for %arg4 = 0 to 60 {
          %2 = affine.load %0[%arg2 + %arg3, %arg4] : memref<40x60xf32>
          affine.store %2, %1[%arg3, %arg4] : memref<10x60xf32>
        }
      }
    }
    return
  }
  func @copy_to_nested_partial(%arg0: index, %arg1: index) {
    %0 = memref.alloca() : memref<45x60xf32>
    %1 = memref.alloca() : memref<10x60xf32>
    affine.for %arg2 = 0 to 45 step 10 {
      affine.for %arg3 = 0 to min #map2(%arg2) {
        affine.for %arg4 = 0 to 60 {
          %2 = affine.load %0[%arg2 + %arg3, %arg4] : memref<45x60xf32>
          affine.store %2, %1[%arg3, %arg4] : memref<10x60xf32>
        }
      }
    }
    return
  }
  func private @copy_from_simple(%arg0: index, %arg1: index) {
    %0 = memref.alloca() : memref<40x60xf32>
    %1 = memref.alloca() : memref<4x6xf32>
    affine.for %arg2 = 0 to 4 {
      affine.for %arg3 = 0 to 6 {
        %2 = affine.load %1[%arg2, %arg3] : memref<4x6xf32>
        affine.store %2, %0[%arg2 + 10, %arg3 + 12] : memref<40x60xf32>
      }
    }
    return
  }
  func private @copy_from_simple_from_larger(%arg0: index, %arg1: index) {
    %0 = memref.alloca() : memref<5x10x40x60xf32>
    %1 = memref.alloca() : memref<4x6xf32>
    affine.for %arg2 = 0 to 4 {
      affine.for %arg3 = 0 to 6 {
        %2 = affine.load %1[%arg2, %arg3] : memref<4x6xf32>
        affine.store %2, %0[2, 5, %arg2 + 10, %arg3 + 12] : memref<5x10x40x60xf32>
      }
    }
    return
  }
  func private @copy_from_simple_last(%arg0: index, %arg1: index) {
    %0 = memref.alloca() : memref<40x60xf32>
    %1 = memref.alloca() : memref<4x6xf32>
    affine.for %arg2 = 0 to 4 {
      affine.for %arg3 = 0 to 6 {
        %2 = affine.load %1[%arg2, %arg3] : memref<4x6xf32>
        affine.store %2, %0[%arg2 + 36, %arg3 + 54] : memref<40x60xf32>
      }
    }
    return
  }
  func private @copy_from_simple_runtime(%arg0: index, %arg1: index) {
    %0 = memref.alloca() : memref<40x60xf32>
    %1 = memref.alloca() : memref<4x6xf32>
    affine.for %arg2 = 0 to 4 {
      affine.for %arg3 = 0 to 6 {
        %2 = affine.load %1[%arg2, %arg3] : memref<4x6xf32>
        affine.store %2, %0[%arg2 + symbol(%arg0), %arg3 + symbol(%arg1)] : memref<40x60xf32>
      }
    }
    return
  }
  func private @copy_from_partial(%arg0: index, %arg1: index) {
    %0 = memref.alloca() : memref<39x56xf32>
    %1 = memref.alloca() : memref<4x6xf32>
    affine.for %arg2 = 0 to 3 {
      affine.for %arg3 = 0 to 2 {
        %2 = affine.load %1[%arg2, %arg3] : memref<4x6xf32>
        affine.store %2, %0[%arg2 + 36, %arg3 + 54] : memref<39x56xf32>
      }
    }
    return
  }
  func private @copy_from_partial_runtime(%arg0: index, %arg1: index) {
    %0 = memref.alloca() : memref<39x56xf32>
    %1 = memref.alloca() : memref<4x6xf32>
    affine.for %arg2 = 0 to min #map0()[%arg0] {
      affine.for %arg3 = 0 to min #map1()[%arg1] {
        %2 = affine.load %1[%arg2, %arg3] : memref<4x6xf32>
        affine.store %2, %0[%arg2 + symbol(%arg0), %arg3 + symbol(%arg1)] : memref<39x56xf32>
      }
    }
    return
  }
}

