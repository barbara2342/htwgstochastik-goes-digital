# -*- coding: utf-8 -*-
"""
5_intro_csvread.py

fifth Python file for quickstarting stochastic calculations for 
lectures "Stochastik" and "Mathematik 2" at HTWG Konstanz

ATTENTION: sample file umfrage.csv needs to be located in the same directory!

v1.0: 03/2024
v1.1: 09/2025 minor edits and clarifications

@author: bstaehle copied and adapted from Julian Walter
Barbara Staehle, HTWG Konstanz
bstaehle@htwg-konstanz.de


"""

## % csv data 
# This code reads a csv file line by line 
# and you have to parse the row data to the format you want
# All data read is per default a string

import csv
import numpy as np
import re

age= []
shoe_size= []
side_job= []
eye_color= []

with open('umfrage.csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=';')
    line_count = 0
    for row in csv_reader:
        if line_count == 0:
            print(f'Column names are {" ".join(row)}')
            print(' ')
            line_count += 1
        elif line_count == 1: 
            line_count += 1 # no content here
        else:
            age.append(row[0])
            shoe_size.append(row[1])
            side_job.append(row[2])
            eye_color.append(row[3])
            line_count += 1
    print(f'Processed {line_count} lines.')
    print(' ')

# %%

# better coding style would be to use for loop and generic variable names
# not copy and paste as shown below!

print('Alter:')
print(age)
print(' ')

print('Schuhgroesse:')
print(shoe_size)
print(' ')

print('Nebenjob:')
print(side_job)
print(' ')

print('Augenfarbe:')
print(eye_color)

# %%

# convert numbers to floats
age = [float(i) for i in age]

#  we need to replace 47,5 (Excel) by 47.5 (Python) before converting it to a number
pattern = re.compile(r',')
shoe_size = [pattern.sub('.', sub) for sub in shoe_size]
shoe_size = [float(i) for i in shoe_size]

print(' ')
print(f'Mean age : {np.mean(age)}')
print(f'Median age : {np.median(age)}')

print(' ')
print(f'Mean shoe_size : {np.mean(shoe_size)}')
print(f'Median shoe_size : {np.median(shoe_size)}')

C = np.corrcoef(age,shoe_size)

print(' ')
print(f'Coefficient of correlation between shoe size and age: {C[0,1]}')

print(' ')
print('Output of corrcoef is the following matrix:')
print(C)