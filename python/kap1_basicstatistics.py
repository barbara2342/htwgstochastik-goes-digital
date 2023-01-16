# -*- coding: utf-8 -*-
"""
Created on Mon Sep 26 09:08:37 2022

@author: bstaehle
"""

import statistics
import scipy.stats as stats
import numpy as np

data = [5,0,295];

m = np.mean(data)

n = np.median(data)

b = stats.describe(data)

xx = [1, 2, 3, 3, 4, 6, 6, 7, 8, 9, 10, 10, 10]

ot = [-50, -28.2, -17.7, -17.5, -2.8, -2.4, -0.6, 1.9, 6.1, 8.1, 8.7, 13.3, 14.6, 16.8, 18.6, 22.9, 23.4, 24.6, 28.5, 30.1, 30.8, 32.2, 32.3, 33, 34.8, 35.9, 36, 36.5, 39.5, 41.7, 43.8, 45.1, 46.8, 54.4, 55.2, 71.2, 71.6, 74.8, 109.6, 120, 135.3, 334.2]
