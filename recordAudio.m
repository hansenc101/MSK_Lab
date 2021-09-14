function [y] = recordAudio(time, Fs)
%recordAudio Summary of this function goes here:
% This function will record audio for specifically Chris's system. It will
% record the audio for a length of time equal to the input parameter 'time'
% and sample at a rate of 'Fs'.
%   Inputs:
%       time: length of time in seconds that the audio will record
%   Outputs
%       y: vector containing the recorded audio data

micBitDepth = 16; % number of bits that the microphone supports per sample
inputDeviceID = -1; % input device ID from audioInfo collected from matlab
recorder = audiorecorder(Fs, micBitDepth, 1, inputDeviceID); % instantiate recorder object
recordingLength = time; % set recording length to 3 seconds
disp("recording");
recordblocking(recorder, recordingLength); % record the audio for specified length
y = getaudiodata(recorder); % get the audio data from recording and put into y
disp("done recording");
end

