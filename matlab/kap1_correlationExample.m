% KAP1_CORRELATIONEXAMPLE
% script for analyzing correlations in
% 1) given data between size, income, speed,
% and bodyweight of a person
% 2) stork numbers and births per country
% source: http://www.econ.queensu.ca/files/other/storks.pdf
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

clear; clc; close all;

% flag for saving figures or not
% 0 = do not save, 1 = save figures
printt = 1;

% flag for calculating coefficient of correlation by hand or not
% 0 = do not calculate, 1 = calculate
calculate = 0;

% save figures to figure directory if existing, if not use same directory
% adapt to your local setup
ppath = '..\bilder\';
if ~exist(ppath,'dir')
    ppath = '';
end

% data given as a mixture of found somewhere on the Internet and slightly
% adapted for demonstration purposes
% size and weigth
dat = [163, 59;165, 62;166, 65;169, 69;170, 65;171, 69;171, 76;173, 73;174, 75;175, 73;177, 80;177, 71;179, 82;180, 84;185, 85];


% flag for showing or not showing secound regression line
% 0 = do not show, 1 = do show
alt = 1;

%%
% scatterplot: plot size on x, weight on y-axis
figure(1); clf; hold; box on; grid on; h = [];
% use nicer colors if available
try
    set(gca,'colororder',fhg(2),'fontsize',18);
catch
    set(gca,'colororder',jet(2),'fontsize',18);
end

h(1) = plot(dat(:,1),dat(:,2),'Marker','o','linestyle','none','linewidth',2);

% prepare and format axes and legend
xlabel('body height [cm]');
ylabel('body weight [kg]');
if printt
    saveas(gcf,[ppath 'sizeweight.png'],'png');
end

% compute empirical coefficient of correlation
r1 = corrcoef(dat(:,1),dat(:,2));
['r_{g,w} = ' num2str(r1(2,1))]

%%
% compute regression line
[r,m,b] = regression(dat(:,1),dat(:,2),'one');

% plot regression line
h(2) = line(xlim,xlim*m+b,'color','r','linewidth',2);

% prepare entry for legend and show legend
regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)]
legend(h,'data',regline,'location','NW')

if printt
    saveas(gcf,[ppath 'sizeweight_fit.png'],'png');
end

% if desired, compute regression line for size vs. weight and plot that
if alt
    % save limits of axes
    xx = xlim;
    % compute regression line
    [r,m,b] = regression(dat(:,2),dat(:,1),'one');
    % plot regression line
    h(3) = line(ylim*m+b,ylim,'color','m','linewidth',2)
    
    % prepare entry for legend and show legend
    regline2 = ['x = g(y) = ' num2str(m,3) 'y + ' num2str(b,3)];
    legend(h,'data',regline,regline2,'location','NW')
    
    % restore axes limit
    xlim(xx);
    
    title(['R^2 = ' num2str(r^2)])
    
    if printt
        saveas(gcf,[ppath 'sizeweight_fit2.png'],'png');
    end
    
end


%%
% for integration in script and for demonstration purposes: compute
% regression line step by step for first three values of
    % size
    x = dat(1:3,1)
    % weight
    y = dat(1:3,2)
    % income
    z = [3900; 2100; 3600]
    
    % mean values
    xbar = mean(x)
    ybar = mean(y)
    zbar = (mean(z))
    
    % helpers for standard deviation
    tempx = ((x - xbar).^2)'
    tempy = ((y - ybar).^2)'
    tempz = ((z - zbar).^2)'
    
    % helpers for standard deviation
    tempx = sum(tempx)/2
    tempy = sum(tempy)/2
    tempz = sum(tempz)/2
    
    % standard deviation
    sx = std(x)
    sy = std(y)
    sz = std(z)
    
    % helpers for coefficient of correlation
    tempxy = [(x - xbar) (y-ybar)]
    tempxy = prod(tempxy,2)
    tempxz = [(x - xbar) (z-zbar)]
    num2str(tempxz)
    tempxz = prod(tempxz,2)
    num2str(tempxz)
    sum(tempxz)/2
    
    % coefficient of correlation
    sxy = cov(x,y)
    sxz = cov(x,z)
    num2str(sxz)
    rxy = corrcoef(x,y)

%%
% scatterplot: plot size on x, weight on y-axis
% include regression line with fit for three values only (does not really
% fit)
figure(2); clf; hold; box on; grid on; h = [];
% use nicer colors if available
try
    set(gca,'colororder',fhg(2),'fontsize',18);
catch
    set(gca,'colororder',jet(2),'fontsize',18);
end

% plot all points 
h(1) = plot(dat(:,1),dat(:,2),'Marker','o','linestyle','none','linewidth',2);
xlabel('body height [cm]');
ylabel('body weight [kg]');

% compute coefficient of correlation for first three values only
r1 = rxy;
['r_{x,y} = ' num2str(r1(2,1))]

