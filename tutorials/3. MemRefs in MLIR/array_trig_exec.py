import ctypes
import numpy as np

module = ctypes.CDLL('./libarray_trig.so')

def as_memref_descriptor(arr, ty):
    intptr_t = getattr(ctypes, f"c_int{8 * ctypes.sizeof(ctypes.c_void_p)}")
    ty_ptr = ctypes.POINTER(ty)

    arg0 = ctypes.cast(arr.ctypes.data, ty_ptr)
    arg1 = arg0
    arg2 = intptr_t(0)

    shapes_arg = [intptr_t(x) for x in arr.shape]
    strides_arg = [intptr_t(x) for x in arr.strides]

    return arg0, arg1, arg2, *shapes_arg, *strides_arg

array_1 = np.arange(1024, dtype=np.float64)
array_2 = np.arange(1024, dtype=np.float64)
res_array = np.zeros(1024, dtype=np.float64)

array_1_as_memref = as_memref_descriptor(array_1, ctypes.c_double)
array_2_as_memref = as_memref_descriptor(array_2, ctypes.c_double)
res_array_as_memref = as_memref_descriptor(res_array, ctypes.c_double)

module.array_trig.argtypes = [
    *[type(x) for x in array_1_as_memref], 
    *[type(x) for x in array_2_as_memref], 
    *[type(x) for x in res_array_as_memref], 
    ctypes.c_long, ctypes.c_long, ctypes.c_long]

module.array_trig.restype = ctypes.c_double

def array_trig(*args):
    return module.array_trig(*args)

print(array_trig(*array_1_as_memref, *array_2_as_memref, *res_array_as_memref, 0, 1024, 1))

print(res_array)

print(np.allclose(res_array, np.sin(array_1) ** 2 + np.cos(array_2) ** 2))
