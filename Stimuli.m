clear all;
clc;
%% SETTING THE PARAMETERS
freqs = (100:50:450);
sequences = [100,150,250; 150,200,300; 
            200,250,350; 250,300,350; 
            300,350,450];

beepPauseTime = 1; %in ms
ITI = 1; %in ms 
trials = 4;

%% Running the sounds
for freq = 1:length(freqs)
beep = MakeBeep(freqs(freq),1); %the 1 is the length of the sound
Snd('Open');
Snd('Play',beep);
end

%% Overall skeleton for presentation of stimuli across trials
% Creating a loop which randomly selects one of the 5 sequences
% Random selection 1
ind = ceil(rand * size(sequences,1));
select_sequence1 = sequences(ind,:);

% Random selecction 2

for k = 1:trials
select_sequence2= sequences(randperm(length(sequences),3));
    for i = 1:3
        for s = 1:length(select_sequence2)
            
        beep =  MakeBeep(select_sequence2(s),1);
        Snd('Open');
        Snd('Play',beep);
        %pause(ITI); %Comment out if you want 1s between each beep

        end 
    end
  pause(ITI); %1s between each sequence
end 
