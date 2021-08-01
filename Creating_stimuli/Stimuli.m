%% Selected Stimuli
freqs = (100:50:450);
sequences = creating_aud_stimuli(freqs, 50, 150);
%% Running the sounds
for row = 1:size(sequences, 1)
    for col = 1:size(sequences, 2)
    beep = MakeBeep(sequences(row, col),1); %the 1 is the length of the sound
    Snd('Open');
    Snd('Play',beep);
    disp(sequences(row, col))

    end
end
