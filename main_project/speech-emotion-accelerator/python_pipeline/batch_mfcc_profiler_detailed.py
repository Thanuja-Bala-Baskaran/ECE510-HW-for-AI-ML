import librosa
import numpy as np
import scipy.fftpack
import os
import time
import csv

# Define paths
dataset_root = "../dataset/raw_audio"
output_csv = "mfcc_detailed_profiling.csv"

# Prepare CSV
with open(output_csv, mode='w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow([
        "Filename",
        "STFT_Time_s",
        "Mel_Filterbank_Time_s",
        "Log_Scaling_Time_s",
        "DCT_Time_s",
        "Total_MFCC_Time_s"
    ])

    # Traverse dataset
    for root, _, files in os.walk(dataset_root):
        for file in files:
            if file.endswith(".wav"):
                filepath = os.path.join(root, file)
                rel_path = os.path.relpath(filepath, start=os.getcwd())
                try:
                    y, sr = librosa.load(filepath, sr=None)

                    total_start = time.time()

                    # STFT
                    start = time.time()
                    S = librosa.stft(y, n_fft=512, hop_length=256)
                    stft_time = time.time() - start

                    # Mel Filterbank
                    start = time.time()
                    mel_filter = librosa.filters.mel(sr=sr, n_fft=512, n_mels=13)
                    mel_time = time.time() - start

                    # Log Scaling
                    start = time.time()
                    log_mel = np.log(np.dot(mel_filter, np.abs(S)**2) + 1e-6)
                    log_time = time.time() - start

                    # DCT
                    start = time.time()
                    mfcc = scipy.fftpack.dct(log_mel, axis=0, norm='ortho')
                    dct_time = time.time() - start

                    total_time = time.time() - total_start

                    # Write row
                    writer.writerow([
                        rel_path,
                        f"{stft_time:.4f}",
                        f"{mel_time:.4f}",
                        f"{log_time:.4f}",
                        f"{dct_time:.4f}",
                        f"{total_time:.4f}"
                    ])
                except Exception as e:
                    print(f"Error processing {filepath}: {e}")
