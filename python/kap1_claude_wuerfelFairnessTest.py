# -*- coding: utf-8 -*-
"""

Created on Fri Sep 26 09:49:15 2025

@author: Claude https://claude.ai/chat/
Problem setting and minor modification: Barbara Staehle, HTWG Konstanz
bstaehle@htwg-konstanz.de
"""

import numpy as np
from scipy import stats
from collections import Counter
import matplotlib.pyplot as plt

# Würfelergebnisse
dice_rolls = [4, 1, 1, 5, 3, 3, 1, 4, 5, 6, 1, 4, 1, 6, 1, 2, 1, 2, 3, 5]
n_rolls = len(dice_rolls)
n_faces = 6

print("=== WÜRFEL-FAIRNESS-ANALYSE ===")
print(f"Anzahl Würfe: {n_rolls}")
print(f"Würfelergebnisse: {dice_rolls}")
print()

# Häufigkeitsanalyse
frequency = Counter(dice_rolls)
print("Beobachtete Häufigkeiten:")
for face in range(1, 7):
    count = frequency.get(face, 0)
    percentage = (count / n_rolls) * 100
    print(f"Zahl {face}: {count}x ({percentage:.1f}%)")

print()

# Erwartete Häufigkeit bei fairem Würfel
expected_freq = n_rolls / n_faces
print(f"Erwartete Häufigkeit pro Zahl bei fairem Würfel: {expected_freq:.2f}")
print()

# Chi-Quadrat-Test
observed_frequencies = [frequency.get(face, 0) for face in range(1, 7)]
expected_frequencies = [expected_freq] * n_faces

chi2_stat, p_value = stats.chisquare(observed_frequencies, expected_frequencies)

print("=== CHI-QUADRAT-TEST ===")
print(f"Chi²-Statistik: {chi2_stat:.4f}")
print(f"p-Wert: {p_value:.4f}")
print(f"Freiheitsgrade: {n_faces - 1}")
print()

# Interpretation
alpha = 0.05
print(f"Signifikanzniveau: {alpha}")
if p_value < alpha:
    print("❌ ERGEBNIS: Der Würfel ist wahrscheinlich NICHT fair (gezinkt)")
    print(f"   Die Abweichungen sind statistisch signifikant (p < {alpha})")
else:
    print("✅ ERGEBNIS: Kein statistischer Beweis für Manipulation")
    print(f"   Die Abweichungen könnten durch Zufall erklärt werden (p ≥ {alpha})")

print()

# Weitere Analysen
print("=== WEITERE BEOBACHTUNGEN ===")

# Auffälligkeiten
most_common = frequency.most_common(1)[0]
least_common = min(frequency.items(), key=lambda x: x[1]) if frequency else (0, 0)

print(f"Häufigste Zahl: {most_common[0]} ({most_common[1]}x)")
print(f"Seltenste Zahl: {least_common[0]} ({least_common[1]}x)")
print(f"Unterschied: {most_common[1] - least_common[1]} Würfe")

# Die 1 ist besonders auffällig
ones_count = frequency.get(1, 0)
ones_percentage = (ones_count / n_rolls) * 100
print(f"\n🎯 AUFFÄLLIGKEIT: Die 1 kam {ones_count}x vor ({ones_percentage:.1f}%)")
print(f"   Bei einem fairen Würfel wären ~{expected_freq:.1f} Einsen erwartet")

# Statistische Power-Analyse
print(f"\n=== STATISTISCHE EINSCHRÄNKUNGEN ===")
print(f"⚠️  WICHTIG: Bei nur {n_rolls} Würfen ist die statistische Power begrenzt")
print(f"   Für robuste Aussagen wären mindestens 60-100 Würfe nötig")
print(f"   Kleinere Manipulationen könnten unentdeckt bleiben")

# Simulation: Was wäre bei mehr Würfen?
print(f"\n=== WAS WÄRE BEI MEHR WÜRFEN? ===")
if ones_count > expected_freq:
    bias_factor = ones_count / expected_freq
    print(f"Falls die 1 wirklich {bias_factor:.1f}x wahrscheinlicher ist:")
    for n_sim in [60, 100, 200]:
        expected_ones_biased = n_sim * (bias_factor / n_faces)
        expected_others = n_sim * (1 - bias_factor/n_faces) / 5
        print(f"  Bei {n_sim} Würfen: ~{expected_ones_biased:.0f} Einsen, ~{expected_others:.0f} andere")

