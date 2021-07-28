clc, clear all, 
%% Screen Settings
sca;  
clearvars;
clear screen

% Background color: choose a number from 0 (black) to 255 (white)
backgroundColor = 0;
% Text color: choose a number from 0 (black) to 255 (white)
textColor = 255;

% Screen setup
clear screen
%    

sca 
PsychDebugWindowConfiguration(0, 0.5) %Comment out for debugging 
whichScreen = min(Screen('Screens'));
[window1, rect] = Screen('Openwindow',whichScreen,backgroundColor,[],[],2);
slack = Screen('GetFlipInterval', window1);
Screen('TextSize', window1, 25);
W=rect(RectRight); % screen width
H=rect(RectBottom) ; % screen height
Screen(window1,'FillRect',backgroundColor);
Screen('Flip', window1);

%% Fixation Cross
 
% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(rect);
% Here we set the size of the arms of our fixation cross
fixCrossDimPix = 40;

% Now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the center of our monitor for us)
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];

% Set the line width for our fixation cross
lineWidthPix = 4;
  
%% Stimuli + Parameters
freqs = (100:50:450);
sequences =  [100,150,250; 
                150,200,300; 
                200,250,350; 
                250,300,350;
                300,350,450];
 
ITI = 1; %inter trial (sequence) pause
ISI = 0.2; %inter stimulus pause 
trials = 1 ; %number of trials
beepPauseTime = 0.2; %Pause between beeps
beepLength = 1; %Length of beeps

% Calculate how long the beep and pause are in frames
beepLengthFrames = round(beepLength / slack);
beepPauseLengthFrames = round(beepPauseTime / slack);

%% Keyboard

% Keyboard setup
responseKeys = {'LeftArrow', 'rightArrow', 'space', 'Return'};
KbName('UnifyKeyNames');
KbCheckList = [KbName('LeftArrow'), KbName('RightArrow'), KbName('space'),KbName('Return')];
for i = 1:length(responseKeys)
    KbCheckList = [KbName(responseKeys{i}),KbCheckList];
end
RestrictKeysForKbCheck(KbCheckList);

%% Run experiment 
% Start screen 
Screen('DrawText',window1,'Press the space bar to begin', (W/2-150), (H/2), textColor);
Screen('Flip',window1)
% Wait for subject to press spacebar
while 1
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyCode(KbName('space'))==1
        break 
    end 
end 

% Run Trials 
for trial = 1:trials 
ind = ceil(rand * size(sequences,1));
select_sequence1 = sequences(ind,:); 
select_sequence1 = select_sequence1(randperm(length(select_sequence1)));
    for i = 1:3
        for s = 1:length(select_sequence1)
        beep =  MakeBeep(select_sequence1(s),beepLength);
        disp(select_sequence1(s))
        Snd('Open');
        Snd('Play',beep);
       
        
        for k = 1:beepLengthFrames
        Screen('DrawLines', window1, allCoords, lineWidthPix, [250 250 250], [xCenter yCenter]);
        % Flip to the screen
        Screen('Flip', window1);
        end
        
            for pause = 1:beepPauseLengthFrames
            Screen(window1,'FillRect',backgroundColor);
            Screen('Flip', window1); 
            end 
 
        end    
    end 
for i = 1:300 
    Screen(window1,'FillRect',backgroundColor);
    Screen('Flip', window1);
end 

end 

%% PLAY Condition
for i = 1:200
Screen('DrawText',window1,'PLAY', xCenter, yCenter, textColor);
Screen('Flip',window1)
end
for i = 1:200
%% HOLD Condition
Screen('DrawText',window1,'HOLD', xCenter, yCenter, textColor);
Screen('Flip',window1) 

end
% Clear the screen 
sca;