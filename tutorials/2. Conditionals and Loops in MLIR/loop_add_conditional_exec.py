import ctypes

module = ctypes.CDLL('./libloop_add.so')

module.reduce.argtypes = [ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int]
module.reduce.restype = ctypes.c_int

def reduce(start, stop, step, limit):
    return module.reduce(start, stop, step, limit)

print(reduce(1, 10, 1, 5))
# Outputs: 9
