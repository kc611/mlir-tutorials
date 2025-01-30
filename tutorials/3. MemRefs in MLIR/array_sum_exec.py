import ctypes
import numpy as np

module = ctypes.CDLL('./libarray_sum.so')

def array_sum(allocated, aligned, offset, shape_1, stride_1, start, stop, step):
    return module.array_sum(allocated, aligned, offset, shape_1, stride_1, start, stop, step)

def as_memref_descriptor(arr, ty):
    intptr_t = getattr(ctypes, f"c_int{8 * ctypes.sizeof(ctypes.c_void_p)}")
    ty_ptr = ctypes.POINTER(ty)

    arg0 = ctypes.cast(arr.ctypes.data, ty_ptr)
    arg1 = arg0
    arg2 = intptr_t(0)

    shapes_arg = [intptr_t(x) for x in arr.shape]
    strides_arg = [intptr_t(x) for x in arr.strides]

    return arg0, arg1, arg2, *shapes_arg, *strides_arg

array = np.arange(1024, dtype=np.float32)

array_as_memref = as_memref_descriptor(array, ctypes.c_float)

module.array_sum.argtypes = [*[type(x) for x in array_as_memref], ctypes.c_long, ctypes.c_long, ctypes.c_long]
module.array_sum.restype = ctypes.c_float

print(module.array_sum.argtypes)
# [<class '__main__.LP_c_float'>, <class '__main__.LP_c_float'>, <class 'ctypes.c_long'>, <class 'ctypes.c_long'>, <class 'ctypes.c_long'>, <class 'ctypes.c_long'>, <class 'ctypes.c_long'>, <class 'ctypes.c_long'>]

print(array_sum(*array_as_memref, 0, 1024, 1))
# Outputs: 522754.0.0
