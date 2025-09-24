# -*- coding: utf-8 -*-
"""
4_intro_matplotlib.py

fourth Python file for quickstarting stochastic calculations for 
lectures "Stochastik" and "Mathematik 2" at HTWG Konstanz

v1.0: 03/2024
v1.1: 09/2025 minor edits and clarifications

@author: bstaehle copied and adapted from Julian Walter
Barbara Staehle, HTWG Konstanz
bstaehle@htwg-konstanz.de


"""

import matplotlib.pyplot as plt
import numpy as np

# %% Matplotlib
# Matplotlib was designed as a graph package for python to cloesly resemble MATLAB graphs 
# check out https://matplotlib.org/ to see what is possible!


# student ages 
print('')
ages = [20, 20, 24, 18, 20, 24, 20, 19, 19, 21, 24, 21, 25, 21, 19, 18, 20, 18, 20, 23, 21, 21, 21, 24]
print('Urliste with your ages: ', ages)

# %% have a look at the raw data
plt.figure()          # Create new figure

# plot the urliste with the index on the x-axis and Stars as markers 
plt.plot(ages,'*')

# try this one - it will connect the edges via a line (not reasonable in
# this case
# plot(ages)

plt.grid(True) 
plt.ylabel('Alter')
plt.ylabel('Antwort Nr.')
plt.title('Urliste - Alter der befragten Studierenden')
plt.show()


# %% there are various ways to plot histograms in Python
# I prefer this one
values, counts = np.unique(ages,return_counts=True)

plt.figure()          # Create new figure
plt.bar(values,counts)
plt.xlabel('Alter')
plt.ylabel('Absolute Häufigkeit')
plt.title('Histogramm des Alters der Studierenden')
plt.show()


