# -*- coding: utf-8 -*-
"""
Created on Tue Mar 17 13:43:25 2026

@author: LeChat https://chat.mistral.ai/chat
Problem setting and minor modification: Barbara Staehle, HTWG Konstanz
bstaehle@htwg-konstanz.de
"""

import matplotlib.pyplot as plt
import numpy as np


# Figur erstellen
fig, ax = plt.subplots(figsize=(8, 8))

# "Hello World" in der Mitte des Plots schreiben
ax.text(0.5, 0.5, "Hello World!",
        fontsize=20,
        ha='center',  # horizontal zentriert
        va='center',  # vertikal zentriert
        color='teal',
        fontweight='bold')

# Zufällige Punkte um den Text herum generieren
np.random.seed(42)  # Für reproduzierbare Zufallswerte
num_points = 42     # Anzahl der Punkte
radius = 0.4        # Maximaler Abstand der Punkte vom Zentrum

# Zufällige Winkel und Radien generieren
angles = np.random.uniform(0, 2 * np.pi, num_points)
radii = np.random.uniform(0.2, radius, num_points)  # Minimaler Radius 0.2

# Koordinaten der Punkte berechnen
x_points = 0.5 + radii * np.cos(angles)
y_points = 0.5 + radii * np.sin(angles)

colors = np.random.rand(num_points, 3)  # Zufällige Farben für jeden Punkt
ax.scatter(x_points, y_points, color=colors, s=50, alpha=0.7)

# Punkte plotten
ax.scatter(x_points, y_points, color=colors, s=50, alpha=0.7)

# Achsen ausblenden (für bessere Optik)
ax.set_xticks([])
ax.set_yticks([])

# Anzeigen
plt.show()
