%READPREGDATA
% script for reading and analyzing (a part of) 'Nat2014PublicUS.c20150514.r20151022.txt'
% holding data on pregnancies downloaded from
% http://www.cdc.gov/nchs/data_access/vitalstatsonline.htm
%
% copyright: Barbara Staehle, HTWG Konstanz
% bstaehle@htwg-konstanz.de
%

clear;

ffinal = 0;

% read entire file (attention - over 3.5 Mio data sets,
% loading and further processing will take long)

if ffinal
    ffile = '../Nat2014PublicUS.c20150514.r20151022.txt';
else
    % read first / one of sub files
    ffile = 'Nat201400.txt';
    %ffile = 'Nat201403.txt';
end

fid = fopen(ffile);

% read content of data as one string per line
t = textscan(fid,'%s','delimiter','\n');
t = t{1};

% close file
fclose(fid);

% modify filename for use as image prefix
ffile = ffile(1:strfind(ffile,'.')-1);

%%
% extract some parameters of interest
% use inidices described in user guide, together with an offset of 8

% double
preglength = cellfun(@(x) str2double(x([490:491]-8)),t);
% double
weight = cellfun(@(x) str2double(x([504:507]-8)),t);
% double
motherweight = cellfun(@(x) str2double(x([292:294]-8)),t);
% double
motherweightbirth = cellfun(@(x) str2double(x([299:301]-8)),t);
% double
motherweightgain = motherweightbirth - motherweight;

% string
%sex = cellfun(@(x) x([475]-8),t);
% double
birthoder = cellfun(@(x) str2double(x([179]-8)),t);
% double
motherage = cellfun(@(x) str2double(x([75:76]-8)),t);
% double
%fatherage = cellfun(@(x) str2double(x([177:148]-8)),t);

% double
timeofbirth = cellfun(@(x) str2double(x([19:22]-8)),t);
% double
previs = cellfun(@(x) str2double(x([238:239]-8)),t);

cig = zeros(4,length(previs));
% double
for i = 1:4
    cig(i,:) = cellfun(@(x) str2double(x([253:254]+(i-1)*2-8)),t);
end

clear('t');

%%
L = length(weight);
% prepare cleaned vectors with lengths of first and other pregnancies

% first pregnancies
% firstind = find(birthoder==1);
% % all other pregnancies
% otherind = find(birthoder>1);

% 9999 is used for "unknown weight"
unknownweight = find(weight==9999);
ind_w = setdiff(1:L,unknownweight);

% 9999 is used for "unknown weight"
unknownweight = find(timeofbirth==9999);
ind_tb = setdiff(1:L,unknownweight);


% 999 is used for "unknown weight"
unknownweight = find(motherweight==999);
ind_mw = setdiff(1:L,unknownweight);

% 999 is used for "unknown weight"
unknownweight = find(motherweightbirth==999);
ind_mwb = setdiff(1:L,unknownweight);

% 99 is used for "unknown number"
unknown = find(previs==99);
ind_previs = setdiff(1:L,unknown);


% 99 is used for "unknown number"
unknown = find(preglength==99);
ind_pl = setdiff(1:L,unknown);

% 9 is used for "unknown number"
unknown = find(birthoder==9);
ind_o = setdiff(1:L,unknown);


ind_cigarettes = [];
for i = 1:4
    % 99 is used for "unknown number"
    unknown = find(cig(i,:)==99);
    ind_cigarettes = union(ind_cigarettes,setdiff(1:L,unknown));
end

% ind = union(ind1,ind2);
% ind = union(ind,ind3);
% ind = union(ind,ind4);
% ind = union(ind,ind5);

%L = length(ind);

%% consider baby weight in kg
weight = weight/1000;

%%
ind = intersect(ind_w,ind_pl);
I = length(ind);
pl = preglength(ind);
w = weight(ind);
figure(1);clf; hold
set(gca,'fontsize',18);
scatter(pl+rand(I,1)-0.5,w+(rand(I,1)-0.5)/10); %,motherage)
set(gca,'xlim',[15,50],'ylim',[0,8]);
xlabel('pregnancy length [weeks]');
ylabel('birth weight [kg]');
title('Birth weight vs. Pregnancy length');
c = corrcoef(pl,w);
c = c(2,1);

xl = get(gca,'xlim');
yl = get(gca,'ylim');

xr = xl(2)-xl(1);
yr = yl(2)-yl(1);

text(min(xl)+0.05*xr,max(yl)-0.05*yr,['r = ' num2str(c)],'fontsize',18);

