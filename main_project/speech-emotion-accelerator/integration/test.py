import numpy as np
import librosa

# Simulate your testbench input
x = np.arange(512).astype(np.float32)  # same as in Verilog TB

# Use 512-point FFT and 40 Mel filters
sr = 16000  # sample rate
mfcc = librosa.feature.mfcc(y=x, sr=sr, n_fft=512, n_mels=40, n_mfcc=13)

print(np.round(mfcc.T[0]))  # First frame MFCCs
