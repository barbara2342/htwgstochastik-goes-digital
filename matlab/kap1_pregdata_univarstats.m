%KAP1_PREGDATA_UNIVARSTATS
% script for analyzing 'Nat2014PublicUS.c20150514.r20151022.txt'
% holding data on pregnancies downloaded from
% http://www.cdc.gov/nchs/data_access/vitalstatsonline.htm
% this script does only UNIVARIATE statistics, i.e. concentrates on the
% lenght of pregnancies only (for firstborn and other babies)
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
% v2.0: 03/2019, inlusion of kerndel density estimation
% v2.1: 09/2021, minor edits, cleaning up, and more comments

%% 
% run first cell to init everything
% clean up
clear; close all; clc;

% flag for using entire file (attention - over 3.5 Mio data sets,
% loading and further processing will take long) or using smaller sub files containt 1/10 of data
% 0 = small file, 1 = large file (for final results)
ffinal = 0;

% flag for saving figures or not 
% 0 = do not save, 1 = save figures
printt = 0;

% save figures to figure directory if existing, if not use same directory
% adapt to your local setup
ppath = '..\bilder\';
if ~exist(ppath,'dir')
    ppath = '';
end

if ffinal
    % large file
    ffile = 'Nat2014PublicUS.c20150514.r20151022.txt';
else
    % small file
    ffile = 'Nat201400.txt';
end

% check if data is in extra directory, if not, assume flat structure
% adapt to your local setup
datapath = '..\data\';
if ~exist(datapath,'dir')
    fid = fopen(ffile);
else
    fid = fopen([datapath ffile]);
end

% read content of data as one string per line
t = textscan(fid,'%s','delimiter','\n');
t = t{1};

% close file
fclose(fid);

disp(['successfully read data from file ' ffile ', start to work now'])

% modify filename for use as image prefix
ffile = ffile(1:strfind(ffile,'.')-1);

%% 
% extract some parameters of interest, here: consider only one parameter
% use inidices described in user guide, together with an offset of 8

% double: length of pregancies
preglength = cellfun(@(x) str2double(x([490:491]-8)),t);
% double: which number of child is the birth (first child = 1)
birthoder = cellfun(@(x) str2double(x(179-8)),t);

% prepare cleaned vectors with lengths of first and other pregnancies

% first pregnancies
firstind = find(birthoder==1);
% all other pregnancies
otherind = find(birthoder>1);

% 99 is used for "unknown pregnancy length"
unknownlength = find(preglength==99);

% do not consider the "unknown" data sets for firstborn babies
firstind = setdiff(firstind,unknownlength);
l1 = preglength(firstind);
N1 = length(l1);

% do not consider the "unknown" data sets for other babies
otherind = setdiff(otherind,unknownlength);
lo = preglength(otherind);
No = length(lo);

% prepare vector holding lengths of first pregnancies and Nans (not a number) 
% so that it is as long as lo and vectors are compareable
l11 = NaN(size(lo));
l11(1:N1) = l1;

%%
% plot a dot for each entry found in ffile
figure(1); clf; hold; box on;
% use nicer colors if available
try
    set(gca,'colororder',fhg(2),'fontsize',18);
catch
    set(gca,'colororder',jet(2),'fontsize',18);
end

% plot data (other and first pregancies with different colors)
plot(linspace(1,length(lo),length(l1)),l1,'*');
plot(linspace(1,length(lo),length(lo)),lo,'*');

% prepare and format axes and legend
xlim([1,length(lo)]);
ylim([15,50]);
set(gca,'fontsize',18);
ylabel('pregnancy length [weeks]');
legend('first','other')
title(['length of all pregnancies found in ' ffile]);

if printt
    saveas(gcf, [ppath ffile '_preglength_all.png'],'png');
end

%%
% plot a dot for randomly selected n entries only
ind1 = randperm(length(l1));
indo = randperm(length(lo));
n = 10000;

figure(2); clf; hold;
% use nicer colors if available
try
    set(gca,'colororder',fhg(2),'fontsize',18);
catch
    set(gca,'colororder',jet(2),'fontsize',18);
end

