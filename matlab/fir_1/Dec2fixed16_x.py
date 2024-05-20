def float_to_fixed16(num):

    if not -1 <= num <= 1:
        raise ValueError("the input must be between -1 and 1")


    fixed_point = int(num * 32767)


    return format(fixed_point & 0xFFFF, '016b')


with open('fir_x_m.input', 'r') as file:
    lines = file.readlines()


binary_fixed_points = [float_to_fixed16(float(line.strip())) for line in lines[:10000]]


with open('fir_x.input', 'w') as file:
    for binary in binary_fixed_points:
        file.write(binary + '\n')
