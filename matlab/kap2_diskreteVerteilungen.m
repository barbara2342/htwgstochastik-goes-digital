% KAP2_DISKRETEVERTEILUNGEN
% script for demonstrating the use of MATLAB's built in capabilties for
% working with probability distributions
% examples for lecture notes Stochastik and Mathematik2, Kapitel 2 /
% Diskrete Verteilungen
%
% copyright: Barbara Staehle, HTWG Konstanz
% bstaehle@htwg-konstanz.de
%
% v1.0: 05/2022

clear; clc; close all;

%% geometrische Verteilung
% Britta, die bessere Snowboarderin
% Britta absolviert mit p = 0.4 eine erfolgreiche Abfahrt. Die Anzahl der
% Abfahrten X die Britta bis zum 1. Erfolg braucht ist also X ∼ geom(0.4).

% Matlab supported keine Verteilungsobjekte für geom, verwende daher
% direkte Funtionsaufrufe
p = 0.4; 

disp('Beispiel aus Kaptitel 2 "Diskrete Verteilungen"')

disp(' ');
disp('Britta, die bessere Snowboarderin (geometrisch)');
disp(' ');

% Achtung: für Matlab ist die Anzahl der Fehlversuche vor dem ersten
% Versuch geometrisch verteilt!! 
P_Xgleich2 = geopdf(1,p)
P_Xkleinergleich4 = geocdf(3,p)
P_Xgroesser4 = 1 - P_Xkleinergleich4
[E_X, Var_X] = geostat(p)

disp(' ');

%% Binomial-Verteilung
% Britta, die schlechtere Schneeballwerferin
% Britta wirft n = 5 Schneebälle auf Chad, aber trifft nur mit p = 0.25. Die
% Anzahl der Treffer in den 5 Würfen ist also Y ∼ Bin(5, 0.25).

disp('Britta, die schlechtere Schneeballwerferin (Binomial)');
disp(' ');

Y = makedist('Binomial','n',5,'p',0.25)

P_Ygleich2 = Y.pdf(2)
P_Ygleich2oder3 = sum(Y.pdf(2:3))
P_Ygleich0 = Y.pdf(0)
P_Ykleinergleich3 = Y.cdf(3)
E_Y = Y.mean
Var_Y = Y.var

disp(' ');

%% Poisson-Verteilung
% Das Kino von Statsville erwartet von Ihnen, dass Sie folgende Fragen
% beantworten (Für die Popcornmaschine, die ca. 3 mal pro Woche
% ausfällt): Vorüberlegung: Z = Anzahl der Ausfälle pro Woche mit 
% Z ∼ Po(3)

disp('Die unzuverlässige Popcornmaschine (Poisson)');
disp(' ');

Z = makedist('Poisson',3)

P_Zgleich0 = Z.pdf(0)
P_Zgeich2 = Z.pdf(2)
P_Zkleinergleich2 = Z.cdf(2)
E_Z = Z.mean
Var_Z = Z.var

disp(' ');

%% MSI-only: hypergeometrische Verteilung
% Betrachten Sie wieder die Campusparty, für das ein 10-köpfiges
% Orga-Team aus einer Gruppe von 70 Studierenden bestimmt werden soll,
% von denen 45 aus der Fakultät IN kommen. Die Anzahl X der
% IN-Studierenden im Organisationsteam sei die ZV I ∼ H(10, 45, 70).

% Matlab supported keine Verteilungsobjekte für geom, verwende daher
% direkte Funtionsaufrufe. Syntax: 
% Y = hygepdf(X,M,K,N) computes the hypergeometric pdf at each of the values in X,
% using the corresponding size of the population, M, 
% number of items with the desired characteristic in the population, K, 
% and number of samples drawn, N. 

disp('MSI only: Die Campusparty (hypergeometrisch)');
disp(' ');

M = 70;
K = 45;
N = 10;

P_Igleich10 = hygepdf(10,M,K,N)
P_Igleich9oder10 = sum(hygepdf(9:10,M,K,N))
P_Igleich7 = hygepdf(7,M,K,N)
[E_I, Var_I] = hygestat(M,K,N)