% dito regression line
[r,m,b] = regression(x,y,'one');
h(2) = line(xlim,xlim*m+b,'color','r','linewidth',2);
regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)]
legend(h,'data',regline,'location','NW')

if printt
    saveas(gcf,[ppath 'sizeweight_fit_3only.png'],'png');
end

% calculate mistake made
k2 = 0.982 * 3/1.528
d2 = 62 - 1.928 *(164+2/3)
num2str([x*k2+d2]')
num2str([x*k2+d2]'-y')

num2str([dat(4:5,1)*k2+d2]')
num2str([dat(4:5,1)*k2+d2]'-dat(4:5,2)')

%%
% data given as a mixture of found somewhere on the Internet and slightly
% adapted for demonstration purposes
% size and income
dat2 = [163, 3900;165, 2100;166, 3600;169, 2300; 170, 4000;171, 5600;171, 2100;173, 5100;174, 3400;175, 1800; 177, 2100;177, 2600;179, 4600;180, 3600;185, 2700];

% do scatter plot and regression lines 
%
figure(3); clf; hold; box on; grid on; h = [];
% use nicer colors if available
try
    set(gca,'colororder',fhg(2),'fontsize',18);
catch
    set(gca,'colororder',jet(2),'fontsize',18);
end

% scatterplot: plot all data
h(1) = plot(dat2(:,1),dat2(:,2),'Marker','o','linestyle','none','linewidth',2);
xlabel('body height [cm]');
ylabel('income [€]');

if printt
    saveas(gcf,[ppath 'sizeincome.png'],'png');
end

% compute coefficient of correlation
r2 = corrcoef(dat2(:,1),dat2(:,2))
['r_{g,e} = ' num2str(r2(2,1))]

% compute and plot regression line
[r,m,b] = regression(dat2(:,1),dat2(:,2),'one');
h(2) = line(xlim,xlim*m+b,'color','r','linewidth',2)
regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)];
legend('data',regline)
legend(h,'data',regline,'location','NW')

if printt
    saveas(gcf,[ppath 'sizeincome_fit.png'],'png');
end

% if desired, compute regression line for income vs. height and plot that
if alt
    [r,m,b] = regression(dat2(:,2),dat2(:,1),'one');
    h(3) = line(ylim*m+b,ylim,'color','m','linewidth',2)
    regline2 = ['x = g(y) = ' num2str(m,3) 'y + ' num2str(b,3)];
    legend(h,'data',regline,regline2, 'location','NW')
    
    title(['R^2 = ' num2str(r^2)])
    
    if printt
        saveas(gcf,[ppath 'sizeincome_fit2.png'],'png');
    end
    
end

%%
% data given as a mixture of found somewhere on the Internet and slightly
% adapted for demonstration purposes
% size and best time for 10k
dat3 = [55, 59;52, 62;45, 65;40, 69;40, 65;56, 69;51, 76;45, 73;35, 75;52, 73;50, 80;40, 71;42, 82;36, 84;38, 81];

figure(4); clf; hold; box on; grid on; h = [];
% use nicer colors if available
try
    set(gca,'colororder',fhg(2),'fontsize',18);
catch
    set(gca,'colororder',jet(2),'fontsize',18);
end

% scatterplot: plot all data
h(1) = plot(dat(:,1),dat3(:,1),'Marker','o','linestyle','none','linewidth',2);
xlabel('body height [cm]');
ylabel('10km best time [min]');
if printt
    saveas(gcf,[ppath 'sizetime.png'],'png');
end

% compute coefficient of correlation
r4 = corrcoef(dat3(:,1),dat(:,1))
['r_{g,b} = ' num2str(r4(2,1))]

% compute and plot regression line
[r,m,b] = regression(dat(:,1),dat3(:,1),'one');
line(xlim,xlim*m+b,'color','r','linewidth',2)
regline = ['y = f(x) = ' num2str(m,3) 'x + ' num2str(b,3)];
legend('data',regline)
legend(h, 'data',regline, 'location','NW')

if printt
    saveas(gcf,[ppath 'sizetime_fit.png'],'png');
end

% if desired, compute regression line for best time vs. height and plot that
if alt
    title(['R^2 = ' num2str(r^2)])
    [r,m,b] = regression(dat3(:,1),dat(:,1),'one');
    line(ylim*m+b,ylim,'color','m','linewidth',2)
    regline2 = ['x = g(y) = ' num2str(m,3) 'y + ' num2str(b,3)];
    legend(h,'data',regline,regline2, 'location','NW')
    
    if printt
        saveas(gcf,[ppath 'sizetime_fit2.png'],'png');
    end
    
end


%%
% Example 2: data taken from http://www.econ.queensu.ca/files/other/storks.pdf
% Country Area (km^2) Storks (pairs) Humans (10^6) Birth rate (10^3/yr)

