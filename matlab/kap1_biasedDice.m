%KAP1_BIASEDDICE
% script for analyzing the frequencies of 20 dice rolls
%
% note1: script contains lots of copy and paste to make it runable
% without further libraries
%
% note2: this script is optimized for use in CELL MODE
% one cell is enclosed by "%%" and can be run without the rest of the
% script; of course, the data preparation and init cells have to be run first, 
% after that, plot cells can be executed stand alone 
%
% copyright: Barbara Staehle, HTWG Konstanz
% bstaehle@htwg-konstanz.de
% 
% v1.0: 08/2016
% v1.1: 09/2021, minor edits, cleaning up, and more comments


%% 
% run first cell to init everything
% clean up
clear; close all; clc;

% flag for saving figures or not 
% 0 = do not save, 1 = save figures
printt = 0;

% save figures to figure directory if existing, if not use same directory
% adapt to your local setup
ppath = '..\bilder\';
if ~exist(ppath,'dir')
    ppath = '';
end

% use Urliste given in lecture script - result of 20 D6 dice rolls 
% use your own data here!
dat = [4, 1, 1, 5, 3, 3, 1, 4, 5, 6, 1, 4, 1, 6, 1, 2, 1, 2, 3, 5];

% the different dice rolls that can occur (1, 2, ..., 6)
a = unique(dat);

% length of Urliste (how many values can occur?
N = length(dat);


%%
% plot histogram for absolute values

% chose figure to plot in
figure(1); 
% clear figure (mandatory)
clf; 
% allow more than one plot in figure (reasonable)
hold; 
% draw a box round figure (optional)
box on; 
% show grid (optional)
grid on; 

% use nicer colors if available (optional)
try
    set(gca,'colororder',fhg(2),'fontsize',18);
catch
    set(gca,'colororder',jet(2),'fontsize',18);
end

% note: "hist" is deprecated, use "histogram" instead if you are a MATLAB
% starter
% n = vector with frequencies and locations of bins (1:6)
n = hist(dat,1:6);

% do bar plot
bar(a,n);

% prepare and format axes and legend

% use only occuring values for x-axis
set(gca,'xtick',a); 

% lable axis and title
xlabel('dice rolls');
ylabel('absolute frequency');
title('histogram for dice rolls');

% save figure if desired
if printt
    saveas(gcf, [ppath 'dicehist_abs.png'],'png');
end

%%
% create histogramm of normalized frequencies for comparison purposes
% chose figure to plot in
figure(2); 
% clear figure (mandatory)
clf; 
% allow more than one plot in figure (reasonable)
hold; 
% draw a box round figure (optional)
box on; 
% show grid (optional)
grid on; 

% use nicer colors if available (optional)
try
    set(gca,'colororder',fhg(2),'fontsize',18);
catch
    set(gca,'colororder',jet(2),'fontsize',18);
end

% do bar plot with normalized frequencies
bar(a,n/N);

% prepare and format axes and legend

% use only occuring values for x-axis
set(gca,'xtick',a); 

% lable axis and title
xlabel('dice rolls');
ylabel('relative frequency');
title('histogram for dice rolls');

% save figure if desired
if printt
    saveas(gcf, [ppath 'dicehist_rel.png'],'png');
end


%%
% plot empirical cdf
figure(3); clf; hold; grid on; box on;
% use nicer colors if available
try
    set(gca,'colororder',fhg(2),'fontsize',18);
catch
    set(gca,'colororder',jet(2),'fontsize',18);
end

% use stair function: plot sorted data vector (dice rolls) on
% x-axis and cumulatively added relative frequencies on y-axis
% include a first and a last point to make it nicer
stairs([0 a 7],cumsum([0 n 0]/N),'--','linewidth',3)

% prepare and format axes and legend

% use only occuring values for x-axis
set(gca,'xtick',a); 

% define limits for x and y axis manually to make it nicer
xlim([0.5,6.5]);
ylim([0,1]);

% lable axis and title
xlabel('dice rolls');
ylabel('cumulative relative frequency');
title('empirical CDF for dice rolls');

% save figure if desired
if printt
    saveas(gcf, [ppath 'dice_cdf.png'],'png');
end