% plot data (other and first pregancies with different colors)
plot(1:n,l1(ind1(1:n)),'*');
plot(1:n,lo(indo(1:n)),'*')

% prepare and format axes and legend
set(gca,'fontsize',18);
ylabel('pregnancy length [weeks]');
legend('first','other')
title(['length of ' num2str(n) ' pregnancies found in ' ffile]);

if printt
    saveas(gcf, [ppath ffile '_preglength_' num2str(n) '.png'],'png');
end

%%
% construct histograms (count number of entries for each possible week

% lenght of pregnancies in weeks, found in file
x1 = 17:47;

% note: "hist" is deprecated, use "histogram" instead if you are a MATLAB
% starter
% n = vector with frequencies and locations of bins on the x-axis
% locations of bins are given to be x1 = 17, 18, ... 47

n1 = hist(l1,x1);
no = hist(lo,x1);

figure(3); clf; hold; box on;
% use nicer colors if available
try
    set(gca,'colororder',fhg(2),'fontsize',18);
catch
    set(gca,'colororder',jet(2),'fontsize',18);
end

% construct bar plot with 17, 18, ... 47 on the x-axis and frequencies of
% first and other pregancies on y-axis
bar(x1,[n1;no]');

% prepare and format axes and legend
set(gca,'fontsize',18);
legend('first','other')
xlabel('pregnancy length [weeks]');
ylabel('frequency');
legend('first','other')
title(['histogram for ' ffile]);

if printt
    saveas(gcf, [ppath ffile '_preglength_hist.png'],'png');
end

%%
% create histogramm of normalized frequencies for comparison purposes
figure(4); clf; hold; box on;
% use nicer colors if available
try
    set(gca,'colororder',fhg(2),'fontsize',18);
catch
    set(gca,'colororder',jet(2),'fontsize',18);
end

% contruct bar plot with 17, 18, ... 47 on the x-axis and NORMALIZED 
% frequencies (divide each data set by number of data points)
% of first and other pregancies on y-axis
bar(x1,[n1/N1;no/No]');

% prepare and format axes and legend
legend('first','other')
xlim([20,48]);
xlabel('pregnancy length [weeks]');
ylabel('normalized frequency');
legend('first','other')
title(['histogram for ' ffile]);

if printt
    saveas(gcf, [ppath ffile '_preglength_histnorm.png'],'png');
end

%%
% try a kerndel density estimation: statistics toolbox only!
% => discussed in chapter "schliessende Statistik" of MASTER script
% some details see here: https://de.wikipedia.org/wiki/Kerndichtesch%C3%A4tzer

% considered interval
% use copy of x1 to use other values for testing purposes
x2 = x1;

% try to fit a kernel funtion for the occuring values
% and construct both the density and cumlative densitiy values
pdfkernel = zeros(2,length(x2));
cdfkernel = zeros(2,length(x2));
pdkernel(1) = fitdist(l1,'Kernel');
pdkernel(2) = fitdist(lo,'Kernel');
for i = 1:2
    pdfkernel(i,:) = pdf(pdkernel(i),x2);
    cdfkernel(i,:) = cdf(pdkernel(i),x2);
end

% plot estimated pdf
figure(44);clf;hold;
% use nicer colors if available
try
    set(gca,'colororder',fhg(2),'fontsize',18);
catch
    set(gca,'colororder',jet(2),'fontsize',18);
end

% plot both estimations at one time
plot(x2,pdfkernel,'Linewidth',2);

% prepare and format axes and legend
xlabel('pregnancy length [weeks]');
legend('first','other');
title(['Kernel Density Estimation for ' ffile]);
ylabel('probability density');
xlim([min(x2),max(x2)]);

if printt
    saveas(gcf, [ppath ffile '_preglength_kde.png'],'png');
end


%%
% plot empirical cdf
figure(5); clf; hold; box on;
% use nicer colors if available
try
    set(gca,'colororder',fhg(2),'fontsize',18);
catch
    set(gca,'colororder',jet(2),'fontsize',18);
end

% use stair function: plot sorted data vector (length of pregancies) on
% x-axis and cumulatively added relative frequencies on y-axis
stairs(x1,cumsum(n1/N1),'--','linewidth',2)
stairs(x1,cumsum(no/No),'--','linewidth',2)

% prepare and format axes and legend
legend('first','other','location','NW')
xlabel('pregnancy length [weeks]');
ylabel('cumulative normalized frequency');
title(['empirical CDF for ' ffile]);

if printt
    saveas(gcf, [ppath ffile '_preglength_cdf.png'],'png');
end

%%
% plot estimated cdf (a result of kernel density estimation)
figure(55); clf; hold; box on;
% use nicer colors if available
try
    set(gca,'colororder',fhg(2),'fontsize',18);
catch
    set(gca,'colororder',jet(2),'fontsize',18);
end

% prepare and format axes and legend
plot(x2,cdfkernel,'Linewidth',2);
xlabel('pregnancy length [weeks]');
legend('first','other','location','NW');
title(['Cumulative Kernel Density Estimation for ' ffile]);
ylabel('cumulative probability density');
ylim([0,1])
xlim([min(x2),max(x2)]);

if printt
    saveas(gcf, [ppath ffile '_preglength_ckde.png'],'png');
end

%%
% compute some statististics for comparison purposes
min1 = min(l1);
max1 = max(l1);
mean1 = mean(l1);
quant1 = quantile(l1,[0.25, 0.5, 0.75]);
std1 = std(l1);
stats1 = [min1 mean1 max1 quant1' std1 quant1(3)-quant1(1)];

mino = min(lo);
maxo = max(lo);
meano = mean(lo);
quanto = quantile(lo,[0.25, 0.5, 0.75]);
stdo = std(lo);
statso = [mino meano maxo quanto' stdo quanto(3)-quanto(1)];
%%
% compare statistics graphically
figure(6); clf; hold; box on;
% use nicer colors if available
try
    set(gca,'colororder',fhg(2),'fontsize',18);
catch
    set(gca,'colororder',jet(2),'fontsize',18);
end

% compare statistics for both data sets in one bar plot 
bar([stats1; statso]')

% prepare and format axes and legend
set(gca,'xtick',1:length(stats1));
set(gca,'xticklabel',{'min','mean','max','q25','med','q75','std','IQR'});

% rotate x-labels if helper script is available
try
    rotateticklabel(gca,75,18);
    set(gca,'position',get(gca,'position')-[0 -0.08 0 0.1]);
catch
    disp('sorry, script for rotating ticklabels not available.');
end
ylabel('pregnancy length [weeks]');
title(['statistical characteristics for ' ffile]);
legend('first','other')

if printt
    saveas(gcf, [ppath ffile '_preglength_compchar.png'],'png');
end

%%
% compute and plot difference  between all metrics
figure(7); clf; hold; box on;
set(gca,'colororder',[0 0.7 0.5]);
set(gca,'fontsize',18);

% use substration to see differences
statsdiff = stats1 - statso;
bar([statsdiff]')

% prepare and format axes and legend
set(gca,'xtick',1:length(stats1));
set(gca,'xticklabel',{'min','mean','max','q25','med','q75','std','IQR'});
ylabel('pregnancy length [weeks]');

% rotate x-labels if helper script is available
try
    rotateticklabel(gca,75,18);
    set(gca,'position',get(gca,'position')-[0 -0.08 0 0.1]);
catch
    disp('sorry, script for rotating ticklabels not available.');
end
legend('first - other','location','NE')
title(['difference of stat. char. for ' ffile]);

if printt
    saveas(gcf, [ppath ffile '_preglength_compchardiff.png'],'png');
end

%%
% create boxplots, to compare statistics at a glance
% not reasonable for pregancy lenghts, as there are too much outliers
% (visualized by red crosses)
figure(8); clf; hold; box on;
% use nicer colors if available
try
    set(gca,'colororder',fhg(1),'fontsize',18);
catch
    set(gca,'colororder',jet(1),'fontsize',18);
end

h = boxplot([l11 lo],'labels',{'first','other'});

% prepare and format axes and legend
set(gca,'fontsize',18);
ylabel('pregnancy length [weeks]');
title(['boxplot for ' ffile]);

if printt
    saveas(gcf, [ppath ffile '_preglength_boxplot.png'],'png');
end

