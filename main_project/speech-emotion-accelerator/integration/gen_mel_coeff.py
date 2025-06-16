import numpy as np
import os

N_FFT = 256
N_FILTERS = 40

output_path = "rtl/mel_coeff/mel_coeffs.hex"
os.makedirs("rtl/mel_coeff", exist_ok=True)

with open(output_path, "w") as f:
    for i in range(N_FILTERS):
        center = int((i + 1) * N_FFT / (N_FILTERS + 1))
        left = max(0, center - 10)
        right = min(N_FFT, center + 10)

        coeff = np.zeros(N_FFT, dtype=int)
        for j in range(left, center):
            coeff[j] = int(256 * (j - left) / (center - left))
        for j in range(center, right):
            coeff[j] = int(256 * (right - j) / (right - center))

        for val in coeff:
            f.write(f"{val:04x}\n")

print(f"Generated flattened coefficient file: {output_path}")