# Visualisierung mit Matplotlib
plt.figure(figsize=(12, 8))

# Subplot 1: Häufigkeiten
plt.subplot(2, 2, 1)
faces = list(range(1, 7))
bars = plt.bar(faces, observed_frequencies, alpha=0.7, color='steelblue', label='Beobachtet')
plt.axhline(y=expected_freq, color='red', linestyle='--', linewidth=2, label=f'Erwartet ({expected_freq:.1f})')

# Werte auf den Balken anzeigen
for i, bar in enumerate(bars):
    height = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2., height + 0.1,
             f'{int(height)}', ha='center', va='bottom', fontweight='bold')

plt.xlabel('Würfelzahl')
plt.ylabel('Häufigkeit')
plt.title('Beobachtete vs. Erwartete Häufigkeiten')
plt.legend()
plt.grid(True, alpha=0.3)
plt.xticks(faces)

# Subplot 2: Prozentuale Verteilung
plt.subplot(2, 2, 2)
percentages = [(count/n_rolls)*100 for count in observed_frequencies]
expected_percentage = (1/6)*100

bars2 = plt.bar(faces, percentages, alpha=0.7, color='green', label='Beobachtet (%)')
plt.axhline(y=expected_percentage, color='red', linestyle='--', linewidth=2, 
            label=f'Erwartet ({expected_percentage:.1f}%)')

# Prozente auf Balken
for i, bar in enumerate(bars2):
    height = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2., height + 0.5,
             f'{height:.1f}%', ha='center', va='bottom', fontweight='bold')

plt.xlabel('Würfelzahl')
plt.ylabel('Relative Häufigkeit (%)')
plt.title('Prozentuale Verteilung')
plt.legend()
plt.grid(True, alpha=0.3)
plt.xticks(faces)
plt.ylim(0, max(percentages) * 1.2)

# Subplot 3: Abweichungen vom Erwartungswert
plt.subplot(2, 2, 3)
deviations = [obs - expected_freq for obs in observed_frequencies]
colors = ['red' if dev < -1 else 'green' if dev > 1 else 'gray' for dev in deviations]

bars3 = plt.bar(faces, deviations, alpha=0.7, color=colors)
plt.axhline(y=0, color='black', linestyle='-', linewidth=1)

# Abweichungen auf Balken
for i, bar in enumerate(bars3):
    height = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2., height + (0.1 if height >= 0 else -0.2),
             f'{height:+.1f}', ha='center', va='bottom' if height >= 0 else 'top', 
             fontweight='bold')

plt.xlabel('Würfelzahl')
plt.ylabel('Abweichung vom Erwartungswert')
plt.title('Abweichungen (Rot: deutlich unter, Grün: deutlich über Erwartung)')
plt.grid(True, alpha=0.3)
plt.xticks(faces)

# Subplot 4: Kumulierte Würfe (Reihenfolge)
plt.subplot(2, 2, 4)
cumulative_ones = []
cumulative_total = []
ones_count_running = 0

for i, roll in enumerate(dice_rolls, 1):
    if roll == 1:
        ones_count_running += 1
    cumulative_ones.append(ones_count_running)
    cumulative_total.append(i)

# Beobachtete Einsen
plt.plot(cumulative_total, cumulative_ones, 'b-', linewidth=2, label='Beobachtete Einsen')

# Erwartete Einsen (Linie)
expected_line = [x/6 for x in cumulative_total]
plt.plot(cumulative_total, expected_line, 'r--', linewidth=2, label='Erwartete Einsen')

plt.xlabel('Wurf Nummer')
plt.ylabel('Kumulierte Anzahl Einsen')
plt.title('Verlauf der Einsen über die Würfe')
plt.legend()
plt.grid(True, alpha=0.3)

plt.tight_layout()
plt.suptitle(f'Würfel-Fairness-Analyse ({n_rolls} Würfe)\nChi²={chi2_stat:.3f}, p={p_value:.3f}', 
             fontsize=14, y=1.02)
plt.show()

# Zusätzliche Textausgabe für bessere Interpretation
print(f"\n📊 DIAGRAMM-INTERPRETATION:")
print(f"• Obere Diagramme: Absolute und relative Häufigkeiten")
print(f"• Unten links: Abweichungen (Rot/Grün = auffällige Abweichungen)")
print(f"• Unten rechts: Verlauf der Einsen - zeigt, wann sie gehäuft auftraten")