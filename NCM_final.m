function NCM_final()
% start by clearing screen and workspace
clearvars;
close all;
clear all; 
sca;
log_file = Participant_input()
%% *******************************************************************
%                       INTRODUCTION
%*********************************************************************
% PARADIGM:
% This script implements a rehearsal/refreshment task. 
% There is eight different stimuli
% There is two experimental conditions: (1) working memory load = 1 tone
%                                       (2) working memory load = 3 tones
% This means that either the last tone (frequency) of a given stimulus sequence should
% be rehearsed or that all 3 tones presented need to be rehearsed.
% Subjects are presented with an initial sequence of tones (a sequence consits of three different frequencies),
% which is repeated during a Stimulation phase for 8 seconds.
% The last presentation of a stimuli is accompanied with a CUE, which tells
% the subject that from then on Refreshment starts
% During the Refrehsment-Period (8s) a visual pacing-cue is presented
% to speed the refreshment.
% After that period, a Target-Stimulus is presented, which either matches
% the current to-be-refreshed stimulus in the sequence, or not.
% Subjects indicate via left/right arrow button-press if it was a correct target
% or not. 
%
% OUTPUTS:
% A MATLAB-Logfile is generated (to be used for the Data analysis)




%% EXPERIMENTAL DESIGN MATRIX %%

% Design matrix over all trials with the following parameters saved per trial: time of trial start, presented
% sequence (out of the 5), stimulus duration (in ms with stimuli presentation at rate of 1Hz), 
% rehearsal duration (in ms, 1Hz presentation), correct or incorrect stimulus target, the
% condition (either PLAY (1) or HOLD (2)) ( and the inter trial 
% interval between the response and the beginning of the next trial).

% general settings for each trial of experiment

Init_Break       = 1000; %when to start the first trial "Anfangspause"
stimrate         = 1000;  % Rate of presented beeps in stimphase

ITI = 1; %inter trial (sequence) pause
%ISI = 0.2; %inter stimulus pause 
trials = 2    ; %number of trials
beepPauseTime = 0.2; %Pause between beeps, maybe 0.4 instead?
beepLength = 1; %Length of beeps, maybe 600ms instead? stimrate
%beepLengthSecs = 0.6;
% How many times do we wish to play the sound
repetitions = 1; 


% This is the composition of the design where the order of trials is
% randomized. Setting correct/incorrect trials, duration of stimulus presentation & rehearsal + condition 
% (play = 1, hold = 2) 

%24 trials might be better, 5*6=30 or 5*12= 60
% maybe have stimulation duration be set to 9 seconds??

correct   = [1 1 1 0 0 0];
stimphase = [6 6 8 8 10 10];
refphase  = [6 6 8 8 10 10];
condition = [1 1 1 2 2 2];

% Specification of Trials within one Run
% 4* 6 = 24 trials, for us 5*10 for 50 trials
% for ref stim phase no randsample needed if always 8 seconds
Trials_all =   [1 1 1 1 1 1                      3 3 3 3 3 3                 5 5 5 5 5 5            4 4 4 4 4 4                2 2 2 2 2 2;             % Which sequence for trial (condition) = different frequencies
                randsample(stimphase, 6)    randsample(stimphase, 6)   randsample(stimphase, 6)  randsample(stimphase, 6)  randsample(stimphase, 6);                 % Stim_dur
                randsample(refphase, 6)     randsample(refphase, 6)    randsample(refphase, 6) randsample(refphase, 6)   randsample(refphase, 6);                  % Refreshment_dur                
                randsample(correct,6)  randsample(correct,6)  randsample(correct,6)  randsample(correct,6)  randsample(correct,6);         % Correct/Incorrect
                randsample(condition,6) randsample(condition,6) randsample(condition,6) randsample(condition,6) randsample(condition,6)];  % which condition will it be?

            
% Changing the format of stimphase & refphase from seconds into ms
Trials_all(2,:) = Trials_all(2,:)*1000;
Trials_all(3,:) = Trials_all(3,:)*1000;


% Randomizing order of trials
trial_order = randperm(length(Trials_all));
for i = 1:length(trial_order)
    Trials(:,i) = Trials_all(:,trial_order(i));
end
clear i Trials_all trial_order;


