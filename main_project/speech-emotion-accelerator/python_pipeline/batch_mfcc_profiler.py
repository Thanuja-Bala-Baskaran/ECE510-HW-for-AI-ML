import os
import librosa
import numpy as np
import time
import csv

# Input folder (your full dataset)
DATASET_PATH = "../dataset/raw_audio"
RESULTS_CSV = "mfcc_profiling_results.csv"

# Output list of [file_path, time_taken]
results = []

# Walk through Actor_* folders
for root, _, files in os.walk(DATASET_PATH):
    for file in files:
        if file.endswith(".wav"):
            file_path = os.path.join(root, file)
            try:
                y, sr = librosa.load(file_path, sr=None)
                start_time = time.time()
                mfcc = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=13)
                end_time = time.time()
                time_taken = end_time - start_time

                results.append([file_path, f"{time_taken:.4f}"])

                # Optional: save MFCCs as .npy file
                out_dir = os.path.join("..", "dataset", "mfcc_numpy")
                os.makedirs(out_dir, exist_ok=True)
                np.save(os.path.join(out_dir, file.replace(".wav", ".npy")), mfcc)

                print(f"✓ Processed {file} in {time_taken:.4f}s")

            except Exception as e:
                print(f"⚠️ Failed to process {file}: {e}")

# Save profiling results to CSV
with open(RESULTS_CSV, "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["Filename", "MFCC_Extraction_Time_s"])
    writer.writerows(results)

print(f"\n✅ Profiling complete. Results saved to {RESULTS_CSV}")
