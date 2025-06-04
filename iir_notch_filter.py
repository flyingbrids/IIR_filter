import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import freqz

# Filter parameters
fs = 40e6 # Sampling frequency = 40 MHz
f0 = 1e6 # Notch frequency = 1 MHz
r = 0.95 # Controls notch width (close to 1 = narrow)

# Normalized frequency
omega_0 = 2 * np.pi * f0 / fs
cos_omega_0 = np.cos(omega_0)

# IIR Notch filter coefficients (floating-point)
b = [1, -2 * cos_omega_0, 1] # Numerator (zeros on unit circle)
a = [1, -2 * r * cos_omega_0, r**2] # Denominator (poles inside unit circle)

# Quantize to Q1.13 (scale factor = 2^13 = 8192)
scale_factor = 8192
b_q13 = [int(round(coef * scale_factor)) for coef in b]
a_q13 = [int(round(coef * scale_factor)) for coef in a]

# Display coefficients
print("Floating-point coefficients:")
print("b =", b)
print("a =", a)
print("\nQ1.13 quantized coefficients:")
print("b_q13 =", b_q13)
print("a_q13 =", a_q13)

# Frequency response
w, h = freqz(b, a, worN=2048, fs=fs)

# Plot magnitude response
plt.figure(figsize=(10, 5))
plt.plot(w / 1e6, 20 * np.log10(np.abs(h)), label="Magnitude (dB)")
plt.title("Frequency Response of IIR Notch Filter at 1 MHz")
plt.xlabel("Frequency (MHz)")
plt.ylabel("Magnitude (dB)")
plt.axvline(x=f0 / 1e6, color='red', linestyle='--', label="1 MHz Notch")
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.show()
