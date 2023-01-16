%KAP1_PREGDATA_MULTIVARSTATS
% script for analyzing 'Nat2014PublicUS.c20150514.r20151022.txt'
% holding data on pregnancies downloaded from
% http://www.cdc.gov/nchs/data_access/vitalstatsonline.htm
% this script does only MULTIVARIATE statistics, i.e. concentrates on the
% correlations between birth weight and other factors
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
% v2.0: 09/2021, throw out dependencies on other scripts,
% minor edits, cleaning up, and more comments

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
% use different path for figures produced from large data (used for lecture
% script)
if ffinal
    ppath = '..\bilder\alledaten_babys\';
else
    ppath = '..\bilder\';
end
if ~exist(ppath,'dir')
    ppath = '';
end

% use large or small file
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
    datapath = '';
else
    fid = fopen([datapath ffile]);
end

% read content of data as one string per line
t = textscan(fid,'%s','delimiter','\n');

disp(['successuflly read data from file ' datapath ffile ', start to work now'])

t = t{1};

% close file
fclose(fid);

% modify filename for use as image prefix
ffile = ffile(1:strfind(ffile,'.')-1);

%%
% extract some parameters of interest
% use inidices described in user guide, together with an offset of 8

% double: length of pregancies
preglength = cellfun(@(x) str2double(x([490:491]-8)),t);
% double: weight of baby
weight = cellfun(@(x) str2double(x([504:507]-8)),t);
% double: weight of mother
motherweight = cellfun(@(x) str2double(x([292:294]-8)),t);
% double: weight, of mother after birth
motherweightbirth = cellfun(@(x) str2double(x([299:301]-8)),t);
% double: weight, mother gained during pregnancy
motherweightgain = motherweightbirth - motherweight;

% double: which number of child is the birth (first child = 1)
birthoder = cellfun(@(x) str2double(x([179]-8)),t);
% double: age of mother
motherage = cellfun(@(x) str2double(x([75:76]-8)),t);

% double: time of birth
timeofbirth = cellfun(@(x) str2double(x([19:22]-8)),t);
% double: number of prenatal visits at doctor
previs = cellfun(@(x) str2double(x([238:239]-8)),t);

% double: numer of cigarets smoked during pregnancy
cig = zeros(4,length(previs));
% double
for i = 1:4
    cig(i,:) = cellfun(@(x) str2double(x([253:254]+(i-1)*2-8)),t);
end

% garbage collection: kill not used data from memory
clear('t');

disp(' '); 
disp('successfully extracted parameters of interest');

%%
% data cleaning ( 9+ is used for "unknown", which is a number that would
% falsify mean values etc)
% do not kick out data, but just register where the false data is

% prepare cleaned vectors
% use L as the number of data points
L = length(weight);
disp(' '); 
disp(['Number of data points handled: ' num2str(L)])

% 9999 is used for "unknown"
unknown = find(weight==9999);
ind_w = setdiff(1:L,unknown);

% 9999 is used for "unknown"
unknown = find(timeofbirth==9999);
ind_tb = setdiff(1:L,unknown);

% 999 is used for "unknown"
unknown = find(motherweight==999);
ind_mw = setdiff(1:L,unknown);

% 999 is used for "unknown"
unknown = find(motherweightbirth==999);
ind_mwb = setdiff(1:L,unknown);

% 99 is used for "unknown"
unknown = find(previs==99);
ind_previs = setdiff(1:L,unknown);

% 99 is used for "unknown"
unknown = find(preglength==99);
ind_pl = setdiff(1:L,unknown);

% 9 is used for "unknown"
unknown = find(birthoder==9);
ind_o = setdiff(1:L,unknown);

ind_cigarettes = [];
for i = 1:4
    % 99 is used for "unknown number"
    unknown = find(cig(i,:)==99);
    ind_cigarettes = union(ind_cigarettes,setdiff(1:L,unknown));
end

% consider baby weight in kg
weight = weight/1000;

disp(' '); 
disp('successfully found location of unknown data');


%%
% use only data rows for which both datasets have reasonable values
ind = intersect(ind_w,ind_pl);
I = length(ind);
pl = preglength(ind);
w = weight(ind);

figure(1);clf; hold; box on; 

% plot dots for each combination of data point
% scatter slighty randomly, to avoid plotting to many points at the same
% location
scatter(pl+rand(I,1)-0.5,w+(rand(I,1)-0.5)/10); 

