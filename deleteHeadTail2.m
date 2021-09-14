function [s] = deleteHeadTail2(binHeader, s_rx, fc, baud, Fs)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% Detect Header and Obtain Sample Offset
% hexHeader = ['00'; 'FF'; 'FF'; '00']; % Header in hexadecimal
% % ==== Following lines converts header to a wave ====
% binHeader = [hexToBinaryVector(hexHeader(1,:),8)...
%     hexToBinaryVector(hexHeader(2,:),8)...
%     hexToBinaryVector(hexHeader(3,:),8)...
%     hexToBinaryVector(hexHeader(4,:),8)];
[headerWav,~] = modulateMSK(binHeader, fc, baud, Fs);

[headerCorr,headerLags] = xcorr(s_rx,headerWav); % Correlate header and received waveform
[~,headerOffset] = max(abs(headerCorr));
figure();
plot(headerLags,headerCorr);
title("Correlation between received waveform and header waveform");

% ==== Determine Header Sample Offset ====
disp("Header Sample Offset");
headerSampleOffset = headerLags(headerOffset+1);
disp(headerSampleOffset);

%% Start Signal at Header
s = s_rx(headerSampleOffset:length(s_rx));
