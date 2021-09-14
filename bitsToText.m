function [text] = bitsToText(dataBitstream)
%UNTITLED Summary of this function goes here
%   This function takes a bitstream and converts it to text using ASCII. 
%   Inputs:
%       bitstream: bitstream to be converted to text. 
%   Outputs:
%       text: String corresponding to bitstream
% ==== Convert from binary to hex then to string ====
newHex = binaryVectorToHex(dataBitstream,'MSBFirst'); % Decode binary to hexadecimal
text = ''; % Instantiate variable to hold decoded text
for i = 1:2:size(newHex,2) % loop through every two bytes in decoded hexadecimal array
     if i+1 > length(newHex)
         break
     end
     byte = newHex(1,i:i+1); % get the next byte from hex array
     c = char(hex2dec(byte)); % convert byte to character
     text = cat(2,text,c); % store character in variable to hold decoded text
end
end