% prepare and format axes and legend
set(gca,'fontsize',18);
set(gca,'xlim',[15,50],'ylim',[0,8]);
xlabel('pregnancy length [weeks]');
ylabel('birth weight [kg]');
title('Birth weight vs. Pregnancy length');

% calculate and display coefficient of correlation
c = corrcoef(pl,w);
c = c(2,1);
xl = get(gca,'xlim');
yl = get(gca,'ylim');
xr = xl(2)-xl(1);
yr = yl(2)-yl(1);
text(min(xl)+0.05*xr,max(yl)-0.05*yr,['r = ' num2str(c)],'fontsize',18);
text(min(xl)+0.05*xr,max(yl)-0.15*yr,['R^2 = ' num2str(c^2)],'fontsize',18);

if printt
    saveas(gcf, [ppath 'correlation_weight_preglength.png'],'png');
end
%%
% 
[~,m,b] = regression(pl,w,'one');
line(xlim,xlim*m+b,'color','r','linewidth',2)
regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)];
legend('data',regline,'location','SE')

if printt
    saveas(gcf, [ppath 'correlation_weight_preglength_fit.png'],'png');
end

[r,m,b] = regression(w,pl,'one');
line(ylim*m+b,ylim,'color','m','linewidth',2)
regline2 = ['x = f(y) = ' num2str(m,3) 'y + ' num2str(b,3)];
legend('data',regline,regline2,'location','SE')

if printt
    saveas(gcf, [ppath 'correlation_weight_preglength_fit2.png'],'png');
end

if ffinal
    close all
end

%%
% use only data rows for which both datasets have reasonable values
ind = intersect(ind_w,ind_o);
I = length(ind);
pl = birthoder(ind);
w = weight(ind);

figure(2);clf; hold; box on; 

% plot dots for each combination of data point
% scatter slighty randomly, to avoid plotting to many points at the same
% location
scatter(pl,w+(rand(I,1)-0.5)/10);

% prepare and format axes and legend
set(gca,'fontsize',18);
set(gca,'xlim',[0,9],'ylim',[0,8]);
xlabel('birthorder');
ylabel('birth weight [kg]');
title('Birth weight vs. Birth order');

% calculate and display coefficient of correlation
c = corrcoef(pl,w);
c = c(2,1);
xl = get(gca,'xlim');
yl = get(gca,'ylim');
xr = xl(2)-xl(1);
yr = yl(2)-yl(1);
text(min(xl)+0.05*xr,max(yl)-0.05*yr,['r = ' num2str(c)],'fontsize',18);
text(min(xl)+0.05*xr,max(yl)-0.15*yr,['R^2 = ' num2str(c^2)],'fontsize',18);

if printt
    saveas(gcf, [ppath 'correlation_weight_birthorder.png'],'png');
end
%%
[r,m,b] = regression(pl,w,'one');
line(xlim,xlim*m+b,'color','r','linewidth',2)
regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)];
legend('data',regline,'location','SE')

if printt
    saveas(gcf, [ppath 'correlation_weight_birthorder_fit.png'],'png');
end
%
[r,m,b] = regression(w,pl,'one');
line(ylim*m+b,ylim,'color','m','linewidth',2)
regline2 = ['x = f(y) = ' num2str(m,3) 'y + ' num2str(b,3)];
legend('data',regline,regline2,'location','SE')

if printt
    saveas(gcf, [ppath 'correlation_weight_birthorder_fit2.png'],'png');
end

if ffinal
    close all
end

%%
% use only data rows for which both datasets have reasonable values
ind = ind_w;
I = length(ind);
w = weight(ind);
ma = motherage(ind);


figure(3);clf; hold; box on; 

% plot dots for each combination of data point
% scatter slighty randomly, to avoid plotting to many points at the same
% location
scatter(ma+rand(I,1)-0.5,w+(rand(I,1)-0.5)/10); %,motherage)

% prepare and format axes and legend
set(gca,'fontsize',18);
set(gca,'xlim',[10,52],'ylim',[0,8]);
ylabel('birth weight [kg]');
xlabel('age of mother [years]');
title('Birth weight vs. Age of mother');

% calculate and display coefficient of correlation
c = corrcoef(ma,w);
c = c(2,1);
xl = get(gca,'xlim');
yl = get(gca,'ylim');
xr = xl(2)-xl(1);
yr = yl(2)-yl(1);
text(min(xl)+0.05*xr,max(yl)-0.05*yr,['r = ' num2str(c)],'fontsize',18);
text(min(xl)+0.05*xr,max(yl)-0.15*yr,['R^2 = ' num2str(c^2)],'fontsize',18);

