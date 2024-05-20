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
b = fir1(N-1, 0.01);
y = FIR(x,b);
figure(1);
plot(t,x);
figure(2);
plot(t,y);
