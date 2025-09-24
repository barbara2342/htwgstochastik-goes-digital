%d_intro_plot.m
%
% fourth MATLAB file for quickstarting stochastic calculations for 
% lectures "Stochastik" and "Mathematik 2" at HTWG Konstanz
%
% copyright: Barbara Staehle, HTWG Konstanz
% bstaehle@htwg-konstanz.de
%
% v1.0: 03/2024
% v1.1: 09/2025 minor updates, raw data plot
% copied and adapted from intro_plot.py
% (original author: Julian Walter)

% sample student ages
disp(' ')
ages = [20, 20, 24, 18, 20, 24, 20, 19, 19, 21, 24, 21, 25, 21, 19, 18, 20, 18, 20, 23, 21, 21, 21, 24];
disp(['Urliste with student ages: ', mat2str(ages)])

% count how often each ages is contained in the list, return the list of
% unique ages, too
[counts,values] = hist(ages,unique(ages));

%% plot the raw data
% you need to open a new figure and clear if (clf)
% (or omit it, then figure 1 will be reused)
figure(1); clf; 
% plot the urliste with the index on the x-axis and Stars as markers
plot(ages,'*')

% try this one - it will connect the edges via a line (not reasonable in
% this case
% plot(ages)

% format axis
set(gca,'ylim',[min(ages)-1,max(ages)+1]);
% show a grid
grid on
ylabel('Alter');
xlabel('Antwort Nr.');
title('Urliste - Alter der befragten Studierenden')

%%  there are various ways to plot histograms in MATLAB
% MATLAB standard way for a histogram
figure(2); clf; 

% this is the new MATLAB ways of plotting a histogram; I do not like it
histogram(ages)
set(gca,'xtick',[min(values):max(values)]);
xlabel('Alter');
ylabel('Häufigkeit');
title('Histogramm des Alters der Studierenden (via histogram)')

%% my prefered way for a histogram
figure(3); clf; 
bar(values, counts);
set(gca,'xtick',[min(values):max(values)]);
xlabel('Alter');
ylabel('Häufigkeit');
title('Histogramm des Alters der Studierenden (via bar)')