if printt
    saveas(gcf, [ppath 'correlation_weight_motherage.png'],'png');
end

%%
[r,m,b] = regression(ma,w,'one');
line(xlim,xlim*m+b,'color','r','linewidth',2)
regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)];
legend('data',regline,'location','SE')

if printt
    saveas(gcf, [ppath 'correlation_weight_motherage_fit.png'],'png');
end

[r,m,b] = regression(w,ma,'one');
line(ylim*m+b,ylim,'color','m','linewidth',2)
regline2 = ['x = f(y) = ' num2str(m,3) 'y + ' num2str(b,3)];
legend('data',regline,regline2,'location','SE')

if printt
    saveas(gcf, [ppath 'correlation_weight_motherage_fit2.png'],'png');
end

if ffinal
    close all
end

%%
% use only data rows for which both datasets have reasonable values
ind = intersect(ind_w,ind_tb);
I = length(ind);
w = weight(ind);
tb = timeofbirth(ind);

figure(4);clf; hold; box on; 



% plot dots for each combination of data point
% scatter slighty randomly, to avoid plotting to many points at the same
% location
scatter(tb+rand(I,1)-0.5,w+(rand(I,1)-0.5)/10); %,motherage)

% prepare and format axes and legend
set(gca,'fontsize',18);
set(gca,'xlim',[0,2400],'ylim',[0,8]);
ylabel('birth weight [kg]');
xlabel('time of birth [HHMM]');
title('Birth weight vs. Time of birth');

% calculate and display coefficient of correlation
c = corrcoef(tb,w);
c = c(2,1);
xl = get(gca,'xlim');
yl = get(gca,'ylim');
xr = xl(2)-xl(1);
yr = yl(2)-yl(1);

text(min(xl)+0.05*xr,max(yl)-0.05*yr,['r = ' num2str(c)],'fontsize',18);
text(min(xl)+0.05*xr,max(yl)-0.15*yr,['R^2 = ' num2str(c^2)],'fontsize',18);

if printt
    saveas(gcf, [ppath 'correlation_weight_timeofbirth.png'],'png');
end

%%
[r,m,b] = regression(tb,w,'one');
line(xlim,xlim*m+b,'color','r','linewidth',2)
regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)];
legend('data',regline,'location','SE')

if printt
    saveas(gcf, [ppath 'correlation_weight_timeofbirth_fit.png'],'png');
end

[r,m,b] = regression(w,tb,'one');
line(ylim*m+b,ylim,'color','m','linewidth',2)
regline2 = ['x = f(y) = ' num2str(m,3) 'y + ' num2str(b,3)];
legend('data',regline,regline2,'location','SE')

if printt
    saveas(gcf, [ppath 'correlation_weight_timeofbirth_fit2.png'],'png');
end

if ffinal
    close all
end

%%
% use only data rows for which both datasets have reasonable values
ind = intersect(ind_w,ind_previs);
I = length(ind);
w = weight(ind);

pv = previs(ind);


figure(5);clf; hold; box on; 

% plot dots for each combination of data point
% scatter slighty randomly, to avoid plotting to many points at the same
% location
scatter(pv+rand(I,1)-0.5,w+(rand(I,1)-0.5)/10); %,motherage)

% prepare and format axes and legend
set(gca,'fontsize',18);
set(gca,'xlim',[0,80],'ylim',[0,8]);
ylabel('birth weight [kg]');
xlabel('number of prenatal visits');
title('Birth weight vs. Prenatal visits');

% calculate and display coefficient of correlation
c = corrcoef(pv,w);
c = c(2,1);
xl = get(gca,'xlim');
yl = get(gca,'ylim');
xr = xl(2)-xl(1);
yr = yl(2)-yl(1);
text(min(xl)+0.05*xr,max(yl)-0.05*yr,['r = ' num2str(c)],'fontsize',18);
text(min(xl)+0.05*xr,max(yl)-0.15*yr,['R^2 = ' num2str(c^2)],'fontsize',18);

if printt
    saveas(gcf, [ppath 'correlation_weight_prenatvisits.png'],'png');
end

%%
[r,m,b] = regression(pv,w,'one');
line(xlim,xlim*m+b,'color','r','linewidth',2)
regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)];
legend('data',regline,'location','SE')

