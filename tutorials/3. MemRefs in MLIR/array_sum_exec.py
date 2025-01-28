import ctypes

module = ctypes.CDLL('./libarray_sum.so')

module.array_sum.argtypes = [ctypes.Array, ctypes.c_int, ctypes.c_int, ctypes.c_int]
module.array_sum.restype = ctypes.c_float

def array_sum(array, start, stop, step):
    return module.array_sum(array, start, stop, step)

# The array is a list of 1024 elements, all of which are 1.
array = [1.0] * 1024

array = (ctypes.c_float * len(array))(*array)

print(array_sum(array, 0, 1024, 1))
# Outputs: 1024.0
