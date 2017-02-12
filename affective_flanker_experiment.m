function affective_flanker_experiment()

% Function for Affective Flanker Task (modified version of the Eriken
% Flanker Task)
% Original: Hameron script by Rebecca Lawson
% Source: ICN UCL Matlab course 19/02/2014, Cogent example script
% Modified for educational purposes by Nazia Jassim, 2016

%-------------------------------------------------------------------------%

% This function presents a sequence of trials, each consisting of a central
% target stimulus flanked by 2 other task-irrelevant stimuli. There are 4
% different conditions which make up a 2x2 design [valence (happy vs angry)
% vs congruency (congruent vs incongruent)].

% The participant is asked to indicate the valence of the target stimulus
% by pressing "H" for Happy and "A" for angry.

%-------------------------------------------------------------------------%
clc   %clear workspace
clear %clear variables

% Add Cogent to the MATLAB path
addpath('C:\Users\lenovo\Documents\MATLAB\Cogent\Cogent2000v1.33\Toolbox')

%-------------------------------------------------------------------------%

%% subject information input boxes 

p.name=input('Enter subject code e.g. MH? ','s'); % enter subject initials
switch p.name
    case ''
        disp('No subject name entered')
        return
end

% Timing information (in ms)
    
p.times.stimduration=1000; % stimulus duration in ms
p.times.blank1=300;        % response window in ms
p.times.blank2=1200;       % wait duration in ms
                           % total inter-stimulus interval= blank1+blank2

% Trial information
p.numconditions = 4;       % corresponds to the 4 different conditions
p.numtrialreps  = 12;      % number of times each condition is displayed

% Conditions (list of images)
stim_list = {'stim_A.bmp'; 'stim_B.bmp'; 'stim_C.bmp'; 'stim_D.bmp';};

%-------------------------------------------------------------------------%
%% Start cogent code     
config_display(1, 3)                          % 1- full screen; 3- 1024x768 pixels
config_keyboard;
start_cogent;


%Start instructions
cgpencol(1, 1, 1)                              % text colour- white
cgfont('Arial', 30)                            % font type

cgtext('Welcome to the experiment.', 0, 200);
cgtext('You will see 3 images in a row- a central target flanked by 2 other images.', 0, 100);
cgtext('Your task is to state which expression describes the central target.', 0, 75);
cgtext('Press H for Happy or A for Angry.', 0, 50);

cgtext('Press space to continue.', 0, - 75);
cgflip(0, 0, 0);                               % flip buffer on screen, drawing the buffer black
waitkeydown(inf, 71);                          % waits until space is pressed

cgtext('Please press H', 0, 0);                % Assigns key ID; H= Happy
clearkeys;
cgflip(0, 0, 0);
[keyHappy, keytime, numberofkeys] = waitkeydown(inf);

cgtext('Please press A', 0, 0);                % Assigns key ID; A= Angry
clearkeys;
cgflip(0, 0, 0);
[keyAngry, keytime, numberofkeys] = waitkeydown(inf);

cgtext('Press space to begin experiment', 0, 10);
cgflip(0, 0, 0);
waitkeydown(inf, 71);

%COUNT DOWN: 3...2...1...START
cgfont('Arial', 80);
cgtext('3', 0, 0);
cgflip(0, 0, 0);
wait(1000);
cgtext('2', 0, 0);
cgflip(0, 0, 0);
wait(1000);
cgtext('1', 0, 0);
cgflip(0, 0, 0);
wait(1000);
cgtext('start');
cgflip(0, 0, 0);
wait(1000);

count = 0;                                      % loop counter variable

%-------------------------------------------------------------------------%
%% Main Loop
for h = 1:p.numtrialreps;                       % h is the trial iteration variable
  
    % Randomizes the order of presentation 
    for loop = 1:length(stim_list);
        stim_list{loop, 2} = loop;              % mark whether it's happy or angry
        stim_list{loop, 3} = rand(1, 1);        % put in a random number for sorting
    end
    p.randstim = sortrows(stim_list, 3);        % sort by the third column (a random number)

    for i = 1:p.numconditions;                  % i is the condition iteration variable
        count = count + 1;
        index = count;
        results.trialstats{index, 1} = h;       % save the trial number
                                                % column 1 of trialstats 
        
        %First Block of CG flip and waituntil - blank1
        blank1onset = cgflip(0, 0, 0);
        clearkeys;
        cgloadbmp(1, p.randstim{i, 1});                    % Load the stimuli
        
        results.trialstats{index, 2} = p.randstim{i, 2};   % Write the condition type
                                                           % Column 2 of trialstats
        cgdrawsprite(1, 0, 0);                             % Draw the CS offscreen
        
        %Second Block of CG flip and waituntil - stimulus display
        stimonset = cgflip(0, 0, 0);
        waituntil(stimonset * 1000 + p.times.stimduration) % Scale by 1000 because cgflip returns the time in seconds,
                                                           % but waituntil uses ms
        
        % Third block of CG flip and waituntil - blank screen for response logging
        blank2onset = cgflip(0, 0, 0);
        waituntil(blank2onset * 1000 + p.times.blank2)
        
        %Read keypresses
        readkeys;
        [key, t, n] = getkeydown;               % n = number of key presses,
                                                % t = array of time of key presses
                                                                  
        if n == 0;                              % if no key is pressed, rt is invalid
            response = 0;                       % rt = reaction time
            rt = 9999;
        else                                    % log key press and rt
            response = key(1);
            rt = t(1) - stimonset * 1000;
        end
        
        
        hit = false;                            % initialise hit as false; hit refers to correct/wrong response
        % check if response was correct or not
        switch results.trialstats{index, 2}   
            case 1
                if (response == keyHappy)
                    hit = true;
                end
            case 2
                if (response == keyHappy)
                    hit = true;
                end
            case 3
                if (response == keyAngry)
                    hit = true;
                end
            case 4
                if (response == keyAngry)
                    hit = true;
                end
            otherwise
                hit=false;
        end
        results.trialstats{index, 3} = hit;      % Save the responses to column 3 of trialstats
        results.trialstats{index, 4} = rt;       % Save the reaction time to column 4 of trial stats
         
        % Save the onset times to the results struct
        results.onsets(index, 1) = double(h);    % Since all other columns are decimal numbers, 
        results.onsets(index, 2) = blank1onset;  % the int has to be converted to double
        results.onsets(index, 3) = stimonset;
        results.onsets(index, 4) = blank2onset;
        results.onsets(index, 5) = rt;
        
    end
 
    % Give a break only once after the first testing period
    cgfont('Arial', 30)
    if h == 1;              
        cgtext('Brief Pause', 0, 50);
        cgtext('Press space to continue', 0, 0);
        cgflip(0, 0, 0);
        waitkeydown(inf, 71);
    end
    
    save  data p results;                         % Saves input and results to data.mat file
end 

cgfont('Arial', 30)
cgtext('Thanks for participating. Hit space to exit.', 0, 50);
cgflip(0, 0, 0);
waitkeydown(inf, 71);

clear p results                                    % clear input parameters and results


stop_cogent;