if printt
    saveas(gcf, [ppath 'correlation_weight_prenatalvisits_fit.png'],'png');
end

[r,m,b] = regression(w,pv,'one');
line(ylim*m+b,ylim,'color','m','linewidth',2)
regline2 = ['x = f(y) = ' num2str(m,3) 'y + ' num2str(b,3)];
legend('data',regline,regline2,'location','SE')
saveas(gcf, [ppath 'correlation_weight_prenatalvisits_fit2.png'],'png');

if ffinal
    close all
end


%%
for i = 1:4
    ind = intersect(ind_w,ind_cigarettes);
    I = length(ind);
    w = weight(ind);
    
    ci = cig(i, ind);
    figure(5+i);clf; hold
    
    % plot dots for each combination of data point
    % scatter slighty randomly, to avoid plotting to many points at the same
    % location
    scatter(ci+rand(1,I)-0.5,weight(ind)+rand(I,1)-0.5); %,motherage)
    
    % prepare and format axes and legend
    set(gca,'fontsize',18);
    set(gca,'xlim',[0,50],'ylim',[0,8]);
    ylabel('birth weight [kg]');
    xlabel(['number of daily cigarettes in trimester no.' num2str(i-1)])
    title('Birth weight vs. Number of cigarettes');
    
    % calculate and display coefficient of correlation
    c = corrcoef(ci,w);
    c = c(2,1);
    xl = get(gca,'xlim');
    yl = get(gca,'ylim');
    xr = xl(2)-xl(1);
    yr = yl(2)-yl(1);
    text(min(xl)+0.05*xr,max(yl)-0.05*yr,['r = ' num2str(c)],'fontsize',18);
    text(min(xl)+0.05*xr,max(yl)-0.15*yr,['R^2 = ' num2str(c^2)],'fontsize',18);
    
    if printt
        saveas(gcf, [ppath 'correlation_weight_cigarettesintrim' num2str(i-1) '.png'])
    end
    
    [r,m,b] = regression(ci',w,'one');
    line(xlim,xlim*m+b,'color','r','linewidth',2)
    regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)];
    legend('data',regline,'location','SE')
    
    if printt
        saveas(gcf, [ppath 'correlation_weight_cigarettesintrim' num2str(i-1) '_fit.png'])
    end
    
    [r,m,b] = regression(w,ci','one');
    line(ylim*m+b,ylim,'color','m','linewidth',2)
    regline2 = ['x = f(y) = ' num2str(m,3) 'y + ' num2str(b,3)];
    legend('data',regline,regline2,'location','SE')
    
    if printt
        saveas(gcf, [ppath 'correlation_weight_cigarettesintrim' num2str(i-1) '_fit2.png'])
    end
    
    if ffinal
        close all
    end
    
    
end

%%
% use only data rows for which both datasets have reasonable values
ind = intersect(ind_w,ind_mw);
I = length(ind);
w = weight(ind);
mw = motherweight(ind)/2;

figure(10);clf; hold; box on; 

% plot dots for each combination of data point
% scatter slighty randomly, to avoid plotting to many points at the same
% location
scatter(mw+(rand(I,1)-0.5)/10,w+(rand(I,1)-0.5)/10); %,motherage)

% prepare and format axes and legend
set(gca,'fontsize',18);
set(gca,'xlim',[40,200],'ylim',[0,8]);
ylabel('birth weight [kg]');
xlabel('mother weight before pregnancy [kg]');
title('Birth weight vs. Mother weight (before)');

% calculate and display coefficient of correlation
c = corrcoef(mw,w);
c = c(2,1);
xl = get(gca,'xlim');
yl = get(gca,'ylim');
xr = xl(2)-xl(1);
yr = yl(2)-yl(1);
text(min(xl)+0.05*xr,max(yl)-0.05*yr,['r = ' num2str(c)],'fontsize',18);
text(min(xl)+0.05*xr,max(yl)-0.15*yr,['R^2 = ' num2str(c^2)],'fontsize',18);

if printt
    saveas(gcf, [ppath 'correlation_weight_motherweightpre.png'],'png');
end

%%
[r,m,b] = regression(mw,w,'one');
line(xlim,xlim*m+b,'color','r','linewidth',2)
regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)];
legend('data',regline,'location','SE')

if printt
    saveas(gcf, [ppath 'correlation_weight_motherweitghpre_fit.png'],'png');
