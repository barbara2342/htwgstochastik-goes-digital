%KAP1_WEATHERDATA_UNIVARSTATS
% script for analyzing data on Constance weather statististics from
% https://www.dwd.de/DE/leistungen/klimadatendeutschland/klarchivtagmonat.html
% this script does only UNIVARIATE statistics, i.e. concentrates on
% temperatures only; other data can be analyzed by adapting X 
% (index of data of interest, see below)
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
% v2.0: 03/2019, adapted to format changes in file
% v3.0: 08/2020, use tables for data
% v3.1: 09/2021, minor edits, cleaning up, and more comments
% v3.2: 09/2022, automatically adapting to new data files

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

ffile = ls([datapath 'klarchiv_02712_daily_his/produkt_klima*.txt']);
ffile = [datapath 'klarchiv_02712_daily_his/' ffile];

% read weatherdata collected in Constance between 1973 and last year
% extract the last year for which data is available (09/22: 2021) 
t = readtable([datapath ffile],'ReadVariablenames',true);
lastyear = max(unique(floor(t.MESS_DATUM/10000)));

disp('read table with columns as follows')
variablesInFile = t.Properties.VariableNames

% names of fields as found in file
% varnames_in_file = {'STATIONS_ID';'MESS_DATUM';'QN_3';'  FX'; ' FM';'QN_4'; 'RSK';'RSKF';' SDK';'SHK_TAG'; ' NM'; 'VPM'; ' PM'; 'TMK'; 'UPM'; 'TXK'; 'TNK'; 'TGK';};

%%
% name of fields together with units taken from metadata info (via copy and
% paste)
varnames = repmat(struct('infile','','nice','','unit',''),18,1);

varnames(1).infile = 'STATIONS_ID';
varnames(1).nice = 'StationsID';
varnames(2).infile = 'MESS_DATUM';
varnames(2).nice = 'Messdatum';
varnames(3).infile = 'QN_3';
varnames(3).nice = 'Qualitaetsniveau_3';
varnames(5).infile = 'FM';
varnames(5).nice = 'Tagesmittel_Windgeschwindigkeit';
varnames(5).unit = 'mps';
varnames(4).infile = 'FX';
varnames(4).nice = 'Maximum_Windgeschwindigkeit';
varnames(4).unit = 'mps';
varnames(6).infile = 'QN_4';
varnames(6).nice = 'Qualitaetsniveauc4';
varnames(11).infile = 'NM';
varnames(11).nice = 'Tagesmittel_Bedeckung';
varnames(11).unit = 'Achtel';
varnames(13).infile = 'PM';
varnames(13).nice = 'Tagesmittel_Luftdruck';
varnames(13).unit = 'hpa';
varnames(7).infile = 'RSK';
varnames(7).nice = 'Niederschlagshoehe';
varnames(7).unit = 'mm';
varnames(8).infile = 'RSKF';
varnames(8).nice = 'Niederschlagsform';
varnames(8).unit = 'Code';
varnames(9).infile = 'SDK';
varnames(9).nice = 'Sonnenscheindauer';
varnames(9).unit = 'hours';
varnames(10).infile = 'SHK_TAG';
varnames(10).nice = 'Schneehoehe';
varnames(10).unit = 'cm';
varnames(18).infile = 'TGK';
varnames(18).nice = 'Minimum_Lufttemperatur_am_Boden';
varnames(18).unit = '°C';
varnames(14).infile = 'TMK';
varnames(14).nice = 'Tagesmittel_Lufttemperatur';
varnames(14).unit = '°C';
varnames(17).infile = 'TNK';
varnames(17).nice = 'Tagesminimum_Lufttemperatur';
varnames(17).unit = '°C';
varnames(16).infile = 'TXK';
varnames(16).nice = 'Tagesmaximum_Lufttemperatur';
varnames(16).unit = '°C';
varnames(15).infile = 'UPM';
varnames(15).nice = 'Tagesmittel_relative_Feuchte';
varnames(15).unit = '%';
varnames(12).infile = 'VPM';
varnames(12).nice = 'Tagesmittel_Dampfdruck';
varnames(12).unit = 'hpa';
%%
% extract some parameters of interest to a struct
dat = [];

