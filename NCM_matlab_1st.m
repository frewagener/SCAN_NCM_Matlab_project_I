% Clear the workspace
clearvars;
close all;
sca;

% Initialize Sounddriver
InitializePsychSound(1);

% Number of channels and Frequency of the sound
nrchannels = 2; % 2 because left and right 
rate = 48000; % rate = samples/second

%% SETTING THE PARAMETERS
freqs = (100:50:450);
sequences = [100,150,250; 150,200,300; 
            200,250,350; 250,300,350; 
            300,350,450];

ITI = 1; %in ms 
trials = 50;


% Length of the beep
beepLengthSecs = 1;

beepPauseTime = 1; % in ms

% Start immediately (0 = immediately)
startCue = 0;

% Wait for the device to really start (1 = yes)
% INFO: See help PsychPortAudio
waitForDeviceStart = 1;

pahandle = PsychPortAudio('Open', [], 1, 1, rate, nrchannels);

% Make a beep which we will play back to the user
%beep1 = MakeBeep(100, beepLengthSecs, rate);
%beep2 = MakeBeep(150, beepLengthSecs, rate);
%beep3 = MakeBeep(200, beepLengthSecs, rate);
%beep4 = MakeBeep(250, beepLengthSecs, rate);
%beep5 = MakeBeep(300, beepLengthSecs, rate);
%beep6 = MakeBeep(350, beepLengthSecs, rate);
%beep7 = MakeBeep(400, beepLengthSecs, rate);
%beep8 = MakeBeep(450, beepLengthSecs, rate); 




% improve portability of your code acorss operating systems 
KbName('UnifyKeyNames');
% specify key names of interest in the study
rsp_keys = [KbName('LeftArrow') KbName('RightArrow')];
% set value for maximum time to wait for response (in seconds)
to_wait = 1.5; 

% restrict keyboard input to the keys we're interested in
RestrictKeysForKbCheck(rsp_keys);
% suppress echo to the command line for keypresses
ListenChar(2);

% To do:  get the time stamp at the start of waiting for key input 
% so we can evaluate timeout and reaction time

% for i = 1:50 trials
% randomization of where we start in the sequence, so the order of the three stimuli stays the
% same (i.e. if we have 5 fixed sequences from which we choose a random one
% for each trial and then vary the start point for the 3 repetitions
% or vary delay period (might be easier?)
for i = 1:trials
    % To DO: avoid repetition! 
    select_sequence= sequences(randperm(length(sequences),3));
    %for i = 1:3
     for s = 1:length(select_sequence)
        beep_ = PsychPortAudio('FillBuffer', pahandle, [select_sequence; select_sequence]);
        beep_;
        %beep =  MakeBeep(select_sequence(s),1);
        %Snd('Open');
        %Snd('Play',beep);
        
    
        pause(ITI); %1s between each sequence

    %seq_1 = PsychPortAudio('FillBuffer', pahandle, [beep1 beep2 beep3; beep1 beep2 beep3]);
    %seq_1;
         % Wait for the beep to end
        [actualStartTime, ~, ~, estStopTime] = PsychPortAudio('Stop', pahandle, 1, 1);

        % Compute new start time for follow-up beep, beepPauseTime after end of previous one
        startCue = estStopTime + beepPauseTime;

        % Start audio playback
        PsychPortAudio('Start', pahandle, [], startCue, waitForDeviceStart);

        % Wait for stop of playback
        PsychPortAudio('Stop', pahandle, 1, 1);

        % tStart can  be the timestamp for the onset of stimuli 
        tStart = GetSecs;
        % repeat until a valid key is pressed or we time out
        time_out = false;
        % initialise fields for response variable 
        % that would contain details about the response if given
        rsp.RT = NaN; rsp.keyCode = []; rsp.keyName = [];
        while ~time_out
            % check if a key is pressed
            % only keys specified in activeKeys are considered valid
            [ keyIsDown, keyTime, keyCode ] = KbCheck; 
             if(keyIsDown), break; end
            if( (keyTime - tStart) > to_wait), time_out = true; end
        end
        % store code for key pressed and reaction time
        if(~time_out)
            rsp.RT      = keyTime - tStart;
            rsp.keyCode = keyCode;
            rsp.keyName = KbName(rsp.keyCode);
        end
     end
     
end

% reset the keyboard input checking for all keys
RestrictKeysForKbCheck;
% re-enable echo to the command line for key presses
% if code crashes before reaching this point 
% CTRL-C will reenable keyboard input
ListenChar(1)
% Close the audio device
PsychPortAudio('Close', pahandle);