end

[r,m,b] = regression(w,mw,'one');
line(ylim*m+b,ylim,'color','m','linewidth',2)
regline2 = ['x = f(y) = ' num2str(m,3) 'y + ' num2str(b,3)];
legend('data',regline,regline2,'location','SE')

if printt
    saveas(gcf, [ppath 'correlation_weight_motherweightpre_fit2.png'],'png');
end

if ffinal
    close all
end


%%
ind = intersect(ind_w,ind_mwb);
I = length(ind);
w = weight(ind);
mw = motherweightbirth(ind)/2;

figure(11);clf; hold; box on; 

% plot dots for each combination of data point
% scatter slighty randomly, to avoid plotting to many points at the same
% location
scatter(mw+(rand(I,1)-0.5)/10,w+(rand(I,1)-0.5)/10); %,motherage)

% prepare and format axes and legend
set(gca,'fontsize',18);
set(gca,'xlim',[40,210],'ylim',[0,8]);
ylabel('birth weight [kg]');
xlabel('mother weight at birth [kg]');
title('Birth weight vs. Mother weight (birth)');

% calculate and display coefficient of correlation
c = corrcoef(mw,w);
c = c(2,1);
xl = get(gca,'xlim');
yl = get(gca,'ylim');
xr = xl(2)-xl(1);
yr = yl(2)-yl(1);
text(min(xl)+0.05*xr,max(yl)-0.05*yr,['r = ' num2str(c)],'fontsize',18);
text(min(xl)+0.05*xr,max(yl)-0.15*yr,['R^2 = ' num2str(c^2)],'fontsize',18);

if printt
    saveas(gcf, [ppath 'correlation_weight_motherweightbirth.png'],'png');
end

%%
[r,m,b] = regression(mw,w,'one');
line(xlim,xlim*m+b,'color','r','linewidth',2)
regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)];
legend('data',regline,'location','SE')

if printt
    saveas(gcf, [ppath 'correlation_weight_motherweitghtbirth_fit.png'],'png');
end

[r,m,b] = regression(w,mw,'one');
line(ylim*m+b,ylim,'color','m','linewidth',2)
regline2 = ['x = f(y) = ' num2str(m,3) 'y + ' num2str(b,3)];
legend('data',regline,regline2,'location','SE')

if printt
    saveas(gcf, [ppath 'correlation_weight_motherweightbirth_fit2.png'],'png');
end

if ffinal
    close all
end


%%
% use only data rows for which both datasets have reasonable values
ind = intersect(ind_mw,ind_mwb);
ind = intersect(ind_w,ind);
I = length(ind);
w = weight(ind);

mw = motherweightgain(ind)/2;

figure(12);clf; hold; box on; 

% plot dots for each combination of data point
% scatter slighty randomly, to avoid plotting to many points at the same
% location
scatter(mw+(rand(I,1)-0.5)/10,w+(rand(I,1)-0.5)/10); %,motherage)

% prepare and format axes and legend
set(gca,'fontsize',18);
set(gca,'xlim',[-100, 105],'ylim',[0,8]);
ylabel('birth weight [kg]');
xlabel('mother weight gain during pregnancy [kg]');
title('Birth weight vs. Mother weight gain');

% calculate and display coefficient of correlation
c = corrcoef(mw,w);
c = c(2,1);
xl = get(gca,'xlim');
yl = get(gca,'ylim');
xr = xl(2)-xl(1);
yr = yl(2)-yl(1);
text(min(xl)+0.05*xr,max(yl)-0.05*yr,['r = ' num2str(c)],'fontsize',18);
text(min(xl)+0.05*xr,max(yl)-0.15*yr,['R^2 = ' num2str(c^2)],'fontsize',18);

if printt
    saveas(gcf, [ppath 'correlation_weight_motherweightgain.png'],'png');
end

%%
[r,m,b] = regression(mw,w,'one');
line(xlim,xlim*m+b,'color','r','linewidth',2)
regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)];
legend('data',regline,'location','SE')

if printt
    saveas(gcf, [ppath 'correlation_weight_motherweightgain_fit.png'],'png');
end

[r,m,b] = regression(w,mw,'one');
line(ylim*m+b,ylim,'color','m','linewidth',2)
regline2 = ['x = f(y) = ' num2str(m,3) 'y + ' num2str(b,3)];
legend('data',regline,regline2,'location','SE')

