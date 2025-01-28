import ctypes

module = ctypes.CDLL('./libloop_add_conditional.so')

module.loop_add_conditional.argtypes = [ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int]
module.loop_add_conditional.restype = ctypes.c_int

def loop_add_conditional(start, stop, step, limit):
    return module.loop_add_conditional(start, stop, step, limit)

print(loop_add_conditional(1, 10, 2, 8))
# Outputs: 28 (1+3+5+7)
