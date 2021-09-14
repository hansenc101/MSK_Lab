function [sampleOffset] = syncBits(headerBits, rxBitstream)
%   This function takes a bitstream and bits of a header that has been 
%   added to the front of the bitstream and syncs the header and bitstream
%   together so that when the bitstream is decoded to text, the characters
%   are synchronized. The function provides the offset for the decoding to
%   start as the output. 
%   Inputs:
%       headerBits: preamble bits of the bitstream 
%       rxBitstream: bitstream to be synced with header and then
%                    to be converted to text. 
%   Outputs:
%       sampleOffset: bit offset to start decoding to text

[headerCorr, lags] = xcorr(rxBitstream,headerBits);
figure();
plot(lags, headerCorr);
title('Correlation of Header Bits and Rx Bitstream');
[~, offset] = max(abs(headerCorr));
sampleOffset = lags(offset+1)
end

