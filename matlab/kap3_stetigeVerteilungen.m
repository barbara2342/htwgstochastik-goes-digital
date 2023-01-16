% KAP3_STETIGEVERTEILUNGEN2122
% script for demonstrating the use of MATLAB's built in capabilties for
% working with probability distributions
% examples for lecture notes Stochastik and Mathematik2, Kapitel 3 /
% Stetige Verteilungen
%
% copyright: Barbara Staehle, HTWG Konstanz
% bstaehle@htwg-konstanz.de
%
% v1.0: 01/2023


disp('Beispiele aus Kaptitel 3 "Stetige Verteilungen"')


% Gleichverteilung
% Eve hat liest Meldungen in ihrer Twitter-Timeline.
% Die Zeit, die sie für das Lesen eines Beitrags braucht 
% wird durch die Zufallsvariable X ∼ U(5, 300) für die Lesezeit in Sekunden
% beschrieben

X = makedist('Uniform','lower',5,'upper',300);

disp(' ');
disp('Twitterlesezeiten von Eve (gleichverteilt)');
disp(' ');


P_Xkleinergleich1 = X.cdf(60)
P_Xmehrals1 = 1 - X.cdf(60)
E_X = X.mean()
std_X = X.std()

disp(' ')

%%

% Exponentialverteilung
% Ein Paar Laufschuhe hält im Mittel 18 Monate, falls diese täglich
% benutzt werden. Die Zeit, die Laufschuhe nutzbar sind, bevor sie
% kaputt gehen, ist also Y~expon(1/18)

Y = makedist('Exponential','mu',18);

disp(' ');
disp('Nutzungsdauer von Laufschuhen (exponentialverteilt)');
disp(' ');

P_Ygroessergleich15 = 1 - Y.cdf(15)
P_Yzwischen12und15 = Y.cdf(15) - Y.cdf(12)
Quant_Y75 = Y.icdf(0.75)
E_Y = Y.mean()
std_Y = Y.std()

disp(' ')

%%

% Normalverteilung
% Die Größe eines zufällig ausgewählten deutschen Mannes ist eine
% Zufallsvariable X ∼ N(180.3, 7.17).

Z = makedist('Normal','mu',180.3,'sigma',7.17);

disp(' ');
disp('Körpergröße von Männern (normalverteilt)');
disp(' ');


P_Zkleinergleich175 = Z.cdf(175)
P_Zgroessergleich180 = 1 - Z.cdf(180)
P_Zgroessergleich185 = 1 - Z.cdf(185)
Quant_Z95 = Z.icdf(0.95)
Quant_Z90 = Z.icdf(0.90)
E_Z = Z.mean()
std_Z = Z.std()

disp(' ')

disp('Bonus: In welchen Bereich fallen 90% der Körpergrößen aller Männer?');
disp(['[0.05-Quantil, 0.95-Quantil] = [' num2str(Z.icdf(0.05)) ', ' num2str(Z.icdf(0.95)) ']']);

disp(' ')