% .() is dynamical construction of fieldnames
% measurement date
dat.(varnames(2).nice) = t{:,2};
% temperature (as tagesmittel)
dat.(varnames(14).nice) = t{:,14};
% rain (as niederschlagshoehe)
dat.(varnames(7).nice) = t{:,7};
% sunshine (as sonnenscheindauer)
dat.(varnames(9).nice) = t{:,9}/3600;
% snow height (as Schneehoehe)
dat.(varnames(10).nice) = t{:,10};
% wind (as wingeschwindigkeit)
dat.(varnames(5).nice) = t{:,5};
% preasure (as luftdruck)
dat.(varnames(13).nice) = t{:,13};

disp('The following parameters might be worth looking at:')
datfieldnames = fieldnames(dat)
disp('The data is written to the following struct:')
dat

datind = [2 14 7 9 10 5 13];

%%
% prepare vectors with dates for years of interest
% choose only non-leap years (keine Schaltjahre) for simplicity reasons
% use [] to obtain struct data as array

% modify this to select different years
% 1973 = first year with daily measurements
% last year = last year with daily measurements
% linspace: care for roughly equal spaced selected years
yyears = ceil(linspace(1973,lastyear,4));

% kick out leap years
yyears(mod(yyears,4)==0) = yyears(mod(yyears,4)==0)-1;