if printt
    saveas(gcf, [ppath 'correlation_weight_motherweightgain_fit2.png'],'png');
end

if ffinal
    close all
end


%%
% plot empirical cdf of baby weight at birth and compare to theoretical
% normal cdf

figure(12);clf; hold; box on; 

w = weight(ind_w);
plot(sort(w),[1:length(w)]/length(w)); %,motherage)

% prepare and format axes and legend
set(gca,'fontsize',18);
%set(gca,'xlim',[-100, 105],'ylim',[0,8]);
xlabel('birth weight [kg]');
ylabel('empirical CDF');

title('Birth weight');
mu = mean(w);
s = std(w);

xl = get(gca,'xlim');
yl = get(gca,'ylim');

xr = xl(2)-xl(1);
yr = yl(2)-yl(1);

text(min(xl)+0.05*xr,max(yl)-0.05*yr,['\mu = ' num2str(mu)],'fontsize',18);
text(min(xl)+0.05*xr,max(yl)-0.15*yr,['\sigma = ' num2str(s)],'fontsize',18);

%%
% plot empirical cdf of baby weight at birth and compare to theoretical
% normal cdf

w = weight(ind_w);

figure(12);clf; hold; box on; 

plot(sort(w),[1:length(w)]/length(w), 'linewidth',2);

% prepare and format axes and legend
set(gca,'fontsize',18);
%set(gca,'xlim',[-100, 105],'ylim',[0,8]);
xlabel('birth weight [kg]');
ylabel('empirical CDF');

title('Birth weight');
mu = mean(w);
s = std(w);

xl = get(gca,'xlim');
yl = get(gca,'ylim');

xr = xl(2)-xl(1);
yr = yl(2)-yl(1);

text(min(xl)+0.05*xr,max(yl)-0.05*yr,['m_w = ' num2str(mu)],'fontsize',18);
text(min(xl)+0.05*xr,max(yl)-0.15*yr,['s_w = ' num2str(s)],'fontsize',18);

x = min(w):0.001:max(w);
y = normcdf(x,mu,s);
plot(x,y,'linewidth',2);
legend('empiricial CDF',['N(' num2str(mu,2) ',' num2str(s^2,2) ')'],'location','SE')

if printt
    saveas(gcf, [ppath 'weight_cdf.png'],'png');
end

if ffinal
    close all
end

%%
% plot empirical cdf of baby weight at birth and compare to theoretical
% normal cdf

w = weight(ind_w);

figure(12);clf; hold; box on; 

set(gca,'fontsize',18);
plot(sort(w),[1:length(w)]/length(w)); %,motherage)
%set(gca,'xlim',[-100, 105],'ylim',[0,8]);
xlabel('birth weight [kg]');
ylabel('empirical CDF');

title('Birth weight');
mu = mean(w);
s = std(w);

xl = get(gca,'xlim');
yl = get(gca,'ylim');

xr = xl(2)-xl(1);
yr = yl(2)-yl(1);

text(min(xl)+0.05*xr,max(yl)-0.05*yr,['\mu = ' num2str(mu)],'fontsize',18);
text(min(xl)+0.05*xr,max(yl)-0.15*yr,['\sigma = ' num2str(s)],'fontsize',18);

%%
% plot empirical cdf of baby weight at birth and compare to theoretical
% normal cdf

w = weight(ind_w);
figure(12);clf; hold; box on; 

set(gca,'fontsize',18);
plot(sort(w),[1:length(w)]/length(w), 'linewidth',2);
%set(gca,'xlim',[-100, 105],'ylim',[0,8]);
xlabel('birth weight [kg]');
ylabel('empirical CDF');

title('Birth weight');
mu = mean(w);
s = std(w);

xl = get(gca,'xlim');
yl = get(gca,'ylim');

xr = xl(2)-xl(1);
yr = yl(2)-yl(1);

text(min(xl)+0.05*xr,max(yl)-0.05*yr,['m_w = ' num2str(mu)],'fontsize',18);
text(min(xl)+0.05*xr,max(yl)-0.15*yr,['s_w = ' num2str(s)],'fontsize',18);

x = min(w):0.001:max(w);
y = normcdf(x,mu,s);
plot(x,y,'linewidth',2);
legend('empiricial CDF',['N(' num2str(mu,2) ',' num2str(s^2,2) ')'],'location','SE')

if printt
    saveas(gcf, [ppath 'weight_cdf.png'],'png');
end

if ffinal
    close all
end