dat4 = [28750 100 3.2 83
    83860 300 7.6 87
    30520 1 9.9 118
    111000 5000 9.0 117
    43100 9 5.1 59
    544000 140 56 774
    357000 3300 78 901
    132000 2500 10 106
    41900 4 15 188
    93000 5000 11 124
    301280 5 57 551
    312680 30000 38 610
    92390 1500 10 120
    237500 5000 23 367
    504750 8000 39 439
    41290 150 6.7 82
    779450 25000 56 1576];

% kick out birth rate given in thousands
dat4(:,4) = dat4(:,4)*10^3;

%%
% scatterplot born babies vs. storks
figure(4); clf; hold; box on; grid on;
% use nicer colors if available
try
    set(gca,'colororder',fhg(2),'fontsize',18);
catch
    set(gca,'colororder',jet(2),'fontsize',18);
end

% scatterplot
plot(dat4(:,2),dat4(:,4),'Marker','o','linestyle','none','linewidth',2);
xlabel('storks [pairs]');
ylabel('born babies [per year]');

% compute and display coefficient of correlation
c = corrcoef(dat4(:,2),dat4(:,4));
c = c(2,1);
xl = get(gca,'xlim');
yl = get(gca,'ylim');
xr = xl(2)-xl(1);
yr = yl(2)-yl(1);
text(min(xl)+0.05*xr,max(yl)-0.05*yr,['r = ' num2str(c)],'fontsize',18);

if printt
    saveas(gcf,[ppath 'storksbabies.png'],'png');
end

%% 
% scatterplot size of country vs. storks
figure(5); clf; hold; box on; grid on;
% use nicer colors if available
try
    set(gca,'colororder',fhg(2),'fontsize',18);
catch
    set(gca,'colororder',jet(2),'fontsize',18);
end

% scatterplot
plot(dat4(:,1),dat4(:,2),'Marker','o','linestyle','none','linewidth',2);
ylabel('storks [pairs]');
xlabel('size of country [km^2]');

% compute and display coefficient of correlation
c = corrcoef(dat4(:,2),dat4(:,1));
c = c(2,1);
xl = get(gca,'xlim');
yl = get(gca,'ylim');
xr = xl(2)-xl(1);
yr = yl(2)-yl(1);
text(min(xl)+0.05*xr,max(yl)-0.05*yr,['r = ' num2str(c)],'fontsize',18);

if printt
    saveas(gcf,[ppath 'countrystorks.png'],'png');
end

%%
% scatterplot size of country vs. babies
figure(6); clf; hold; grid on; box on;
try
    set(gca,'colororder',fhg(2),'fontsize',18);
catch
    set(gca,'colororder',jet(2),'fontsize',18);
end

% scatterplot
plot(dat4(:,1),dat4(:,4),'Marker','o','linestyle','none','linewidth',2);
ylabel('born babies [per year]');
xlabel('size of country [km^2]');

% compute and display coefficient of correlation
c = corrcoef(dat4(:,1),dat4(:,4));
c = c(2,1);
xl = get(gca,'xlim');
yl = get(gca,'ylim');
xr = xl(2)-xl(1);
yr = yl(2)-yl(1);
text(min(xl)+0.05*xr,max(yl)-0.05*yr,['r = ' num2str(c)],'fontsize',18);

if printt
    saveas(gcf,[ppath 'countrybabies.png'],'png');
end

%%
% Example 3: not further implemented
% Anscome-Quartett (https://de.wikipedia.org/wiki/Anscombe-Quartett)
A = [
    10.0 	8.04 	10.0 	9.14 	10.0 	7.46 	8.0 	6.58
    8.0 	6.95 	8.0 	8.14 	8.0 	6.77 	8.0 	5.76
    13.0 	7.58 	13.0 	8.74 	13.0 	12.74 	8.0 	7.71
    9.0 	8.81 	9.0 	8.77 	9.0 	7.11 	8.0 	8.84
    11.0 	8.33 	11.0 	9.26 	11.0 	7.81 	8.0 	8.47
    14.0 	9.96 	14.0 	8.10 	14.0 	8.84 	8.0 	7.04
    6.0 	7.24 	6.0 	6.13 	6.0 	6.08 	8.0 	5.25
    4.0 	4.26 	4.0 	3.10 	4.0 	5.39 	19.0 	12.50
    12.0 	10.84 	12.0 	9.13 	12.0 	8.15 	8.0 	5.56
    7.0 	4.82 	7.0 	7.26 	7.0 	6.42 	8.0 	7.91
    5.0 	5.68 	5.0 	4.74 	5.0 	5.73 	8.0 	6.89];

for i = 1:2:7
    [r(i),m(i),b(i)] = regression(A(:,i),A(:,i+1),'one')
    R(i) = r(i)^2
end

