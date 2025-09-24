# -*- coding: utf-8 -*-
"""
1_intro_basics.py

first Python file for quickstarting stochastic calculations for 
lectures "Stochastik" and "Mathematik 2" at HTWG Konstanz

this is a block comment

v1.0: 03/2024
v1.1: 09/2025 minor edits and clarifications

@author: bstaehle copied and adapted from Julian Walter
Barbara Staehle, HTWG Konstanz
bstaehle@htwg-konstanz.de

"""

# this is a normal comment

# %% this starts a new cell 
# 
# ATTENTION: cell mode does not work in all IDEs. 
# At least it works in Spyder, in PyCharm and in VS Code
#
# using the script in cell mode does allow to not execute everything, but
# just the stuff in one cell (i.e. from one # %% just above the next # %%

# %% Variables
# Variables don't have a command to declare themVariables don't need a type when declaring them, 
# and you can reassign different types to the same variable.  

# Output
# In python to display data as a text you use print(). 
# Print always parses the values to a string representation if possible. 
# 

# Variables
age = 25
shoe_size = 42.5
eye_color = "braun"
side_job = True

# Print
print(age)
# Comma separated (concatenates  the string representation of the data, adding a space between each value)
print("age", age)

# Combined data. NOTE if you want to concatenate using + make sure that both values are of type string
print("eye color: " + eye_color)

# Formatted string (add an f before the string and add variables using {} )
print(f"side_job: {eye_color}")

print('\n') # prints an empy line


# %% Data types
# The most common types are int (whole number), float (decimal number), 
# string (text), boolean (true/false) and lists (array-like structures) 
# For a list of all built-in data types see: Python Data Types 

# Types
print(age, type(age))
print(shoe_size, type(shoe_size))
print(eye_color, type(eye_color))
print(side_job, type(side_job))
print('\n') # prints an empy line

# %% 

# Lists
#Lists have a wide range of operations see List operations
#The most notable difference to common temp_listays is the option to access parts of a list with slices 
#Lists are zero indexed. 

print('list examples')
list_example = [0,1,2,3,4,5,6,7,8,9]
print('entire list: ' , list_example)
print('first and last element removed: ', list_example[1:-1])   # Removes the first and last element[0, 9]
print('first three elements only: ', list_example[:3])   # Selects the first 3 values
print('all elemnts except first three: ', list_example[3:])   # Selects all values except the first 3 values
print('select values on index 0 and 1:', list_example[0:2])   # Selects the values on index 0 and 1
print('select values on index 6:', list_example[5:6])   # Selects the value on index 6

print('entire list, but 3 replaced with 4:')
# Use for to iterate over a list using variable x (for x in list) and if x==3 replace with 4 else keep x (4 if x==3 else x)
list_example = [4 if x==3 else x for x in list_example]
print(list_example)

