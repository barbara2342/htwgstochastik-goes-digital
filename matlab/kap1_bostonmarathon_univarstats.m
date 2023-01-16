%KAP1_BOSTONMARATHON_UNIVARSTATS
% script for analyzing finish times of 2019 Boston marathon
% source: https://www.kaggle.com/datasets/daniboy370/boston-marathon-2019
% this script does only UNIVARIATE statistics
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
% v1.0: 09/2022

clear; clc; close all; 

% flag for saving figures or not 
% 0 = do not save, 1 = save figures
printt = 0;

% save figures to figure directory if existing, if not use same directory
% adapt to your local setup
ppath = '../bilder/';
if ~exist(ppath,'dir')
    ppath = '';
end

% check if data is in extra directory, if not, assume flat structure
% adapt to your local setup
datapath = '../data/';
if ~exist(datapath,'dir')
    datapath = ''; 
end

ffile = [datapath 'Dataset-Boston-2019.csv'];

% read weatherdata collected in Constance between 1973 and last year
% extract the last year for which data is available (09/22: 2021) 
t = readtable([datapath ffile],'ReadVariablenames',true);

disp('read table with columns as follows')
variablesInFile = t.Properties.VariableNames

% names of fields as found in file
% varnames_in_file = {'Rank_Tot'}    {'Age'}    {'Gender'}    {'Country'}    {'Result_hr'}    {'Result_sec'}    {'Rank_Gender'}    {'Country_code'}

%%
% extract finish times in seconds (better to handle than in duration
% format)
times = t{:,6};
% how many finishers were there?
T = length(times);

%%
% construct histograms (count number of entries for each of 15 equally
% spaced intervals)
% note: "hist" is deprecated, use "histogram" instead if you are a MATLAB
% starter
% [n,x] = vector with frequencies and locations of number finishers / 100 equally spaced bins on the x-axis
nbins = T/100;
[n,x] = hist(times, nbins); 


figure(1); clf; hold; box on;
% use nicer colors if available
try
    set(gca,'colororder',fhg(3),'fontsize',18);
catch
    set(gca,'colororder',jet(3),'fontsize',18);
end
h = [];

% construct bar plot with bins (x) on the x-axis and frequencies (n) on the
% y-axis
h(1) = bar(x,n/T);

%prepare and format axes and legend
xlim([2, 7]*3600);
ylim([0,0.013])
set(gca,'xtick',[2:7]*3600,'xticklabel',[2:7]);
ylabel('relative frequency');
xlabel('finishing time [h]');
title(['Boston Marathon 2019, times of ' num2str(T) ' finishers']);

% include male and female winner time in plot
text(4.45*3600,0.012,['male winner time: ' char(t{1,5})],'fontsize',12)
ind = find(cellfun(@(x) x=='F', t.Gender));
text(4.45*3600,0.011,['female winner time: ' char(t{min(ind),5})],'fontsize',12)

if printt
    saveas(gcf, [ppath 'boston2019_finishingTime.png'],'png');
end


%%
disp(['Median of finishing times: ', char(median(t{:,5}))])
disp(['10%-Quantile of finishing times: ', char(quantile(t{:,5},0.1))])

