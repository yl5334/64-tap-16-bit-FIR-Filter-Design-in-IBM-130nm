import numpy as np

def float_to_half_precision(num):
 

    half_precision = np.float16(num)


    return format(np.frombuffer(half_precision.tobytes(), dtype=np.uint16)[0], '016b')


with open('fir_m.output', 'r') as file:
    lines = file.readlines()


binary_half_precision_floats = [float_to_half_precision(float(line.strip())) for line in lines[:10000]]


with open('fir_output', 'w') as file:
    for binary in binary_half_precision_floats:
        file.write(binary + '\n')