text(min(xl)+0.05*xr,max(yl)-0.15*yr,['R^2 = ' num2str(c^2)],'fontsize',18);
printfig('correlation_weight_preglength.png')
%%
[r,m,b] = regression(pl,w,'one');
line(xlim,xlim*m+b,'color','r','linewidth',2)
regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)];
legend('location','SE','data',regline)
legend('location','SE','data',regline)
printfig('correlation_weight_preglength_fit.png')
%
[r,m,b] = regression(w,pl,'one');
line(ylim*m+b,ylim,'color','m','linewidth',2)
regline2 = ['x = f(y) = ' num2str(m,3) 'y + ' num2str(b,3)];
legend('location','SE','data',regline,regline2)
printfig('correlation_weight_preglength_fit2.png')

if ffinal
    close all
end

%%
ind = intersect(ind_w,ind_o);
I = length(ind);
pl = birthoder(ind);
w = weight(ind);
figure(21);clf; hold
set(gca,'fontsize',18);
scatter(pl,w+(rand(I,1)-0.5)/10); %,motherage)
set(gca,'xlim',[0,9],'ylim',[0,8]);
xlabel('birthorder');
ylabel('birth weight [kg]');
title('Birth weight vs. Birth order');
c = corrcoef(pl,w);
c = c(2,1);

xl = get(gca,'xlim');
yl = get(gca,'ylim');

xr = xl(2)-xl(1);
yr = yl(2)-yl(1);

text(min(xl)+0.05*xr,max(yl)-0.05*yr,['r = ' num2str(c)],'fontsize',18);

text(min(xl)+0.05*xr,max(yl)-0.15*yr,['R^2 = ' num2str(c^2)],'fontsize',18);
printfig('correlation_weight_birthorder.png')
%%
[r,m,b] = regression(pl,w,'one');
line(xlim,xlim*m+b,'color','r','linewidth',2)
regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)];
legend('location','SE','data',regline)
legend('location','SE','data',regline)
printfig('correlation_weight_birthorder_fit.png')
%
[r,m,b] = regression(w,pl,'one');
line(ylim*m+b,ylim,'color','m','linewidth',2)
regline2 = ['x = f(y) = ' num2str(m,3) 'y + ' num2str(b,3)];
legend('location','SE','data',regline,regline2)
printfig('correlation_weight_birthorder_fit2.png')

if ffinal
    close all
end

%%
ind = ind_w;
I = length(ind);
w = weight(ind);
ma = motherage(ind);
figure(3);clf; hold
set(gca,'fontsize',18);
scatter(ma+rand(I,1)-0.5,w+(rand(I,1)-0.5)/10); %,motherage)
set(gca,'xlim',[10,52],'ylim',[0,8]);
ylabel('birth weight [kg]');
xlabel('age of mother [years]');

title('Birth weight vs. Age of mother');
c = corrcoef(ma,w);
c = c(2,1);

xl = get(gca,'xlim');
yl = get(gca,'ylim');

xr = xl(2)-xl(1);
yr = yl(2)-yl(1);

text(min(xl)+0.05*xr,max(yl)-0.05*yr,['r = ' num2str(c)],'fontsize',18);
text(min(xl)+0.05*xr,max(yl)-0.15*yr,['R^2 = ' num2str(c^2)],'fontsize',18);

printfig('correlation_weight_motherage.png')

%%
[r,m,b] = regression(ma,w,'one');
line(xlim,xlim*m+b,'color','r','linewidth',2)
regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)];
legend('location','SE','data',regline)
printfig('correlation_weight_motherage_fit.png')

[r,m,b] = regression(w,ma,'one');
line(ylim*m+b,ylim,'color','m','linewidth',2)
regline2 = ['x = f(y) = ' num2str(m,3) 'y + ' num2str(b,3)];
legend('location','SE','data',regline,regline2)
printfig('correlation_weight_motherage_fit2.png')

if ffinal
    close all
end

%%
ind = intersect(ind_w,ind_tb);
I = length(ind);
w = weight(ind);
tb = timeofbirth(ind);
figure(4);clf; hold
set(gca,'fontsize',18);
scatter(tb+rand(I,1)-0.5,w+(rand(I,1)-0.5)/10); %,motherage)
set(gca,'xlim',[0,2400],'ylim',[0,8]);
ylabel('birth weight [kg]');
xlabel('time of birth [HHMM]');
title('Birth weight vs. Time of birth');
c = corrcoef(tb,w);
c = c(2,1);

xl = get(gca,'xlim');
yl = get(gca,'ylim');

xr = xl(2)-xl(1);
yr = yl(2)-yl(1);

text(min(xl)+0.05*xr,max(yl)-0.05*yr,['r = ' num2str(c)],'fontsize',18);
text(min(xl)+0.05*xr,max(yl)-0.15*yr,['R^2 = ' num2str(c^2)],'fontsize',18);

printfig('correlation_weight_timeofbirth.png')

