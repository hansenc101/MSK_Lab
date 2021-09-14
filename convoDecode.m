function [originalBitstream] = convoDecode(bitstream)
%   This function decodes a bitstream that was encoded using a convolutional 
%   encoding method with a rate of 1/2, and constraint, K = 7. This 
%   function is based on the Viterbi Algorithm.
%   Inputs:
%       bitstream: bitstream to be convolutionally decoded. 
%   Outputs:
%       outputStream: bitstream that has been decoded
%% State Diagram/Table
% k = 1; % number of bits per input symbol
% n = 2; % number of bits per output branch symbol/word
% rate = k/n;
% g1 = [1 0 0 1 1 1 1]; % code vector to encode u1
% g2 = [1 1 0 1 1 0 1]; % code vector to encode u2
K = 7; % Constraint
numStates = 2^(K-1); % number of states in state machine

% State table will be a 5x(2*numStates) Array 
% Row 1: Values are either 1 or 0, and these represent the next bit in the
%        bitstream, aka the input to the state table. 
% Row 2: This row represents the current state of the state machine. 
% Row 3: This is the value of the output, Ui. For us, it consists of two
%        bits, coded from 1. The value will be in decimal form, between 0 and 3. 
% Row 4: This row represents the next state of the state machine. 
% So, for our case, our state table will be a 4x128 array. 

currentState = 0;
%% Populate State Table
stateTable = zeros(2*numStates,4); % Instantiate an array to hold the table
for i = 1:2:2*numStates
    stateTable(i,1) = 0; % Input of 0
    stateTable(i+1,1) = 1; % Input of 1
    stateTable(i,2) = currentState;
    stateTable(i+1,2) = currentState;
    currentState = currentState +1;
end

for i = 2:1:2*numStates
    % == Set Bits of Shift Register for Current State and Input ===
    input = stateTable(i,1); % get input bit from table
    currentState = flip(de2bi(stateTable(i,2), K-1)); % get current state from table
    shiftRegister = cat(2, input, currentState); % shift register as a string of 1s and/or 0s
    adder1 = shiftRegister(1, [1 4 5 6 7]);
    adder2 = shiftRegister(1, [1 2 4 5 7]);
    
    % I can then modulo2. that is then u1
    u1 = mod(sum(adder1),2); % return u1 
    u2 = mod(sum(adder2),2); % return u2 
    output = [u1 u2];
    
    % Set State Table
    shiftRegister = circshift(shiftRegister,1);
    stateTable(i, 4) = bi2de(flip(shiftRegister(1, 2:K))); % Next state
    stateTable(i, 3) = bi2de(flip(output)); % Next output bits; flip output, bi2de() takes the reversed order
end

%% Decoding
numReceivedBits = length(bitstream);
trellis = zeros(numStates, floor((numReceivedBits/2))+1);
trellis = trellis + 999.111;
%% Populate Trellis
currentUi = [0 0]; % 00
trellis(1,1) = 0.01;
for i = 1:length(trellis(1,:))-1
    currentUi = bitstream(1,[i*2-1 i*2]);
    for j = 1:numStates
        if trellis(j,i) ~= 999.111 % If we even have been to this part of the trellis before
            currentValue = trellis(j,i);
            currentWeight = floor(currentValue); % Get the current weight of the index we are at in the trellis
            currentState = j;
            index = find(stateTable(:,2) == int8(currentState-1)); % Get the indexes for the next states and outputs for current state
            nextStates = stateTable(index,4); % Determine what the possible next states are
            outputs = de2bi(stateTable(index,3),2); % Outputs for 0 and 1, resectively
            
            % We now have the next states, and their associated outputs,
            % along with our current state and current weight.
            
            % == Determine Hamming Distance and next states for an output of 0 == 
            % Distance for output of 0 from state, current State
            nextState0 = nextStates(1)+1; % states are 0-3, but indexing is 1-4
            output0 = flip(outputs(1,:));
            distance0 = length(currentUi)*pdist([currentUi;output0], 'Hamming');
            value0 = currentWeight + distance0 + (currentState/100);
            if trellis(nextState0, i+1) >= value0
                trellis(nextState0, i+1) = value0;
            end
            
            % == Determine Hammin Distance and next states for an output of 1 == 
            % Distance for output of 1 from state, current State
            nextState1 = nextStates(2)+1; % states are 0-3, but indexing is 1-4
            output1 = flip(outputs(2,:));
            distance1 = length(currentUi)*pdist([currentUi;output1], 'Hamming');
            value1 = currentWeight + distance1 + (currentState/100);
            if trellis(nextState1, i+1) >= value1
                trellis(nextState1, i+1) = value1;
            end
        end
    end
end

%%
% === Trellis is now populated, and we can now go back through and find
% best path. ===
originalBitstream = logical.empty;
trellisSize = size(trellis);
rowLength = trellisSize(1,2);
weights = floor(trellis(:,rowLength));
[~, startingIndex] = min(weights); % Get the index of the minimum value
currentValue = trellis(startingIndex,rowLength);
currentState = startingIndex-1;
prevState = int8((currentValue - floor(currentValue))*100)-1;
%inputIndex = find(stateTable(:,2) == prevState & stateTable(:,4) == currentState);
%input = stateTable(inputIndex,1);
input = stateTable(stateTable(:,2) == prevState & stateTable(:,4) == currentState,1);
originalBitstream = cat(1,originalBitstream,input);
for i = length(trellis(1,:))-1:-1:2
     currentValue = trellis(prevState+1, i);
     currentState = prevState;
     prevState = int8((currentValue - floor(currentValue))*100)-1;
     %inputIndex = find(stateTable(:,2) == prevState & stateTable(:,4) == currentState);
     %input = stateTable(inputIndex,1);
     input = stateTable(stateTable(:,2) == prevState & stateTable(:,4) == currentState,1);
     originalBitstream = cat(1,originalBitstream,input);
end
originalBitstream = flip(originalBitstream');
end

