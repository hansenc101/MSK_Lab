function [s, t] = modulateMSK(bitstream, fc, baud, Fs)
%modulateMSK Summary of this function goes here:
% This function takes a stream of bits 'bitstream', and modulates a carrier
% waveform with a frequency 'fc' using Minimum Shift Keying, and sampled
% with a sampling frequency of 'Fs'.
%   Inputs:
%       bitstream: vector containing the bits that will be modulated to an
%       MSK waveform
%       fc: carrier frequency of the waveform
%       baud: baud of modulation (symbols/second)
%       Fs: sampling frequency
%   Outputs:
%       s: vector containing the values of the modulated source signal 
%       t: time vector of the source signal s
Dk = 2*bitstream - 1; % Convert bitstream to -1s and 1s 
Dk = [-1 Dk]; % we need an initial value for Dk
N = length(bitstream);
T = 1/baud;
t = 0:1/Fs:N*T-(1/Fs);

% == Calculate Phase Constraint Vector, Xk ==
Xk = zeros(1, N+1);
for k = 2:N+1
    Xk(k) = mod(Xk(k-1) + ((pi*(k))/2)*(Dk(k-1) - Dk(k)), 2*pi);  
end
Xk = Xk(2:length(Xk));
Dk = Dk(2:length(Dk));

% == Generate MSK Waveform ==
symbolIndex = floor(t/T) + 1;
Xk = Xk(symbolIndex);
Dk = Dk(symbolIndex);
s = cos(2*pi*(fc + Dk/(4*T)).*t + Xk);
end

