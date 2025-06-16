import os
import numpy as np
import librosa

# RAVDESS directory
DATASET_DIR = "../dataset/raw_audio"

# Emotion map (based on RAVDESS filenames)
emotion_map = {
    "01": "neutral",
    "02": "calm",
    "03": "happy",
    "04": "sad",
    "05": "angry",
    "06": "fearful",
    "07": "disgust",
    "08": "surprised"
}

X = []
y = []

for root, dirs, files in os.walk(DATASET_DIR):
    for file in files:
        if file.endswith(".wav"):
            path = os.path.join(root, file)

            # Extract emotion from filename
            emotion_code = file.split("-")[2]
            label = emotion_map.get(emotion_code)
            if label is None:
                continue

            # Load and extract MFCC
            audio, sr = librosa.load(path, sr=None)
            mfcc = librosa.feature.mfcc(y=audio, sr=sr, n_mfcc=13)
            mfcc_mean = np.mean(mfcc.T, axis=0)

            X.append(mfcc_mean)
            y.append(int(emotion_code) - 1)  # Convert to 0-based index

# Save the data
X = np.array(X)
y = np.array(y)

np.save("X.npy", X)
np.save("y.npy", y)

print(f"✅ Saved {X.shape[0]} samples to X.npy and y.npy.")
