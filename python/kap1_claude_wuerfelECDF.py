# -*- coding: utf-8 -*-
"""
Created on Fri Sep 26 10:19:58 2025

@author: Claude https://claude.ai/chat/
Problem setting and minor modification: Barbara Staehle, HTWG Konstanz
bstaehle@htwg-konstanz.de
"""

import numpy as np
import matplotlib.pyplot as plt
#from scipy import stats
import seaborn as sns

# Würfeldaten
dice_rolls = [4, 1, 1, 5, 3, 3, 1, 4, 5, 6, 1, 4, 1, 6, 1, 2, 1, 2, 3, 5]
n = len(dice_rolls)

print("=== EMPIRICAL CUMULATIVE DISTRIBUTION FUNCTION (ECDF) ===")
print(f"Daten: {dice_rolls}")
print(f"Anzahl Werte: {n}")
print()

# Methode 1: Manuelle ECDF-Berechnung
def compute_ecdf(data):
    """Berechnet die ECDF für gegebene Daten"""
    x = np.sort(data)
    y = np.arange(1, len(data) + 1) / len(data)
    return x, y

x_ecdf, y_ecdf = compute_ecdf(dice_rolls)

# %%

print("ECDF-Werte (x, y):")
for i, (x_val, y_val) in enumerate(zip(x_ecdf, y_ecdf)):
    print(f"  {x_val}: {y_val:.3f} ({y_val*100:.1f}%)")

print()

# Interpretation für Würfelwerte
print("=== INTERPRETATION ===")
for face in range(1, 7):
    # Anteil der Werte <= face
    proportion = np.sum(np.array(dice_rolls) <= face) / n
    count = np.sum(np.array(dice_rolls) <= face)
    print(f"P(X ≤ {face}) = {proportion:.3f} ({proportion*100:.1f}%) - {count} von {n} Werten")

print()

# Theoretische ECDF für fairen Würfel
def theoretical_ecdf_dice(x):
    """Theoretische ECDF für fairen 6-seitigen Würfel"""
    if x < 1:
        return 0
    elif x >= 6:
        return 1
    else:
        return np.floor(x) / 6

# Visualisierung
plt.figure(figsize=(15, 10))

# Subplot 1: Empirische ECDF
plt.subplot(2, 3, 1)
plt.plot(x_ecdf, y_ecdf, 'bo-', linewidth=2, markersize=8, label='Empirische ECDF', alpha=0.7)
plt.xlabel('Würfelwert')
plt.ylabel('Kumulative Wahrscheinlichkeit')
plt.title('Empirische ECDF der Würfeldaten')
plt.grid(True, alpha=0.3)
plt.legend()
plt.xlim(0.5, 6.5)
plt.ylim(0, 1)

# %%

# Subplot 2: Vergleich mit theoretischer ECDF
plt.subplot(2, 3, 2)
# Empirische ECDF
plt.step(x_ecdf, y_ecdf, where='post', linewidth=3, label='Empirisch', alpha=0.8)

# Theoretische ECDF (fairer Würfel)
x_theory = np.arange(1, 7)
y_theory = x_theory / 6
plt.step(x_theory, y_theory, where='post', linewidth=3, 
         linestyle='--', color='red', label='Theoretisch (fair)')

plt.xlabel('Würfelwert')
plt.ylabel('Kumulative Wahrscheinlichkeit')
plt.title('Empirisch vs. Theoretisch')
plt.grid(True, alpha=0.3)
plt.legend()
plt.xlim(0.5, 6.5)
plt.ylim(0, 1)

# %%

# Subplot 3: ECDF mit Konfidenzintervall (Dvoretzky-Kiefer-Wolfowitz)
plt.subplot(2, 3, 3)
plt.step(x_ecdf, y_ecdf, where='post', linewidth=3, label='Empirisch')

# DKW-Konfidenzband (95%)
alpha_conf = 0.05
epsilon = np.sqrt(np.log(2/alpha_conf) / (2*n))

y_upper = np.minimum(y_ecdf + epsilon, 1)
y_lower = np.maximum(y_ecdf - epsilon, 0)

plt.fill_between(x_ecdf, y_lower, y_upper, alpha=0.3, 
                 label=f'{int((1-alpha_conf)*100)}% Konfidenzband')
plt.step(x_theory, y_theory, where='post', linewidth=2, 
         linestyle='--', color='red', label='Theoretisch')

plt.xlabel('Würfelwert')
plt.ylabel('Kumulative Wahrscheinlichkeit')
plt.title('ECDF mit Konfidenzband')
plt.grid(True, alpha=0.3)
plt.legend()
plt.xlim(0.5, 6.5)
plt.ylim(0, 1)

