import ctypes

module = ctypes.CDLL('./libloop_add.so')

module.loop_add.argtypes = [ctypes.c_int, ctypes.c_int, ctypes.c_int]
module.loop_add.restype = ctypes.c_int

def loop_add(start, stop, step):
    return module.loop_add(start, stop, step)

print(loop_add(1, 10, 1))
# Outputs: 9
