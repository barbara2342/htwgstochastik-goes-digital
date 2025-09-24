# -*- coding: utf-8 -*-
"""

3_intro_numpyStat.py

third Python file for quickstarting stochastic calculations for 
lectures "Stochastik" and "Mathematik 2" at HTWG Konstanz

v1.0: 03/2024
v1.1: 09/2025 minor edits and clarifications

@author: bstaehle copied and adapted from Julian Walter
Barbara Staehle, HTWG Konstanz
bstaehle@htwg-konstanz.de

"""

# %% Packages
# You dont have to reinvent the wheel in most cases. 
# Python features a big library of packages you can use in your code to use predefined functions. 
# Per default the imports should be at the start of the file but for structuring reasons they are added later here. 
#
# If you use a default python installation  without wrappers (like spyder or anaconda)
# you can use the default package installer pip to add packages to your python environment 
# using "pip install package_name" in your command line. After that, you can use them in your code by importing them. 
# The most commonly used packages in this course will be numpy (math functions), matplotlib (showing graphs) and 
# statistics (statistics functions)

# Example that you can use numpy functions instead of calculating it yourself
import numpy as np
# this creates the numbers 0,1,2,3,4,5
numbers = range(6)

# np.array is a data structure nicer for printing
numbers = np.array(numbers)

print('numbers:', numbers)

median = sum(numbers)/len(numbers)
print("Median of numbers calculated by hand", median)

median = np.median(numbers)
print("Median of numbers calculated by numpy", median)


# %% example with most important stochastic functions

import statistics as stat

# your ages 
print('')
ages = [20, 20, 24, 18, 20, 24, 20, 19, 19, 21, 24, 21, 25, 21, 19, 18, 20, 18, 20, 23, 21, 21, 21, 24]
print('Urliste with your ages: ', ages)

# To get the unique values of a list, you can convert it to a set. To further use the set, you can convert it back to a list
unique_vals = list(set(ages))
print(f'Unique values: {unique_vals}')

ages_length = len(ages)
print(f'Length of list: {ages_length}')

min_val = min(ages)
print(f'Min value of list: {min_val}')

max_val = max(ages)
print(f'Max value of list: {max_val}')

sorted_list = sorted(ages)
print(f'List sorted by the standard sorting for the type of elements: {sorted_list}')

list_sorted_low = sorted(ages)[:3]
print(f'Three smallest values: {list_sorted_low}')

list_sorted_high = sorted(ages, reverse=True)[:3]
print(f'Three biggest values: {list_sorted_high}')

avg_val = np.average(ages)
print(f'Average value of list: {avg_val}')

median_val = np.median(ages)
print(f'Median value of list: {median_val}')

D = stat.mode(ages)
print(f'Most frequent value in list (using mode): {D}')

# To show all most common values (in case it is tied between multiple) use multimode
D = stat.multimode(ages)
print(f'Most frequent values in list (using multimode): {D}')

std_dev = np.std(ages)
print(f'Standard deviation: {std_dev}')

variance = stat.variance(ages)
print(f'Variance: {variance}')

print('')
temp = [1, 2, 3, 4, 5]
print('another sample list:', temp)
csum = np.cumsum(temp)
print(f'List where each value is the sum of the previous values: {csum}')