# %%

# Subplot 4: Seaborn ECDF
plt.subplot(2, 3, 4)
sns.ecdfplot(data=dice_rolls, linewidth=3, label='Seaborn ECDF')
plt.step(x_theory, y_theory, where='post', linewidth=2, 
         linestyle='--', color='red', label='Theoretisch')
plt.xlabel('Würfelwert')
plt.ylabel('Kumulative Wahrscheinlichkeit')
plt.title('ECDF mit Seaborn')
plt.grid(True, alpha=0.3)
plt.legend()
plt.xlim(0.5, 6.5)

# %%

# Subplot 5: Residuen (Abweichungen)
plt.subplot(2, 3, 5)
x_vals = np.arange(1, 7)
empirical_vals = [np.sum(np.array(dice_rolls) <= x) / n for x in x_vals]
theoretical_vals = [x / 6 for x in x_vals]
residuals = [emp - theo for emp, theo in zip(empirical_vals, theoretical_vals)]

plt.bar(x_vals, residuals, alpha=0.7, 
        color=['red' if r < -0.1 else 'green' if r > 0.1 else 'gray' for r in residuals])
plt.axhline(y=0, color='black', linestyle='-', linewidth=1)
plt.xlabel('Würfelwert')
plt.ylabel('ECDF-Differenz (Empirisch - Theoretisch)')
plt.title('Abweichungen von der theoretischen ECDF')
plt.grid(True, alpha=0.3)

# Werte auf Balken
for i, (x, r) in enumerate(zip(x_vals, residuals)):
    plt.text(x, r + (0.02 if r >= 0 else -0.02), f'{r:+.3f}', 
             ha='center', va='bottom' if r >= 0 else 'top', fontweight='bold')

# %%

# Subplot 6: Kolmogorov-Smirnov Test Visualisierung
plt.subplot(2, 3, 6)
# KS-Statistik berechnen
ks_stat = max(abs(emp - theo) for emp, theo in zip(empirical_vals, theoretical_vals))

plt.step(x_ecdf, y_ecdf, where='post', linewidth=3, label='Empirisch')
plt.step(x_theory, y_theory, where='post', linewidth=3, 
         linestyle='--', color='red', label='Theoretisch')

# Maximale Abweichung markieren
max_diff_idx = np.argmax([abs(emp - theo) for emp, theo in zip(empirical_vals, theoretical_vals)])
max_x = x_vals[max_diff_idx]
max_emp = empirical_vals[max_diff_idx]
max_theo = theoretical_vals[max_diff_idx]

plt.annotate('', xy=(max_x, max_emp), xytext=(max_x, max_theo),
            arrowprops=dict(arrowstyle='<->', color='orange', lw=3))
plt.text(max_x + 0.1, (max_emp + max_theo)/2, f'KS={ks_stat:.3f}', 
         fontweight='bold', color='orange')

plt.xlabel('Würfelwert')
plt.ylabel('Kumulative Wahrscheinlichkeit')
plt.title('Kolmogorov-Smirnov Statistik')
plt.grid(True, alpha=0.3)
plt.legend()
plt.xlim(0.5, 6.5)
plt.ylim(0, 1)

plt.tight_layout()
plt.show()

# %%

# Statistische Tests
print("=== STATISTISCHE TESTS ===")

# Kolmogorov-Smirnov Test gegen Uniform(1,6)
# Da diskrete Verteilung, approximativ
def discrete_uniform_cdf(x):
    return np.floor(np.clip(x, 1, 6)) / 6

ks_statistic = ks_stat
print(f"Kolmogorov-Smirnov Statistik: {ks_statistic:.4f}")

# Kritischer Wert für KS-Test
ks_critical = 1.36 / np.sqrt(n)  # Approximation für α=0.05
print(f"Kritischer Wert (α=0.05): {ks_critical:.4f}")

if ks_statistic > ks_critical:
    print("❌ KS-Test: Signifikante Abweichung von Gleichverteilung")
else:
    print("✅ KS-Test: Keine signifikante Abweichung von Gleichverteilung")

print()
print("=== ECDF-ZUSAMMENFASSUNG ===")
print("• ECDF zeigt kumulierte Wahrscheinlichkeiten")
print("• Steile Anstiege = häufige Werte")
print("• Flache Bereiche = seltene Werte")
print(f"• Größte Abweichung bei Wert {max_x}: {ks_statistic:.3f}")
print("• Für Würfel sollte ECDF gleichmäßige Stufen zeigen")