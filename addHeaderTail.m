function [HTbitstream] = addHeaderTail(bitstream)
%addHeaderTail Summary of this function goes here:
% This function will take a stream of bits and add a predefined header and 
% tail and provide the new bitstream as an output. The header is a predefined
% set of values that are equivalent to the following values in hexadecimal: 
% ['00'; 'FF'; 'A5'; 'FF']. The tail is a predefined set of values that are
% equivalent to the following set of values in hexadecimal: 
% ['00'; 'FF'; 'A5'; 'FF'].
%   Inputs:
%       bitstream: bitstream
%   Outputs:
%       HTbitstream: bitstream that has the header and tail bits
%       added to the beginning and end, respectively

hexPreHeader = ['4C'; 'AF'; 'AF'; '9D']; % 0s 
% Following line converts 0s to a bitstream
binPreHeader = [hexToBinaryVector(hexPreHeader(1,:),8)...
    hexToBinaryVector(hexPreHeader(2,:),8)...
    hexToBinaryVector(hexPreHeader(3,:),8)...
    hexToBinaryVector(hexPreHeader(4,:),8)];

hexHeader = ['00'; 'FF'; 'FF'; '00']; % Header in hexadecimal
% Following line converts header to a bitstream
binHeader = [hexToBinaryVector(hexHeader(1,:),8)...
    hexToBinaryVector(hexHeader(2,:),8)...
    hexToBinaryVector(hexHeader(3,:),8)...
    hexToBinaryVector(hexHeader(4,:),8)];

binHeader = cat(2, binPreHeader, binHeader);
%[headerWav, ~] = modulateMPSK(binHeader, fc/2, M, baud/2, Fs);

hexTail = ['01'; '25'; 'AA'; 'FF'; 'FF';'AA';'52';'80']; % Tail in hexadecimal
% Following line converts tail to a bitstream
binTail = [hexToBinaryVector(hexTail(1,:),8)...
    hexToBinaryVector(hexTail(2,:),8)...
    hexToBinaryVector(hexTail(3,:),8)...
    hexToBinaryVector(hexTail(4,:),8)...
    hexToBinaryVector(hexTail(5,:),8)...
    hexToBinaryVector(hexTail(6,:),8)...
    hexToBinaryVector(hexTail(7,:),8)...
    hexToBinaryVector(hexTail(8,:),8)];

%[tailWav, ~] = modulateMPSK(binTail, fc/2, M, baud/2, Fs);
%s_rx = cat(2, headerWav, s_tx);
%s_rx = cat(2, s_rx, tailWav);
NewBitstream = cat(2, binPreHeader, binHeader); % add pre header to beginning of bitstream
NewBitstream = cat(2, NewBitstream, bitstream); % add header to beginning of bitstream
HTbitstream = cat(2, NewBitstream, binTail); % add tail to end of bitstream 
HTbitstream = cat(2, HTbitstream, binPreHeader);
end

