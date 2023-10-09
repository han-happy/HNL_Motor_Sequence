% This version is demostration of the framework for motor sequence learning task 
% Zhibin 10/09/23

% Clear the screen display and all variables in the workspace
sca; clc; close all; clear all; clearvars; 

%% set keyboards
% exp_dir  = pwd;
addpath Cedrus_Keyboard/
run setCedrusRB.m % plug in the left RB pad first then the right RB pad
run SuppressWarning.m 

% set the random number seed as the date of today in formate such as 20220505
seed=input('enter the date in format YYYYMMDD:');
rng(seed);

% Break and issue an error message if the installed Psychtoolbox is not
% based on OpenGL or Screen() is not working properly.
AssertOpenGL;

%% Set trial conditions ****************************************************
conditions = [1 2];

% Block & Trial number of the experiment **********************************
% number of taps per trial/condition
numTaps=230; 
% number of trials per block
numTrials=2;
% number of blocks/repeats
numBlock=1;
% total trial number
numtotal=numTrials*numBlock; 
% num of conditions in the experiment
numconditions=length(conditions);
% **********************************Block & Trial number of the experiment

%% ########################################################################
try      % if anything went wrong, exit the display and show the error on the Command window
    
    % Here we call some default settings for setting up Psychtoolbox 
    PsychDefaultSetup(2);

    % Get the screen numbers. This gives us a number for each of the screens
    % attached to our computer. For help see: Screen Screens?
    screens = Screen('Screens');

    % Draw we select the maximum of these numbers. So in a situation where we
    % have two screens attached to our monitor we will draw to the external
    % screen. When only one screen is attached to the monitor we will draw to
    % this. For help see: help max
    screenNumber = max(screens);

    % Define black and white (white will be 1 and black 0). This is because 
    % luminace values are (in general) defined between 0 and 1.0
    % For help see: help WhiteIndex and help BlackIndex
    white = WhiteIndex(screenNumber);
    black = BlackIndex(screenNumber);
    white = [white white white];
    black = [black black black];
    % Initialize some other colors
    green = [0 1 0];
    red = [1 0 0];
    blue = [0 0 1];

    % Open an on screen window and color it black
    % For help see: Screen Openwindow?
    % This will draw on a black backgroud with a size of [0 0 800 600] or
    % full screen, and then return a window pointer windowPtr
    % [windowPtr, windowRect] = PsychImaging('Openwindow', screenNumber, black, [0 0 800 600]); 
    [windowPtr, windowRect] = PsychImaging('Openwindow', screenNumber, black); % show on a full screen

        % Get the size of the on screen windowPtr in pixels
    % For help see: Screen windowSize?
    [screenXpixels, screenYpixels] = Screen('windowSize', windowPtr);
    buttom_radius=screenYpixels/35;

    % Get the centre coordinate of the window in pixels
    % For help see: help RectCenter
    [xCenter, yCenter] = RectCenter(windowRect); 

    % Enable alpha blending for anti-aliasing
    % For help see: Screen BlendFunction?
    % Also see: Chapter 6 of the OpenGL programming guide
    Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    Screen('ColorRange', windowPtr, 1, -1,1);

    % Set text display options for operating system other than Linux.
    % For help see: Screen TextFont?
    if ~IsLinux
        Screen('TextFont', windowPtr, 'Arial');
        Screen('TextSize', windowPtr, 18);
    end

    % Retreive the maximum priority number
    topPriorityLevel = MaxPriority(windowPtr) ; 
    % topPriorityLevel0 = MaxPriority(windowPtr0); 
    % set Priority once at the start of a script after setting up onscreen window.
    Priority(topPriorityLevel);

    % Measure the vertical refresh rate of the monitor
    ifi = Screen('GetFlipInterval', windowPtr);
    % Check if ifi=0.0167 second (60Hz)
    if round(1/ifi)~=60
      error('Error: Screen flash frequency is not set at 60Hz.');    
    end

    %% Set size of the squares for photocell ##############################
    PhotosensorSize=60; 
    % Positions of the photocell at he bottom rihgt corner of the screen
    LeftUpperSquare = [0 0 PhotosensorSize PhotosensorSize];

    %% Numer of frames to wait in order to achieve good timing. 
    % Note: the use of wait frames is to show a generalisable coding. 
    % For example, by using waitframes = 2 one would flip on every other frame. See the PTB
    % documentation for details. In what follows we flip every frame. 
    % In order to flip with feedback at 50 Hz
    % We have to filp every (1/50)/ifi frames or 1/50 ms/frame
    waitframes=2;

    %% Hide the cursor of the mouse in the display*****************
    % Get handles for all virtual pointing devices, aka cursors:
    typeOnly='masterPointer'; 
    mice = GetMouseIndices(typeOnly);  
    HideCursor(windowPtr,mice);

    %% Tell subject to start
    instructionStart=['Press any key to start!']; 
    DrawFormattedText2(instructionStart,'win',windowPtr,...
        'sx','center','sy','center','xalign','center','yalign','center','baseColor',white);
    Screen('Flip',windowPtr);
    % hit a key to continue
    KbStrokeWait;
    % Flip Black Screen
    Screen('Flip',windowPtr);

    % get a timestamp by flip a black screen at the start of resting 
    vbl = Screen('Flip', windowPtr);

    %%
    for block=1:numBlock
        for t=1:numTrials 
            % Breakout of the trial by hitting esc
            [keyIsDown, keysecs, keyCode] = KbCheck;  
            if keyCode(KbName('escape'))
            Screen('CloseAll');
            break;
            end


%     % initalize the while loop for displaying black screen
%     n=1;
% 
%     % Setting time variables for each stimulus**********************
%     % total number of video frames to flip in each stimlus
%     StimulusDuration=0.2; % 100 milliseconds 
%     numFramesStim = round(StimulusDuration/ifi/waitframes);
%     numFramesStim = 
% 
%     while n < numFramesStim
%         % If esc is press, break out of the while loop and exit experiment
%         [keyIsDown, keysecs, keyCode] = KbCheck;
%         if keyCode(KbName('escape'))
%             Screen('CloseAll');
%             break;
%         end
%     end
% 
%     % Response keys layout Design*************************************************
%     Screen('FrameOval', windowPtr,white, [xCenter-buttom_radius yCenter-buttom_radius xCenter+buttom_radius yCenter+buttom_radius],1,1); 
%     Screen('FillRect', windowPtr, white, LeftUpperSquare);  


        end
    end




    %% Show The End
    TheEnd = ['The End. \nThank you!'];
    DrawFormattedText2(TheEnd,'win',windowPtr,...
        'sx','center','sy', 'center','xalign','center','yalign','top','baseColor',white);
    vbl=Screen('Flip',windowPtr);
    WaitSecs(3)
    % hit a key to continue
    KbStrokeWait;     
    
    %*************************************
    Priority(0);   
    sca;

catch
    sca;
    psychrethrow(psychlasterror);
end  


%% save data
cd ./Exp_data
filename=[num2str(seed) '.mat'];
save(filename);