% Adding Targets to Trial Matrix and adding ITIs
 Trials = [Trials; 
          randsample(repmat(ITI,1,30),30,0)]; %randsample(repmat(ITIs,1,10) if I have 5 different ITIs

      
% make a vector that specifies when trial begins
Timing = [Init_Break];    % Start of first trial after X seconds



for i = 1:(length(Trials)-1)
                %last_onset + Sequence    + Rehearsal      + Response +  ITI
    next_onset = Timing(i)  + Trials(2,i) + Trials(3,i) + 1500     + Trials(5,i); % Adding of time

    Timing(i+1) = next_onset; 
    clear next_onset;
end

% Final Design Matrix

design_mat = [ Timing      ;...      % 1:Trial_onset time in ms
             Trials(1,:) ;...      % 2:Which set of frequencies to use
             Trials(2,:) ;...      % 3:Stimulation duration
             Trials(3,:) ;...      % 4:Rehearsal/Refreshment Duration
             Trials(4,:) ;...      % 5:correct/incorrect
             Trials(5,:) ;...      % 6:experimental condition
             Trials(6,:) ];        % 7:ITI --> should delete this if we don't have a varying ITI!

       
 

%Clearing of unused variables
clear Timing Trials i Init_Break ITI correct refphase stimphase condition;

      
% Calculate how long the beep and pause are in frames
%beepLengthFrames = round(beepLength / slack);
%beepPauseLengthFrames = round(beepPauseTime / slack);


%% MATLAB-LOGFILE of response collection & design matrix
log_file.date         = date;
log_file.time         = clock;
log_file.responses    = zeros(7,30); 
% 1: RT 
% 2: correct or incorrect target (1 or 0)
% 3: response key (right arrow = 1, left arrow = 0)
% 4: accuracy (1 or 0)
% 5: condition (1 = PLAY, 2 = HOLD)
% 6: time-out?
% 7: subject ID

subject_no    = log_file.subjnum;  
subject_name  = sprintf('SJ0%d', subject_no);
log_path  = fullfile(pwd, [subject_name, '_Response.mat']);
save(log_path, 'log_file'); %saving response collection
design_path = fullfile(pwd, [subject_name, '_trial_info.mat']);
save(design_path, 'design_mat') %saving design matrix 


% RESPONSE-BUTTON RANDOMIZATION
% acccording to randomization Scheme
if mod(subject_no,2) == 0 % Even numbers
    yes = 80; % left-Button
    no =  79; % right-Button
else
    yes = 79; % right-Button
    no =  80; % left-Button
    
end


% NOTE: response time currently seems too little! Also not sure if
% randomization of response buttons is being incorporated or even should be
% as we're not telling participants which button corresponds to yes or no 

%% Running the experiment %%
try 

Screen('Preference', 'SkipSyncTests',  1);

%---------------
% Sound Setup
%---------------

% Initialize Sounddriver
InitializePsychSound(1);

% Number of channels and sample frequency of the sound
nrchannels = 2;
freq = 48000;

% How many times do we wish to play the sound
%repetitions = 1;


% Start immediately (0 = immediately)
startCue = 0;

% wait for the device to start (1 = yes)
waitForDeviceStart = 1;

% Open Psych-Audio port, with the follow arguements
% (1) [] = default sound device
% (2) 1 = sound playback only
% (3) 1 = default level of latency
% (4) Requested frequency in samples per second
% (5) 2 = stereo putput
pahandle = PsychPortAudio('Open', [], 1, 1, freq, nrchannels);

% Set the volume to half
PsychPortAudio('Volume', pahandle, 0.5);


%our stimuli
% eight frequencies & 5 sequences
freqs = (100:50:450);
%sequences =  [100,150,250; 
%                150,200,300; 
%                200,250,350; 
%                250,300,400;
%                300,350,450];
 

% Make a beep which we will play back to the user
Beeps = num2cell(zeros(1, length(freqs)));
for b=1:length(freqs)
    
    Beeps{b} = MakeBeep(freqs(b), beepLength, freq);
    
end

% Make permutations list. In the end, every trial will present a random 
% permutation of one of the sequences

Permutations = {};
Permutations{1} = [1 2 4];
Permutations{2} = [2 3 5];
Permutations{3} = [3 4 6];
Permutations{4} = [4 5 7];
Permutations{5} = [5 6 8];


%---------------
% Screen Setup
%--------------- 

% default settings 
PsychDefaultSetup(2);
% Background color: choose a number from 0 (black) to 255 (white)
backgroundColor = 0;
% Text color: choose a number from 0 (black) to 255 (white)
textColor = 255;
%%our old settings 
%whichScreen = min(Screen('Screens'));
%[window, rect] = Screen('Openwindow',whichScreen,backgroundColor,[],[],2);
%slack = Screen('GetFlipInterval', window);
%Screen('TextSize', window, 25);
%W=rect(RectRight); % screen width
%H=rect(RectBottom) ; % screen height
%Screen(window,'FillRect',backgroundColor);
%Screen('Flip', window);
%%


% Get the screen numbers
screens = Screen('Screens');

screenNumber = max(screens);


% Open an on screen window with black background color
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, backgroundColor);

% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Get the size of the on screen window in pixels
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

%W=windowRect(RectRight); % screen width
%H=windowRect(RectBottom) ; % screen height

% Get frame duration --> ifi == slack
slack = Screen('GetFlipInterval', window);


% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Set the text size
Screen('TextSize', window, 50);



% Calculate how long the beep and pause are in frames
beepLengthFrames = round(beepLength / slack);
beepPauseLengthFrames = round(beepPauseTime / slack);
% setting pause between presentation of 3 sequences to 1 second
numSecs = 1;
numFrames = round(numSecs / slack);
numQuestion = round(1.5/slack); 
% Setting our fixation Cross


% Here we set the size of the arms of our fixation cross
fixCrossDimPix = 40;

% Now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the center of our monitor for us)
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];

% Set the line width for our fixation cross
lineWidthPix = 4;
lineWidthPix2 = 2;
  

% Keyboard setup
%starting timer
tic;  % time counter

% improve portability of your code acorss operating systems 
KbName('UnifyKeyNames');
% specify key names of interest in the study
activeKeys = [KbName('LeftArrow') KbName('RightArrow') KbName('space')];
activeKeys_name = ["LeftArrow" "RightArrow" "Space"];
RestrictKeysForKbCheck(activeKeys);
% set value for maximum time to wait for response (in seconds)
t2wait = 1.5; 

%% Run experiment 
% Start screen 
%Screen('DrawText',window,'Press the space bar to begin', (W/2), (H/2), textColor);
%Screen('Flip',window)
% Wait for subject to press spacebar
%while 1
%    [keyIsDown,secs,keyCode] = KbCheck;
%    if keyCode(KbName('space'))==1
%        break 
%    end 
%end


% whether the correct target tone will be outputted or not
%correct_or_false = [zeros(1, trials / 2) ones(1, trials / 2)];
%correct_or_false = correct_or_false(randperm(length(correct_or_false)));