%%
[r,m,b] = regression(tb,w,'one');
line(xlim,xlim*m+b,'color','r','linewidth',2)
regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)];
legend('location','SE','data',regline)
printfig('correlation_weight_timeofbirth_fit.png')

[r,m,b] = regression(w,tb,'one');
line(ylim*m+b,ylim,'color','m','linewidth',2)
regline2 = ['x = f(y) = ' num2str(m,3) 'y + ' num2str(b,3)];
legend('location','SE','data',regline,regline2)
printfig('correlation_weight_timeofbirth_fit2.png')

if ffinal
    close all
end

%%
ind = intersect(ind_w,ind_previs);
I = length(ind);
w = weight(ind);

pv = previs(ind);
figure(5);clf; hold
set(gca,'fontsize',18);
scatter(pv+rand(I,1)-0.5,w+(rand(I,1)-0.5)/10); %,motherage)
set(gca,'xlim',[0,80],'ylim',[0,8]);
ylabel('birth weight [kg]');
xlabel('number of prenatal visits');

title('Birth weight vs. Prenatal visits');
c = corrcoef(pv,w);
c = c(2,1);

xl = get(gca,'xlim');
yl = get(gca,'ylim');

xr = xl(2)-xl(1);
yr = yl(2)-yl(1);

text(min(xl)+0.05*xr,max(yl)-0.05*yr,['r = ' num2str(c)],'fontsize',18);
text(min(xl)+0.05*xr,max(yl)-0.15*yr,['R^2 = ' num2str(c^2)],'fontsize',18);

printfig('correlation_weight_prenatvisits.png')

%%
[r,m,b] = regression(pv,w,'one');
line(xlim,xlim*m+b,'color','r','linewidth',2)
regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)];
legend('location','SE','data',regline)
printfig('correlation_weight_prenatalvisits_fit.png')

[r,m,b] = regression(w,pv,'one');
line(ylim*m+b,ylim,'color','m','linewidth',2)
regline2 = ['x = f(y) = ' num2str(m,3) 'y + ' num2str(b,3)];
legend('location','SE','data',regline,regline2)
printfig('correlation_weight_prenatalvisits_fit2.png')

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
    set(gca,'fontsize',18);
    scatter(ci+rand(1,I)-0.5,weight(ind)+rand(I,1)-0.5); %,motherage)
    set(gca,'xlim',[0,50],'ylim',[0,8]);
    ylabel('birth weight [kg]');
    xlabel(['number of daily cigarettes in trimester no.' num2str(i-1)])
    title('Birth weight vs. Number of cigarettes');
    c = corrcoef(ci,w);
    c = c(2,1);
    
    xl = get(gca,'xlim');
    yl = get(gca,'ylim');
    
    xr = xl(2)-xl(1);
    yr = yl(2)-yl(1);
    
    text(min(xl)+0.05*xr,max(yl)-0.05*yr,['r = ' num2str(c)],'fontsize',18);
    text(min(xl)+0.05*xr,max(yl)-0.15*yr,['R^2 = ' num2str(c^2)],'fontsize',18);
    
    printfig(['correlation_weight_cigarettesintrim' num2str(i-1) '.png'])
    
    
    [r,m,b] = regression(ci',w,'one');
    line(xlim,xlim*m+b,'color','r','linewidth',2)
    regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)];
    legend('location','SE','data',regline)
    printfig(['correlation_weight_cigarettesintrim' num2str(i-1) '_fit.png'])
    
    [r,m,b] = regression(w,ci','one');
    line(ylim*m+b,ylim,'color','m','linewidth',2)
    regline2 = ['x = f(y) = ' num2str(m,3) 'y + ' num2str(b,3)];
    legend('location','SE','data',regline,regline2)
    printfig(['correlation_weight_cigarettesintrim' num2str(i-1) '_fit2.png'])
    
    if ffinal
        close all
    end
    
    
end

%%
ind = intersect(ind_w,ind_mw);
I = length(ind);
w = weight(ind);
mw = motherweight(ind)/2;
figure(10);clf; hold
set(gca,'fontsize',18);
scatter(mw+(rand(I,1)-0.5)/10,w+(rand(I,1)-0.5)/10); %,motherage)
set(gca,'xlim',[40,200],'ylim',[0,8]);
ylabel('birth weight [kg]');
xlabel('mother weight before pregnancy [kg]');

title('Birth weight vs. Mother weight (before)');
c = corrcoef(mw,w);
c = c(2,1);

xl = get(gca,'xlim');
yl = get(gca,'ylim');

xr = xl(2)-xl(1);
yr = yl(2)-yl(1);

text(min(xl)+0.05*xr,max(yl)-0.05*yr,['r = ' num2str(c)],'fontsize',18);
text(min(xl)+0.05*xr,max(yl)-0.15*yr,['R^2 = ' num2str(c^2)],'fontsize',18);

