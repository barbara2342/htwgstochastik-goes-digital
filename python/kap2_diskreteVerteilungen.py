# -*- coding: utf-8 -*-
"""
KAP2_DISKRETEVERTEILUNGEN
script for demonstrating the use of Python's built in capabilties for
working with probability distributions
examples for lecture notes Stochastik and Mathematik2, Kapitel 2 /
Diskrete Verteilungen

documentation: https://docs.scipy.org/doc/scipy/reference/stats.html

copyright: Barbara Staehle, HTWG Konstanz
bstaehle@htwg-konstanz.de

v1.0: 05/2022

"""

import numpy as np
from scipy.stats import binom, geom, poisson, hypergeom

# not necessary helper function for displaying results a bit nicer
def myprint(x):
    x = str(np.round(x,4))
    return x

print('Beispiele aus Kapitel 2 "Diskrete Verteilungen"')


# geometrische Verteilung
# Britta, die bessere Snowboarderin
# Britta absolviert mit p = 0.4 eine erfolgreiche Abfahrt. Die Anzahl der
# Abfahrten X die Britta bis zum 1. Erfolg braucht ist also X ∼ geom(0.4).

X = geom(0.4)

print(' ')
print('Britta, die bessere Snowboarderin (geometrisch)')
print(' ')


P_Xgleich2 = X.pmf(2)
print('P_Xgleich2 = ' + myprint(P_Xgleich2))

P_Xkleinergleich4 = X.cdf(4)
print('P_Xkleinergleich4 = ' + myprint(P_Xkleinergleich4))

P_Xgroesser4 = 1 - P_Xkleinergleich4
print('P_Xgroesser4 = ' + myprint(P_Xgroesser4))

E_X = X.mean()
print('E_X = ' + myprint(E_X))

Var_X = X.var()
print('Var_X = ' + myprint(Var_X))

print(' ')


# Binomial-Verteilung
# Britta, die schlechtere Schneeballwerferin
# Britta wirft n = 5 Schneebälle auf Chad, aber trifft nur mit p = 0.25. Die
# Anzahl der Treffer in den 5 Würfen ist also Y ∼ Bin(5, 0.25).

print('Britta, die schlechtere Schneeballwerferin (Binomial)');
print(' ');

Y = binom(5,0.25)

P_Ygleich2 = Y.pmf(2)
print('P_Ygleich2 = ' + myprint(P_Ygleich2))

# P_Ygleich2oder3 = Y.pmf(2) + Y.pmf(3)
P_Ygleich2oder3 = sum(Y.pmf(list(range(2, 4))))
print('P_Ygleich2oder3 = ' + myprint(P_Ygleich2oder3))

P_Ygleich0 = Y.pmf(0)
print('P_Ygleich0 = ' + myprint(P_Ygleich0))

P_Ykleinergleich3 = Y.cdf(3)
print('P_Ykleinergleich3 = ' + myprint(P_Ykleinergleich3))

E_Y = Y.mean()
print('E_Y = ' + myprint(E_Y))

Var_Y = Y.var()
print('Var_Y = ' + myprint(Var_Y))

print(' ')


# Poisson-Verteilung
# Das Kino von Statsville erwartet von Ihnen, dass Sie folgende Fragen
# beantworten (Für die Popcornmaschine, die ca. 3 mal pro Woche
# ausfällt): Vorüberlegung: Z = Anzahl der Ausfälle pro Woche mit 
# Z ∼ Po(3)

print('Die unzuverlässige Popcornmaschine (Poisson)');
print(' ');

Z = poisson(3)

P_Zgleich0 = Z.pmf(0)
print('P_Zgleich0 = ' + myprint(P_Zgleich0))

P_Zgleich2 = Z.pmf(2)
print('P_Zgleich2 = ' + myprint(P_Zgleich2))

P_Zkleinergleich2 = Z.cdf(2)
print('P_Zkleinergleich2 = ' + myprint(P_Zkleinergleich2))

E_Z = Z.mean()
print('E_Z = ' + myprint(E_Z))

Var_Z = Z.var()
print('Var_Z = ' + myprint(Var_Z))

print(' ')

# MSI-only: hypergeometrische Verteilung
# Betrachten Sie wieder die Campusparty, für das ein 10-köpfiges
# Orga-Team aus einer Gruppe von 70 Studierenden bestimmt werden soll,
# von denen 45 aus der Fakultät IN kommen. Die Anzahl X der
# IN-Studierenden im Organisationsteam sei die ZV I ∼ H(10, 45, 70).

# from the scipy.stats.hypergeom doku:
# The hypergeometric distribution models drawing objects from a bin. 
# M is the total number of objects, n is total number of Type I objects. 
# The random variate represents the number of Type I objects in N drawn without replacement from the total population.

# rv = hypergeom(M, n, N)

print('MSI only: Die Campusparty (hypergeometrisch)')
print(' ')

I = hypergeom(70,45,10)


P_Igleich10 = I.pmf(10)
print('P_Igleich10 = ' + myprint(P_Igleich10))

P_Igleich9oder10 = sum(I.pmf(list(range(9, 11))))
print('P_Igleich9oder10 = ' + myprint(P_Igleich9oder10))

P_Igleich7 = I.pmf(7)
print('P_Igleich7 = ' + myprint(P_Igleich7))

E_I = I.mean()
print('E_I = ' + myprint(E_I))

Var_I = I.var()
print('Var_I = ' + myprint(Var_I))