function [bitstream] = demodMSK(s, fc, baud, Fs)
%demodMSK Summary of this function goes here:
% This function demodulates a waveform that was modulated using Minimum 
% Shift Keying into a stream of bits.
%   Inputs:
%       s: vector containing the values of the modulated source signal 
%       fc: carrier frequency of the waveform
%       baud: baud of modulation (symbols/second)
%       Fs: sampling frequency
%   Outputs:
%       bitstream: vector containing the demodulated bits   
T = 1/baud;
samplesPerSymbol = T*Fs;
N = length(s);
s1 = modulateMSK([1], fc, baud, Fs); % Waveform of an MSK modulated 1 bit
s0 = modulateMSK([0], fc, baud, Fs); % Waveform of an MSK modulated 0 bit
bitstream = logical.empty;
for n = 1:samplesPerSymbol:N
     if n+samplesPerSymbol > N
         break;
     end
    bit = 0;
    corr1 = xcorr(s(n:n+samplesPerSymbol-1),s1); % correlate s1
    max1 = max(corr1);
    min1 = min(corr1);   
    corr0 = xcorr(s(n:n+samplesPerSymbol-1),s0); % correlate s0
    max0 = max(corr0);
    min0 = min(corr0);
    if((max1 + abs(min1)) > (max0 + abs(min0)))
        bit = 1;
    end
    bitstream = cat(2, bitstream, bit);
end
end

