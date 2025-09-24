# -*- coding: utf-8 -*-
"""
2_intro_controlstructures.py

second Python file for quickstarting stochastic calculations for 
lectures "Stochastik" and "Mathematik 2" at HTWG Konstanz

v1.0: 03/2024
v1.1: 09/2025 minor edits and clarifications

@author: bstaehle copied and adapted from Julian Walter
Barbara Staehle, HTWG Konstanz
bstaehle@htwg-konstanz.de

"""

# %% Indentations
# Instead of brackets to define the scope of functions or statements 
# (if, for, while) python uses indentations (Einrückungen).

# Statements  
# The lack of brackets also applies for statement conditions. 
# Instead, you use ":" to declare the end of your condition 

age = 20

# If
if age < 18:
    print("Underage")
else:
    print("Adult")
    
    
# %% For and while
favorites = ["Mathe 2", "Medizin", "Programmiertechnik 1"]

# For
print(' ')
print('my favorite subjects:')
for fav in favorites:
    print(fav)
    
# While
print(' ')
i = 1
while i < 6:
    print(i)
    i += 1