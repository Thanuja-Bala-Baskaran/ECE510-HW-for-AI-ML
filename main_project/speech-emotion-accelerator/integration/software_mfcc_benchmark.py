import time
import math
import re

# ------------------------
# Utility: Read input_array.h
# ------------------------
def read_input_header(file_path):
    with open(file_path, 'r') as f:
        content = f.read()

    # Extract array between {} brackets
    matches = re.search(r'{(.*?)}', content, re.DOTALL)
    if not matches:
        raise ValueError("Could not find array in input_array.h")

    array_str = matches.group(1).strip()
    array_values = [int(x.strip()) for x in array_str.split(',') if x.strip()]
    return array_values

# ------------------------
# Step 1: DFT
# ------------------------
def dft(signal):
    N = len(signal)
    real = [0.0] * N
    imag = [0.0] * N
    for k in range(N):
        for n in range(N):
            angle = 2 * math.pi * k * n / N
            real[k] += signal[n] * math.cos(angle)
            imag[k] -= signal[n] * math.sin(angle)
    return real, imag

# ------------------------
# Step 2: Power Spectrum
# ------------------------
def power_spectrum(real, imag):
    return [real[i]**2 + imag[i]**2 for i in range(len(real))]

# ------------------------
# Step 3: Mel Filter Bank (13 filters)
# ------------------------
def mel_filterbank(power, num_filters=13):
    N = len(power)
    mel_energies = [0] * num_filters
    for i in range(num_filters):
        left = i * (N // (num_filters + 1))
        center = (i + 1) * (N // (num_filters + 1))
        right = (i + 2) * (N // (num_filters + 1))

        for j in range(left, center):
            weight = (j - left) / (center - left)
            mel_energies[i] += power[j] * weight
        for j in range(center, right):
            weight = (right - j) / (right - center)
            mel_energies[i] += power[j] * weight

    return mel_energies

# ------------------------
# Step 4: Log Compression
# ------------------------
def log_compression(mel_energies):
    return [math.log10(e + 1e-6) for e in mel_energies]

# ------------------------
# Step 5: DCT
# ------------------------
def dct(log_mel):
    N = len(log_mel)
    mfcc = [0.0] * N
    for k in range(N):
        for n in range(N):
            mfcc[k] += log_mel[n] * math.cos(math.pi * k * (2*n + 1) / (2 * N))
    return mfcc

# ------------------------
# Main: Full Pipeline
# ------------------------
def main():
    signal = read_input_header("sim/input_array.h")

    start_time = time.time()

    # Steps
    real, imag = dft(signal)
    power = power_spectrum(real, imag)
    mel_energies = mel_filterbank(power, 13)
    log_mel = log_compression(mel_energies)
    mfcc = dct(log_mel)

    end_time = time.time()
    elapsed_ms = (end_time - start_time) * 1000

    print(f"\n[INFO] Pure Python MFCC time: {elapsed_ms:.2f} ms")
    print("[INFO] Final 13 MFCC coefficients:")
    for i, coeff in enumerate(mfcc[:13]):
        print(f"MFCC[{i}] = {int(coeff)}")

if __name__ == "__main__":
    main()