yyearsstring = num2str(yyears');
N = length(yyears);
ind = zeros(N,365);
for i = 1:N
    % use the field containing measurement data as index
    ind(i,:) = find([dat.(datfieldnames{1})]<(yyears(i)+1)*10000&[dat.(datfieldnames{1})]>yyears(i)*10000);
end
%%
% construct vectors with data from the selected years

% modify X (as an index for datind to select a different metric
% 1:  {'Messdatum'                      } (not reasonable)
% 2:  {'Tagesmittel_Lufttemperatur'     }
% 3:  {'Niederschlagshoehe'             }
% 4:  {'Sonnenscheindauer'              }
% 5:  {'Schneehoehe'                    }
% 6:  {'Tagesmittel_Windgeschwindigkeit'}
% 7:  {'Tagesmittel_Luftdruck'          }
X = 2; % temperature is default

disp('The following value is selected:')
field = datfieldnames{X}

% construct struct for data indexed by considered years as string
temp = [];
for i = 1:N
    tttemp = dat.(field)(ind(i,:));
    % handle invalid data (NaN = not a number will be ignored by Matlab)
    tttemp(tttemp==-999) = NaN;
    temp.(['y' yyearsstring(i,:)]) = tttemp;
end

% all data in a matrix
tall = cell2mat(struct2cell(temp)')'; 

% total minimum and maximum in all considered years
% min / max functions work on a per column / per row basis
temp.min = min(min(tall));
temp.max = max(max(tall));
temp.unit = varnames(datind(X)).unit;
%%
% plot a dot for each entry found in ffile
figure(1); clf; hold; box on;
% use nicer colors if available
try
    set(gca,'colororder',fhg(N),'fontsize',18);
catch
    set(gca,'colororder',jet(N),'fontsize',18);
end

% plot data each considered year with a different color 
plot(1:365,tall,'*','Linewidth',1);

% prepare and format axes and legend
xlim([1,365]);
ylabel(temp.unit);
xlabel('number of day');
legend(yyearsstring)
fieldnice = field;
fieldnice(fieldnice=='_')=' ';
title([fieldnice ', daily values']);

if printt
    saveas(gcf, [ppath field '_all.png'],'png');
end


%%
% construct histograms (count number of entries for each of 15 equally
% spaced intervals)
% note: "hist" is deprecated, use "histogram" instead if you are a MATLAB
% starter
% [n,x] = vector with frequencies and locations of 15 equally spaced bins on the x-axis
[n,x] = hist(tall',15);

figure(2); clf; hold; box on;
% use nicer colors if available
try
    set(gca,'colororder',fhg(N),'fontsize',18);
catch
    set(gca,'colororder',jet(N),'fontsize',18);
end

% construct bar plot with bins (x) on the x-axis and frequencies (n) on the
% y-axis
bar(x,n);

% prepare and format axes and legend
xlabel(temp.unit); 
legend(yyearsstring,'location','NW')
title(['histogram for ' fieldnice]);
ylabel('frequency');
xlim([temp.min,temp.max]);

if printt
    saveas(gcf, [ppath field '_hist.png'],'png');
end

%%
% try a kerndel density estimation
% => discussed in chapter "schliessende Statistik" of MASTER script
% some details see here: https://de.wikipedia.org/wiki/Kerndichtesch%C3%A4tzer

% considered interval (and regularly spaced data points)
x2 = temp.min:0.1:temp.max;

% try to fit a kernel funtion for the occuring values
% and construct both the density and cumlative densitiy values
pdfkernel = zeros(N,length(x2));
cdfkernel = zeros(N,length(x2));
for i = 1:N
    pdkernel(i) = fitdist(tall(i,:)','Kernel');
    pdfkernel(i,:) = pdf(pdkernel(i),x2);
    cdfkernel(i,:) = cdf(pdkernel(i),x2);
end

% plot estimated pdf
figure(22); clf; hold; box on;
% use nicer colors if available
try
    set(gca,'colororder',fhg(N),'fontsize',18);
catch
    set(gca,'colororder',jet(N),'fontsize',18);
end

plot(x2,pdfkernel,'Linewidth',2);

% prepare and format axes and legend
xlabel(temp.unit);
legend(yyearsstring,'Location','NW')
title(['Kernel Density Estimation for ' fieldnice]);
ylabel('probability density');
xlim([temp.min,temp.max]);
if printt
    saveas(gcf, [ppath field '_kde.png'],'png');
end
%%
% plot empirical cdf
figure(3); clf; hold; box on;
% use nicer colors if available
try
    set(gca,'colororder',fhg(N),'fontsize',18);
catch
    set(gca,'colororder',jet(N),'fontsize',18);
end

% plot empiricial cdf by putting all sorted data on the x-axis and the
% vector [1:length(data)]/length(data) on the y-axis
for i = 1:N
   stairs(sort(tall(i,:)),[1:365]/365,'-','linewidth',2);
end

% prepare and format axes and legend
xlabel(temp.unit);
legend(yyearsstring,'location','SE')
title(['emprirical CDF for ' fieldnice]);
ylabel('probability');
xlim([temp.min,temp.max]);
ylim([0,1]);
set(gca,'xtick', linspace(floor(temp.min), ceil(temp.max),6));
if printt
    saveas(gcf, [ppath field '_cdf.png'],'png');
end

%%
% plot cumulative kernel density estimation
figure(44); clf; hold; box on;
% use nicer colors if available
try
    set(gca,'colororder',fhg(N),'fontsize',18);
catch
    set(gca,'colororder',jet(N),'fontsize',18);
end

plot(x2,cdfkernel,'Linewidth',2);

% prepare and format axes and legend
xlabel(temp.unit);
legend(yyearsstring,'Location','NW')
title(['Comulative Kernel Density Estimation for ' fieldnice]);
ylabel('cumulative probability density');
xlim([temp.min,temp.max]);
if printt
    saveas(gcf, [ppath field '_ckde.png'],'png');
end


%%
% compute some statististics
stats= [];
for i = 1:N
    ttemp = temp.(['y' yyearsstring(i,:)]);
    minn = min(ttemp);
    maxx = max(ttemp);
    meann = nanmean(ttemp);
    quant = quantile(ttemp,[0.25, 0.5, 0.75]);
    stdd = std(ttemp);
    stats.(['y' yyearsstring(i,:)]) = [minn meann maxx quant' stdd quant(3)-quant(1)];
end
statsall = cell2mat(struct2cell(stats));
%%
% compare statistics graphically
figure(4); clf; hold; box on;
% use nicer colors if available
try
    set(gca,'colororder',fhg(N),'fontsize',18);
catch
    set(gca,'colororder',jet(N),'fontsize',18);
end

% compare statistics in a bar plot
bar(statsall');

% prepare and format axes and legend
ylabel(temp.unit);
set(gca,'xtick',1:length(statsall),'fontsize',18);
set(gca,'xticklabel',{'min','mean','max','q25','med','q75','std','IQR'});

% rotate x-labels if helper script is available
try
    rotateticklabel(gca,75,18);
    set(gca,'position',get(gca,'position')-[0 -0.08 0 0.1]);
catch
    disp('sorry, script for rotating ticklabels not available.');
end
title(['stat. char. for ' fieldnice]);
legend(yyearsstring,'location','NW')

if printt
    saveas(gcf, [ppath field '_compchar.png'],'png');
end

%%
% compute and plot difference  between all metrics
statsdiff = zeros(N-1,length(statsall));
for i = 1:N-1
    statsdiff(i,:) = statsall(i+1,:) - statsall(1,:);
end
figure(5); clf; hold; box on;
% use nicer colors if available
try
    set(gca,'colororder',fhg(N-1),'fontsize',18);
catch
    set(gca,'colororder',jet(N-1),'fontsize',18);
end

bar(statsdiff')

% prepare and format axes and legend
set(gca,'xtick',1:length(statsdiff),'fontsize',18);
set(gca,'xticklabel',{'min','mean','max','q25','med','q75','std','IQR'});
ylabel(temp.unit);
legend(yyearsstring(2:end,:),'location','NE')

% rotate x-labels if helper script is available
try
    rotateticklabel(gca,75,18);
    set(gca,'position',get(gca,'position')-[0 -0.05 0 0.06]);
catch
    disp('sorry, script for rotating ticklabels not available.');
end

title(['diff. to ' yyearsstring(1,:) ' stat. char. for ' fieldnice]);
if printt
    saveas(gcf, [ppath field '_compchardiff.png'],'png');
end


%%
% create boxplot, to compare statistics at a glance
figure(6); clf; hold; box on;

% use nicer colors if available
try
    set(gca,'colororder',fhg(N),'fontsize',18);
catch
    set(gca,'colororder',jet(N),'fontsize',18);
end

% use notch to indicate statistical differences
h = boxplot(tall','labels',yyearsstring,'Notch','on');
% plot line connecting medians
plot(1:N, median(tall,2), 'o--','Linewidth',2,'color','r')

% prepare and format axes and legend
set(gca,'fontsize',18);
ylabel(temp.unit);
title(['boxplot for ' fieldnice]);

if printt
    saveas(gcf, [ppath field '_boxplot.png'],'png');
end

%%
% calculate mean, med, min, max for all years
yyears = 1973:lastyear;

yyearsstring = num2str(yyears');
N = length(yyears);

stat = zeros(N,4); 
stattitle = {'Mean';'Median';'Minimum';'Maximum'};

for i = 1:N
    % use the field containing measurement data as index
    ind = find([dat.(datfieldnames{1})]<(yyears(i)+1)*10000&[dat.(datfieldnames{1})]>yyears(i)*10000);
    ttemp = dat.(field)(ind);
    % handle invalid data (NaN = not a number will be ignored by Matlab)
    ttemp(ttemp==-999) = NaN;
    stat(i,1) = nanmean(ttemp);
    stat(i,2) = nanmedian(ttemp);
    stat(i,3) = nanmin(ttemp);
    stat(i,4) = nanmax(ttemp);
end

% difference between lastyear and 1973 (attention: random effects)
dif = stat(end,:)-stat(1,:);

%%
% create boxplot, to compare statistics at a glance
figure(6); clf; hold; box on;

% use nicer colors if available
try
    cols = fhg(4);
catch
    cols = jet(4);  %,'fontsize',18);
end

% arrange all plots in a 4x4 array for comparison purposes
for i = 1:4
    subplot(2,2,i);
    plot(yyears,stat(:,i),'*:','color',cols(i,:),'linewidth',2)
    
    % prepare and format axes 
    ylabel(temp.unit);
    title([stattitle{i} ' for ' fieldnice '; Diff 1973/' num2str(lastyear) ': ' num2str(dif(i),2) ' ' temp.unit]);
    set(gca,'fontsize',16);
    xlim([min(yyears)-1 max(yyears)+1]);
end

% ensure that figure as png does not look weird
set(gcf,'WindowState','maximized');
if printt
    saveas(gcf, [ppath field '_timeseries.png'],'png');
end

%%
