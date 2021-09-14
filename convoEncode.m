function [outputStream] = convoEncode(bitstream)
%   This function takes a bitstream and encodes it using a convolutional 
%   encoding method with a rate of 1/2, and K = 7. 
%   Inputs:
%       bitstream: bitstream to be convolutionally encoded. 
%   Outputs:
%       outputStream: bitstream that has been encoded 
K = 7;
shiftRegister = zeros(1, K);
outputStream = logical.empty;
    for i = 1:length(bitstream)
        shiftRegister = circshift(shiftRegister,1);
        shiftRegister(1,1) = bitstream(1,i);
        adder1 = shiftRegister(1, [1 4 5 6 7]);
        adder2 = shiftRegister(1, [1 2 4 5 7]);
        u1 = mod(sum(adder1),2); % return u1 
        u2 = mod(sum(adder2),2); % return u2 
        output = [u1 u2]; % New output bits 
        outputStream = cat(2, outputStream, output); % Add new encoded bits to output stream
    end
end

