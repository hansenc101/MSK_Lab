% Christopher Hansen
% Communication Systems
% Lab 05
% 4/6/2021
%% Text to ASCII encoding then to binary bitstream
clear; clc; 
text = fileread('Bible.txt');
%text = 'Christopher David Hansen';
bitstream = textToBitstream(text);
disp(bitsToText(bitstream));
bitstream = addHeaderTail(bitstream); % Add preamble and postamble
bitstream = convoEncode(bitstream);
%% MSK Modulation
Fs = 192000;
fc = 1200;
baud = 800;
T = 1/baud;
[s, t] = modulateMSK(bitstream, fc, baud, Fs);

figure();
plot(t, s);
title('4 Symbol Periods of MSK Modulated Source Signal');
xlabel('time (s)');
ylabel('Amplitude');
xlim([0 4*T]);
hold off;

% Power Spectral Density
[Hs,f] = pwelch(s,[],[],[],Fs);
figure();
plot(f, pow2db(Hs));
title("Power Spectral Density of Source Signal");
xlabel("Hz");
ylabel("PSD (dB/Hz)");

%% Transmit 
s = 0.99*s;
audiowrite('IsaiahEncoded.wav', s, Fs); % write the generated sinsoid to .wav file 
                                      % with specified sampling frequency
%% Receive Waveform
[s_rx,Fs] = audioread('rxIsaiahEncodedAir.wav'); % Read in generated waveform from .wav file
%s_rx = recordAudio(20, Fs); % Receive the signal
s_rx = s_rx';
figure();
t_tx = 0:1/Fs:(length(s_rx)-1)/Fs;
plot(s_rx);
title('Received Signal');
xlabel('Samples');
ylabel('Amplitude');

% Power Spectral Density
[Hs_rx,f_rx] = pwelch(s_rx,[],[],[],Fs);
figure();
plot(f_rx, pow2db(Hs_rx));
title("Power Spectral Density of Received Signal");
xlabel("Hz");
ylabel("PSD (dB/Hz)");

%% Demodulation and Decoding
hexHeader = ['00'; 'FF'; 'FF'; '00']; % Header in hexadecimal
% ==== Following lines converts header to a wave ====
binHeader = [hexToBinaryVector(hexHeader(1,:),8)...
    hexToBinaryVector(hexHeader(2,:),8)...
    hexToBinaryVector(hexHeader(3,:),8)...
    hexToBinaryVector(hexHeader(4,:),8)];
binHeaderEncoded = convoEncode(binHeader); % encode header bits, since they were added on as encoded bits at the start

s_rx3 = deleteHeadTail2(binHeaderEncoded, s_rx, fc, baud, Fs); % Sync Header Waveform
rxBitstream = demodMSK(s_rx3, fc, baud, Fs);                   % MSK Demodulation
sampleOffset = syncBits(binHeaderEncoded, rxBitstream);        % Sync the characters using header bits
rxBitstream = convoDecode(rxBitstream);                        % Decode the bitstream

% = Convert to Text =
receivedText = bitsToText(rxBitstream(sampleOffset:8*floor(length(rxBitstream)/8)))