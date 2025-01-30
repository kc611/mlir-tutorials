import ctypes
import numpy as np

module = ctypes.CDLL('./libarray_index.so')

# array_index.mlir:

# func.func @array_sum(%buffer: memref<1024xf32>, %array_idx: index) -> (f32) {
#   %res = memref.load %buffer[%array_idx] : memref<1024xf32>
#   return %res : f32
# }

def array_sum(allocated, aligned, offset, shape_1, stride_1, start):
    return module.array_sum(allocated, aligned, offset, shape_1, stride_1, start)

def as_memref_descriptor(arr, ty):
    intptr_t = getattr(ctypes, f"c_int{8 * ctypes.sizeof(ctypes.c_void_p)}")
    N = arr.ndim

    ty_ptr = ctypes.POINTER(ty)

    arg0 = ctypes.cast(arr.ctypes.data, ty_ptr)
    arg1 = arg0
    arg2 = intptr_t(0)

    shapes_arg = [intptr_t(x) for x in arr.shape]
    strides_arg = [intptr_t(x) for x in arr.strides]

    return arg0, arg1, arg2, *shapes_arg, *strides_arg

# The array is a list of 1024 elements, all of which are 1.
array = np.arange(1024, dtype=np.float32)

array_as_memref = as_memref_descriptor(array, ctypes.c_float)

module.array_sum.argtypes = [*[type(x) for x in array_as_memref], ctypes.c_int]
module.array_sum.restype = ctypes.c_float

print(array_sum(*array_as_memref,  105))

