%testbench
clear;
close all;
Fs = 10000; % sample number
dt = 1/Fs; % step
t = (0:dt:1-dt)';
F = 10; % frequency (Hz)
noise = wgn(10000,1,-10); % Gaussian noise
x = 0.8*sin(2*pi*F*t); 
x = noise.*0.1 + x; % input a sin wave with Gaussian noise
N = 64; % order
b = fir1(N-1, 0.01); % fir filter
y = FIR(x,b);
figure(1);
plot(t,x);
figure(2);
plot(t,y);

% FIR filter function

function y = FIR(x, b)
    x_length = length(x); % number of x
    b_length = length(b); % number of b
    input_x_file = fopen('./fir_x_m.input', 'w'); % input file of x
    input_b_file = fopen('./fir_b_m.input', 'w'); % input file of b
    output_file = fopen('./fir_m.output', 'w'); % output file of y
    y = filter(b,1,x);
    % write the x into file
    for i = 1:x_length
        fprintf(input_x_file, "%f\n", x(i));
    end
    % write the b into file
    for j = 1:b_length
        fprintf(input_b_file, "%f\n", b(j));
    end
    % write the y into file
    for i = 1:x_length
        fprintf(output_file, "%f\n", y(i));
    end
    fclose(input_x_file);
    fclose(input_b_file);
    fclose(output_file);
end
