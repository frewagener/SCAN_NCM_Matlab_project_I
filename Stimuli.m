clear all;
clc;

%% Screen 

% Clear the workspace and the screen
sca;
close all;
clearvars;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Setup the text type for the window
Screen('TextFont', window, 'Ariel');
Screen('TextSize', window, 36);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Here we set the size of the arms of our fixation cross
fixCrossDimPix = 40;

% Now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the center of our monitor for us)
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];

% Set the line width for our fixation cross
lineWidthPix = 4;

% Draw the fixation cross in white, set it to the center of our screen and
% set good quality antialiasing
Screen('DrawLines', window, allCoords,...
    lineWidthPix, white, [xCenter yCenter], 2);

% Flip to the screen
Screen('Flip', window);

% Wait for a key press
KbStrokeWait;

% Clear the screen
sca;

%% SETTING TE PARAMETERS
freqs = (100:50:450);
sequences = [100,150,250; 150,200,300; 
            200,250,350; 250,300,350; 
            300,350,450];

 
ITI = 1; %inter trial (sequence) pause
%ISI = 0.2; %inter stimulus pause 
trials = 4;

%% Key selection
% improve portability of your code acorss operating systems 
KbName('UnifyKeyNames');
responseKeys =  [KbName('LeftArrow') KbName('RightArrow') KbName('space') KbName('escape')];
escapeKey = KbName('ESCAPE');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');
downKey = KbName('DownArrow');
% set value for maximum time to wait for response (in seconds)
to_wait = 1.5; 

% restrict keyboard input to the keys we're interested in
RestrictKeysForKbCheck(responseKeys);
% suppress echo to the command line for keypresses
ListenChar(2);


%% Running the sounds
%for freq = 1:length(freqs)
%%beep = MakeBeep(freqs(freq),1); %the 1 is the length of the sound
%Snd('Open');
%Snd('Play',beep);
%end

%% Overall skeleton for presentation of stimuli across trials
% Creating a loop which randomly selects one of the 5 sequences
% Random selection 1

%select_sequence2= sequences(randperm(length(sequences),3));
% Random selecction 2

% whether the correct target tone will be outputted or not
correct_or_false = [zeros(1, trials / 2) ones(1, trials / 2)]
correct_or_false = correct_or_false(randperm(length(correct_or_false)));

for k = 1:trials
    ind = ceil(rand * size(sequences,1));
    select_sequence1 = sequences(ind,:); 
    select_sequence1 = select_sequence1(randperm(length(select_sequence1)));
    for i = 1:3
        target = select_sequence1(end);
        for s = 1:length(select_sequence1)
            
            beep =  MakeBeep(select_sequence1(s),1);
            disp(select_sequence1(s))
            Snd('Open');
            Snd('Play',beep);
        %pause(ISI); %between each beep we may need to change

        end
    end
    
    is_correct = correct_or_false(k)  == 1
    % output the correct target tone
    if is_correct
        disp('correct')
        beep =  MakeBeep(select_sequence1(end),1);
        Snd('Open');
        Snd('Play',beep)
    % output the incorrect target tone
    else
        beep_num = ceil(rand * 2);
        disp('incorrect')
        beep =  MakeBeep(select_sequence1(beep_num),1);
        Snd('Open');
        Snd('Play',beep)
    end
    
    %disp(target)
    pause(ITI); %1s between each sequence tripple (delay period insert here)
    % tStart can  be the timestamp for the onset of stimuli 
    tStart = GetSecs;
    % repeat until a valid key is pressed or we time out
    time_out = false;
    % initialise fields for response variable 
    % that would contain details about the response if given
    rsp.RT = NaN; rsp.resp = []; rsp.keyName = [];
    while ~time_out
        % check if a key is pressed
        % only keys specified in activeKeys are considered valid
        [ keyIsDown, keyTime, keyCode ] = KbCheck; 
       % if(keyIsDown)
         if keyCode(escapeKey)
             ShowCursor;
             sca;
        return
        elseif keyCode(leftKey)
            response = 0;
            respToBeMade = false;
        elseif keyCode(rightKey)
            response = 1;
            respToBeMade = false;
        end %break; end
        if( (keyTime - tStart) > to_wait), time_out = true; end
    end
    % store code for key pressed and reaction time
    if(~time_out)
        rsp.RT      = keyTime - tStart;
        rsp.resp = response;
        rsp.keyName = KbName(rsp.keyCode);
    end
end 