for t = 1:1%length(design_mat)
    
    current_trial = design_mat(:,t);
    shuffled_perm = Shuffle(Permutations{current_trial(2)}); %getting index of current sequence and shuffle - do we want shuffle?
    rep_seq = repmat(shuffled_perm,1,10); %3*10 = 30
    current_seq = rep_seq(1:current_trial(3)/stimrate);
    display(current_seq)
    rehearsal_dur = current_trial(4)/stimrate;
    % get target tone for play and hold condition, if not correct then take
    % tone right before (ie -1), we could think about randomizing this, so
    % which of the two other sounds from the frequency sequence is taken
   
    mismatch_seq_hold = current_seq(end-2:end-1)
    mismatch_hold_target = mismatch_seq_hold(randperm(length(mismatch_seq_hold), 1))
    idx_play = (length(current_seq)+rehearsal_dur)-1
    mismatch_seq_play = rep_seq(idx_play-2:idx_play)
    mismatch_seq_play = mismatch_seq_play(end-2:end-1)
    mismatch_play_target = mismatch_seq_play(randperm(length(mismatch_seq_play), 1))
    display(mismatch_play_target)
    play_target = rep_seq((length(current_seq)+rehearsal_dur)-1) %+current_trial(5));
    hold_target = current_seq(end); %-1+current_trial(5)
    display(hold_target)
    tStart = toc;
    ListenChar(2) 
    
    if t == 1
        while toc <= current_trial(1)/1000 - 0.5
        end
        % Start screen 
       % Screen('DrawText',window,'Press the space bar to begin', (xCenter), (yCenter), textColor);
        DrawFormattedText(window, 'Left arrow = Mismatch \n Right arrow = Match \n Press the space bar to begin', (xCenter-300), (yCenter), textColor);
        Screen('Flip',window)
        % Wait for subject to press spacebar
        while 1
            [keyIsDown,secs,keyCode] = KbCheck;
            if keyCode(KbName('space'))==1
                break 
            end
        end
        % Draw fixation cross 0.5sec before first tone of run
        Screen('DrawLines', window, allCoords,...
        lineWidthPix2, textColor, [xCenter yCenter], 2);
        % Flip to the screen
        Screen('Flip', window);    
    end
    
    
    while toc <= current_trial(1)/1000 
    end
    
    % Stimulation Phase 
    
    for p = 1:length(current_seq)
        
        
            % Fill Buffer with correct frequency tone
            PsychPortAudio('FillBuffer', pahandle, [Beeps{current_seq(p)}; Beeps{current_seq(p)}]);
            
            % Start audio playback #1
            PsychPortAudio('Start', pahandle, repetitions, startCue, waitForDeviceStart);
            
            % while still in the sequence
            if p < length(current_seq)
                
                % Draw beep screen 
                for i = 1:beepLengthFrames

                   % fixation cross in textColor, set to the center of our screen
                   Screen('DrawLines', window, allCoords,...
                   lineWidthPix, textColor, [xCenter yCenter], 2);

                    % Flip to the screen
                    Screen('Flip', window);

                end 
            % last sound of frequence reached, now presenting condition cue
            % with last tone on screen
            else 
                
                % Draw beep screen 
                for i = 1:beepLengthFrames

                   % Draw the CONDITION CUE
                   if current_trial(6) == 1 %play condition 
                   
                       DrawFormattedText(window, 'PLAY', 'center', 'center',textColor);
                       
                   else
                       
                       DrawFormattedText(window, 'HOLD', 'center', 'center', textColor);
                    
                   end    
                    % Flip to the screen
                    Screen('Flip', window);

                end 
            end
            
            % Stop Audio
            PsychPortAudio('Stop', pahandle);

            % time in between beeps
            for i = 1:beepPauseLengthFrames

                % Draw fixation cross now with other line thickness to
                % distinguish it 
                %Screen('DrawLines', window, allCoords,...
                %lineWidthPix2, textColor, [xCenter yCenter], 2);
                Screen(window,'FillRect',backgroundColor);
      

                % Flip to the screen
                Screen('Flip', window);

            end 

    end % end of presentation of audio

    % Rehearsal/refreshment phase
    
    for r = 1:rehearsal_dur
        
        if r < rehearsal_dur
        
            % Draw beep screen (bold fixation cross)
            for i = 1:beepLengthFrames

               % Draw the fixation cross in white/textcolor, set it to the center of our screen
               Screen('DrawLines', window, allCoords,...
               lineWidthPix, textColor, [xCenter yCenter], 2);

                % Flip to the screen
                Screen('Flip', window);

            end

            % pause in between beeps (normal fixation cross again)
            for i = 1:beepPauseLengthFrames

                % Draw text
                %Screen('DrawLines', window, allCoords,...
                %lineWidthPix2, textColor, [xCenter yCenter], 2);
                Screen(window,'FillRect',backgroundColor);

                % Flip to the screen
                Screen('Flip', window);

            end 
            
        else
            
            % target presentation
            if current_trial(6) == 1 %play condition
                 
                if current_trial(5) == 1
                    PsychPortAudio('FillBuffer', pahandle, [Beeps{play_target}; Beeps{play_target}]);
                else
                    PsychPortAudio('FillBuffer', pahandle, [Beeps{mismatch_play_target}; Beeps{mismatch_play_target}]);
                end
            
                  
            % hold condition
            else
                
               if current_trial(5) == 1
                    PsychPortAudio('FillBuffer', pahandle, [Beeps{hold_target}; Beeps{hold_target}]);
                else
                    PsychPortAudio('FillBuffer', pahandle, [Beeps{mismatch_hold_target}; Beeps{mismatch_hold_target}]);
                end
            
                
            end    
            
            % Start audio playback of target stimulus
            PsychPortAudio('Start', pahandle, repetitions, startCue, waitForDeviceStart);
            
            timedout = true;
            tStart = toc;
            for i = 1:numQuestion
                
                 % Draw text
                DrawFormattedText(window, '?', 'center', 'center', textColor);

                % Flip to the screen
                Screen('Flip', window);
                
                %waiting for pressing right or left arrow
                [secs, keyCode, deltaSecs] = KbWait([], 2, t2wait);
                
                % store code for key pressed and reaction time
                if(string(KbName(keyCode))~="")
                    % a valid key was pressed so we didn't time out
                    timedout = false;
                      
                    log_file.responses(1,t) = toc - tStart; % time
                    log_file.responses(3,t) = (KbName(keyCode) == "RightArrow"); % recording 1 for right and 0 for left arrow
                    if (KbName(keyCode) == "RightArrow" && current_trial(5) == 1) || (KbName(keyCode) == "LeftArrow" && current_trial(5) == 0)
                        log_file.responses(4,t) = 1; %  correct response, 1 forr acc
                    else
                        log_file.responses(4,t) = 0; % incorrect response, 0 for no accuracy
                    end
                    log_file.responses(2,t) = current_trial(5); % stimuli is the correct target
                    log_file.responses(5,t) = current_trial(6); % trial condition type
                    log_file.responses(7,t) = subject_no; % subject id
                  break;
                
                end
                  
                %end % end of checking if one of the two correct keys were pressed
                
                % re-enable echo to the command line for key presses
                % if code crashes before reaching this point 
                % CTRL-C will reenable keyboard input
                ListenChar(0)

            end 
            
            if timedout == 1 %adding information for timedout trial
                
                log_file.responses(2,t) = current_trial(5);  % stimuli matched    
                log_file.responses(5,t) = current_trial(6);  % trial condition type
                log_file.responses(7,t) = subject_no;           % subject id
                log_file.responses(6,t) = 1;                 % timedout: yes
                
            end    
            
            % Stop Audio
            PsychPortAudio('Stop', pahandle);
            
        end
    
    end
    
    
    
        % Add 1.5sec with feddback display or timedout

        for frame = 1:(numFrames*1.5)
            
            % show if timedout or correct/incorrect
            if timedout == 1
                DrawFormattedText(window, 'timed out', 'center', 'center', [1 0 0]);
            elseif  log_file.responses(4,t) == 1
               DrawFormattedText(window, ' correct ', 'center', 'center', [0 1 0]);
            elseif log_file.responses(4,t) == 0
                DrawFormattedText(window, ' incorrect ', 'center', 'center', [1 0 0]);
            end
            
            % Flip to the screen
            Screen('Flip', window);

        end %end showing feedback
        
    %always save log file after every run to have data even if programm crashes
    save(log_path, 'log_file');
 
        
    for frame = 1:(numFrames) %short black screen after feedback presentation
        Screen('FillRect', window, [0 0 0]); %back to black screen
        Screen('Flip', window);
    end
    
    if t<length(design_mat) %drawing fixation cross 1 second before first tone of next trial
        while toc <= design_mat(1,t+1)/1000 - 1
        end
        % Draw fixation cross
        Screen('DrawLines', window, allCoords,...
        lineWidthPix2, textColor, [xCenter yCenter], 2);

        % Flip to the screen
        Screen('Flip', window);
    end    

end

% after run is over

for frame = 1:(numFrames*3) %short display of performance for 3 seconds
    
    DrawFormattedText(window, ['Performance: ', char(string(round((sum(log_file.responses(4,:))/t)*100, 1))), '%'], 'center', 'center', textColor);
    Screen('Flip', window);
    
end

for frame = 1:(numFrames*1.5) %short black screen of 1.5sec for not automatically closing screen after performance presentation
    
    Screen('FillRect', window, [0 0 0]); %back to black screen
    Screen('Flip', window);
    
end


sca;

%final saving of responses
save(log_path, 'log_file');


catch ME
    
    sca;
    rethrow(ME);
    
end
end 