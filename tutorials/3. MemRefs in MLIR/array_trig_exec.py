import ctypes
import random

module = ctypes.CDLL('./libarray_trig.so')

module.array_trig.argtypes = [ctypes.Array, ctypes.Array, ctypes.c_int, ctypes.c_int, ctypes.c_int]
module.array_trig.restype = ctypes.Array

def array_trig(array_1, array_2, start, stop, step):
    return module.array_trig(array_1, array_2, start, stop, step)

# The array is a list of 1024 elements, all of which are 1.
array = [random.random() for _ in range(1024)]

array_1 = (ctypes.c_double * len(array))(*array)
array_2 = (ctypes.c_double * len(array))(*array)

print(array_trig(array_1, array_2, 0, 1024, 1))
# Outputs: 1024.0
