# -*- coding: utf-8 -*-
"""
KAP3_STETIGEVERTEILUNGEN
script for demonstrating the use of Python's built in capabilties for
working with probability distributions
examples for lecture notes Stochastik and Mathematik2, Kapitel 3 /
Stetige Verteilungen

documentation: https://docs.scipy.org/doc/scipy/reference/stats.html

copyright: Barbara Staehle, HTWG Konstanz
bstaehle@htwg-konstanz.de

v1.0: 05/2022

"""

import numpy as np
from scipy.stats import uniform, expon, norm

# not necessary helper function for displaying results a bit nicer
def myprint(x):
    x = str(np.round(x,3))
    return x

print('Beispiele aus Kaptitel 3 "Stetige Verteilungen"')


# Gleichverteilung
# Eve hat liest Meldungen in ihrer Twitter-Timeline.
# Die Zeit, die sie für das Lesen eines Beitrags braucht 
# wird durch die Zufallsvariable X ∼ U(5, 300) für die Lesezeit in Sekunden
# beschrieben

l = 5
s = 300-l
X = uniform(loc=l,scale=s)

print(' ')
print('Twitterlesezeiten von Eve (gleichverteilt)')
print(' ')


P_Xkleinergleich1 = X.cdf(60)
print('P_Xkleinergleich1 = ' + myprint(P_Xkleinergleich1))

# P_Xmehrals1 = X.sf(60)
P_Xmehrals1 = X.sf(60)
print('P_Xmehrals1 = ' + myprint(P_Xmehrals1))

E_X = X.mean()
print('E_X = ' + myprint(E_X))

std_X = X.std()
print('std_X = ' + myprint(std_X))

print(' ')


# Exponentialverteilung
# Ein Paar Laufschuhe hält im Mittel 18 Monate, falls diese täglich
# benutzt werden. Die Zeit, die Laufschuhe nutzbar sind, bevor sie
# kaputt gehen, ist also Y~expon(1/18)

lamb = 1/18
Y = expon(loc=0,scale=1/lamb)


print(' ')
print('Nutzungsdauer von Laufschuhen (exponentialverteilt)')
print(' ')


P_Ygroessergleich15 = Y.sf(15)
print('P_Ygroessergleich15 = ' + myprint(P_Ygroessergleich15))

P_Yzwischen12und15 = Y.cdf(15) - Y.cdf(12)
print('P_Yzwischen12und15 = ' + myprint(P_Yzwischen12und15))

Quant_Y75 = Y.ppf(0.75)
print('Quant_Y75 = ' + myprint(Quant_Y75))

E_Y = Y.mean()
print('E_Y = ' + myprint(E_Y))

std_Y = Y.std()
print('std_Y = ' + myprint(std_Y))

print(' ')



# Normalverteilung
# Die Größe eines zufällig ausgewählten deutschen Mannes ist eine
# Zufallsvariable X ∼ N(180.3, 7.17).

mu = 180.3
sig = 7.17
Z = norm(loc=180.3,scale=7.17)


print(' ')
print('Körpergröße von Männern (normalverteilt)')
print(' ')


P_Zkleinergleich175 = Z.cdf(175)
print('P_Zkleinergleich175 = ' + myprint(P_Zkleinergleich175))

P_Zgroessergleich180 = Z.sf(180)
print('P_Zgroessergleich180 = ' + myprint(P_Zgroessergleich180))

P_Zgroessergleich185 = Z.sf(185)
print('P_Zgroessergleich185 = ' + myprint(P_Zgroessergleich185))

Quant_Z95 = Z.ppf(0.95)
print('Quant_Z95 = ' + myprint(Quant_Z95))

Quant_Z90 = Z.ppf(0.90)
print('Quant_Z90 = ' + myprint(Quant_Z90))

E_Z = Z.mean()
print('E_Z = ' + myprint(E_Z))

std_Z = Z.std()
print('std_Z = ' + myprint(std_Z))

print(' ')

print('Bonus: In welchen Bereich fallen 90% der Körpergrößen aller Männer?')
print('[0.05-Quantil, 0.95-Quantil] = [' + myprint(Z.ppf(0.05)) + ', ' 
      + myprint(Z.ppf(0.95)) + ']')

print(' ')

