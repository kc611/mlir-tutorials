import ctypes
import numpy as np

module = ctypes.CDLL('./libmatrix_conv_parallel.so')

def as_memref_descriptor(arr, ty):
    intptr_t = getattr(ctypes, f"c_int{8 * ctypes.sizeof(ctypes.c_void_p)}")
    ty_ptr = ctypes.POINTER(ty)

    arg0 = ctypes.cast(arr.ctypes.data, ty_ptr)
    arg1 = arg0
    arg2 = intptr_t(0)

    shapes_arg = [intptr_t(x) for x in arr.shape]
    strides_arg = [intptr_t(x) for x in arr.strides]

    return arg0, arg1, arg2, *shapes_arg, *strides_arg

array_1 = np.ones(10000, dtype=np.float64).reshape(100, 100)
conv_filter = np.arange(9, dtype=np.float64).reshape(3, 3)
res_array = np.zeros((98, 98), dtype=np.float64)

array_1_as_memref = as_memref_descriptor(array_1, ctypes.c_float)
conv_filter_as_memref = as_memref_descriptor(conv_filter, ctypes.c_float)
res_array_as_memref = as_memref_descriptor(res_array, ctypes.c_float)

argtypes = [
    *[type(x) for x in array_1_as_memref], 
    *[type(x) for x in conv_filter_as_memref], 
    *[type(x) for x in res_array_as_memref]]

module.conv_2d.argtypes = argtypes
module.conv_2d.restype = ctypes.c_float

def conv_2d(*args):
    return module.conv_2d(*args)

print(conv_2d(*array_1_as_memref, *conv_filter_as_memref, *res_array_as_memref))
np.set_printoptions(threshold=np.inf)
print(res_array)


