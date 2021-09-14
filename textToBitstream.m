function [bitstream] = textToBitstream(text)
%textToBitstream Summary of this function goes here:
% This function takes a string of characters, converts the string to
% hexadecimal using ASCII, and then finally converts the hexadecimal values
% to bits and returns a vector of these bits. 
%   Inputs:
%       text: string of characters that will be converted to a stream of
%       bits
%   Outputs:
%       bitstream: vector containing the bits of the converted string

hex = dec2hex(text); % convert to hexadecimal
binary = hexToBinaryVector(hex,8); % convert hexadecimal bytes to binary
numDoubleBytes = size(hex,1); % get the number of pairs of bytes in data set 
bitstream = binary(1,:); % instantiate an object to hold the stream of bits
for i = 2:numDoubleBytes % For loop to get all bits into a single vector
    bitstream = cat(2,bitstream,binary(i,:)); % Add another 8 bits to stream
end
end

