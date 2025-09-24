%a_intro_basics.m
%
% first MATLAB file for quickstarting stochastic calculations for 
% lectures "Stochastik" and "Mathematik 2" at HTWG Konstanz
%
% copyright: Barbara Staehle, HTWG Konstanz
% bstaehle@htwg-konstanz.de
% 
% v1.0: 03/2024
% copied and adapted intro_basics.py
% (original author: Julian Walter)

% this is a normal comment

%% this starts a new cell 
% using the script in cell mode does allow to not execute everything, but
% just the stuff in one cell (i.e. from one double %% to the next double
% %%) 

%% Variables
% Variables don't have a command to declare themVariables don't need a type when declaring them, 
% and you can reassign different types to the same variable.  

age = 25
shoe_size = 42.5
eye_color = 'braun'
side_job = true

% note: in contrast to Python, 
% MATLAB distinguishes between single and double quotation markes
% 'char' and "string"; use 'char', preferably, this is smoother to handle

%% Output
% In MATLAB, everything is displayed, if you do not put a semicolon at the end of the line

% this is displayed
age = 23

% this is not displayed
age = 22; 

% For string concatenation, ints have to be casted to stings and put in one
% string array; disp is somewhat nicer and omits the variable name:

disp(['age: ', num2str(age)])

disp(['eye color: ' , eye_color])

disp(' ') % disps an empy line


%%

% Data types
% The most common types are int (whole number), double (decimal number), string (text) or char (#text, boolean (true/false) and lists (array-like structures) 
% For a list of all built-in data types see: MATLAB Data Types 
% 

% displays information about all variables in the workspace
whos

% displays information about variable age only
whos age 

%% Lists
% Lists have a wide range of applications
% The most notable difference to common temp_listays is the option to access parts of a list with slices 
% Lists are *one* indexed (first element has index 1, in contrast to Java and Python)!

disp('list examples')
% create by hand:
list_example = [0,1,2,3,4,5,6,7,8,9]

% crate automatically
list_example = 0:9

disp(' ')
disp(['entire list: ' , mat2str(list_example)])
disp(['length of list: ' , num2str(length(list_example))])
disp(['first and last element removed: ',  mat2str(list_example(2:end-1))])   % Removes the first and last element[0, 9]
disp(['first three elements only: ',  mat2str(list_example(1:3))])   % Selects the first 3 values
disp(['all elemnts except first three: ',  mat2str(list_example(3:end))])   % Selects all values except the first 3 values
disp(['select values on index 0 and 1:',  mat2str(list_example(1:2))])   % Selects the values on index 0 and 1
disp(['select values on index 6:',  mat2str(list_example(6:6))])   % Selects the value on index 6
disp(['only elements at odd positions: ',  mat2str(list_example(1:2:end))])   % selects indices 1,3,5,7,9
disp(['only elements at even positions: ',  mat2str(list_example(2:2:end))])   % selects indices 2,4,6,8,10

disp('')
temp = list_example;
temp(temp==3) = 4;
disp(['entire list, but 3 replaced with 4:', mat2str(temp)])


