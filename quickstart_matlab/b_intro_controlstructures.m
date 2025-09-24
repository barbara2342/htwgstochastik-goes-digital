%b_intro_controlstructures.m
%
% second MATLAB file for quickstarting stochastic calculations for 
% lectures "Stochastik" and "Mathematik 2" at HTWG Konstanz
%
% copyright: Barbara Staehle, HTWG Konstanz
% bstaehle@htwg-konstanz.de
%
% v1.0: 03/2024
% copied and adapted intro_controlstructures.py
% (original author: Julian Walter)



%% Indentations
% Instead of brackets to define the scope of functions or statements (if, for, while) Matlab uses "end"
% indentations (Einrückungen) can help to structure the code (and are
% automatically made via strg-a and strg-i but are not necessary (in
% contrast to Pyhton

age = 20

% If
if age < 18
    disp("Underage")
else
    disp("Adult")
end

%% For and while
favorites = ["Mathe 2", "Medizin", "Programmiertechnik 1"];

% For
disp(' ')
disp('my favorite subjects:')
for fav = favorites
    disp(fav)
end

% While
disp(' ')
i = 1;
while i < 6
    disp(i)
    i = i+1;
end