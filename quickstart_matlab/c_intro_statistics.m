%c_intro_statistics.m
%
% third MATLAB file for quickstarting stochastic calculations for 
% lectures "Stochastik" and "Mathematik 2" at HTWG Konstanz
%
% copyright: Barbara Staehle, HTWG Konstanz
% bstaehle@htwg-konstanz.de
%
% v1.0: 03/2024
% copied and adapted from intro_numpyStat.py
% (original author: Julian Walter)


%% Packages
% You dont have to reinvent the wheel in most cases, many functions are already implemented in MATLAB.
% In contrast to Python, the most functions are already installed with the
% Statistics toolbox and you do not need to import packages implicitely 

% this creates the numbers 0,1,2,3,4,5
numbers = 1:5

% this creates the numbers 0,2,4,6
numbers = 0:2:6

% this creates the numbers 5,4,3,2,1,0
numbers = 5:-1:0

% want to have this one as example
numbers = 1:5;

% more nicely formatted (choose your favorite)
disp(['numbers: ', num2str(numbers)])

% more nicely formatted (choose your favorite)
disp(['numbers: ', mat2str(numbers)])

%%

% attention: MATLAB would allow you to overwrite the function 'mean' with
% the value of a variable!!
mean_num = sum(numbers)/length(numbers);
disp(['Mean of numbers calculated by hand: ', num2str(mean_num)])

mean_num = mean(numbers);
disp(['Mean of numbers calculated by function: ', num2str(mean_num)])

%% example with most important stochastic functions

% student ages in SS23
disp('')
ages = [20, 20, 24, 18, 20, 24, 20, 19, 19, 21, 24, 21, 25, 21, 19, 18, 20, 18, 20, 23, 21, 21, 21, 24];
disp(['Urliste with student ages: ', mat2str(ages)])

% get the unique values of a list
unique_vals = unique(ages);
disp(['Unique values: ', num2str(unique_vals)])

ages_length = length(ages);
disp(['Length of list: ', num2str(ages_length)])

min_val = min(ages);
disp(['Min value of list: ', num2str(min_val)])

max_val = max(ages);
disp(['Max value of list: ', num2str(max_val)])

sorted_list = sort(ages);
disp(['List sorted: ', num2str(sorted_list)])

list_sorted_low = sorted_list(1:3);
disp(['Three smallest values: ', num2str(list_sorted_low)])

list_sorted_high = sorted_list(end-2:end);
disp(['Three biggest values: ', num2str(list_sorted_high)])

avg_val = mean(ages);
disp(['Average value of list: ', num2str(avg_val)])

median_val = median(ages);
disp(['Median value of list: ', num2str(median_val)])

D = mode(ages);
disp(['Most frequent value in list (using mode): ', num2str(D)])

std_dev = std(ages);
disp(['Standard deviation: ', num2str(std_dev)])

variance = var(ages);
disp(['Variance: ', num2str(variance)])

%% 
disp(' ')
temp = [1, 2, 3, 4, 5];
disp(['another sample list:', mat2str(temp)])
csum = cumsum(temp);
disp(['List where each value is the sum of the previous values: ', mat2str(csum)])