printfig('correlation_weight_motherweightpre.png')

%%
[r,m,b] = regression(mw,w,'one');
line(xlim,xlim*m+b,'color','r','linewidth',2)
regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)];
legend('location','SE','data',regline)
printfig('correlation_weight_motherweitghpre_fit.png')

[r,m,b] = regression(w,mw,'one');
line(ylim*m+b,ylim,'color','m','linewidth',2)
regline2 = ['x = f(y) = ' num2str(m,3) 'y + ' num2str(b,3)];
legend('location','SE','data',regline,regline2)
printfig('correlation_weight_motherweightpre_fit2.png')

if ffinal
    close all
end


%%
ind = intersect(ind_w,ind_mwb);
I = length(ind);
w = weight(ind);
mw = motherweightbirth(ind)/2;
figure(11);clf; hold
set(gca,'fontsize',18);
scatter(mw+(rand(I,1)-0.5)/10,w+(rand(I,1)-0.5)/10); %,motherage)
set(gca,'xlim',[40,210],'ylim',[0,8]);
ylabel('birth weight [kg]');
xlabel('mother weight at birth [kg]');

title('Birth weight vs. Mother weight (birth)');
c = corrcoef(mw,w);
c = c(2,1);

xl = get(gca,'xlim');
yl = get(gca,'ylim');

xr = xl(2)-xl(1);
yr = yl(2)-yl(1);

text(min(xl)+0.05*xr,max(yl)-0.05*yr,['r = ' num2str(c)],'fontsize',18);
text(min(xl)+0.05*xr,max(yl)-0.15*yr,['R^2 = ' num2str(c^2)],'fontsize',18);

printfig('correlation_weight_motherweightbirth.png')

%%
[r,m,b] = regression(mw,w,'one');
line(xlim,xlim*m+b,'color','r','linewidth',2)
regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)];
legend('location','SE','data',regline)
printfig('correlation_weight_motherweitghtbirth_fit.png')

[r,m,b] = regression(w,mw,'one');
line(ylim*m+b,ylim,'color','m','linewidth',2)
regline2 = ['x = f(y) = ' num2str(m,3) 'y + ' num2str(b,3)];
legend('location','SE','data',regline,regline2)
printfig('correlation_weight_motherweightbirth_fit2.png')

if ffinal
    close all
end


%%
ind = intersect(ind_mw,ind_mwb);
ind = intersect(ind_w,ind);
I = length(ind);
w = weight(ind);

mw = motherweightgain(ind)/2;
figure(12);clf; hold
set(gca,'fontsize',18);
scatter(mw+(rand(I,1)-0.5)/10,w+(rand(I,1)-0.5)/10); %,motherage)
set(gca,'xlim',[-100, 105],'ylim',[0,8]);
ylabel('birth weight [kg]');
xlabel('mother weight gain during pregnancy [kg]');

title('Birth weight vs. Mother weight gain');
c = corrcoef(mw,w);
c = c(2,1);

xl = get(gca,'xlim');
yl = get(gca,'ylim');

xr = xl(2)-xl(1);
yr = yl(2)-yl(1);

text(min(xl)+0.05*xr,max(yl)-0.05*yr,['r = ' num2str(c)],'fontsize',18);
text(min(xl)+0.05*xr,max(yl)-0.15*yr,['R^2 = ' num2str(c^2)],'fontsize',18);

printfig('correlation_weight_motherweightgain.png')
%%
[r,m,b] = regression(mw,w,'one');
line(xlim,xlim*m+b,'color','r','linewidth',2)
regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)];
legend('location','SE','data',regline)
printfig('correlation_weight_motherweightgain_fit.png')

[r,m,b] = regression(w,mw,'one');
line(ylim*m+b,ylim,'color','m','linewidth',2)
regline2 = ['x = f(y) = ' num2str(m,3) 'y + ' num2str(b,3)];
legend('location','SE','data',regline,regline2)
printfig('correlation_weight_motherweightgain_fit2.png')

if ffinal
    close all
end


%%
w = weight(ind_w);
figure(12);clf; hold
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
w = weight(ind_w);
figure(12);clf; hold
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
printfig('weight_cdf.png')

if ffinal
    close all
end

%%
w = weight(ind_w);
figure(12);clf; hold
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
w = weight(ind_w);
figure(12);clf; hold
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
printfig('weight_cdf.png')

if ffinal
    close all
end
%%
% w = weight(ind_w);
% wu = unique(w);
%
% %
% [n,x] = hist(w,20); % wu);
%
% figure(13);clf; hold
% set(gca,'fontsize',18);
% bar(x,n/length(w));
%
% xx = min(w):0.001:max(w);
% y = normpdf(xx,mu,s);
% plot(xx,y, 'linewidth',2);
% %
