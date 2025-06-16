import librosa
import numpy as np
import tensorflow as tf
import time

# Load sample audio (use your own .wav later)
y, sr = librosa.load(librosa.ex('trumpet'), sr=None)

# Extract MFCCs
start_mfcc = time.time()
mfccs = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=13)
end_mfcc = time.time()

# Flatten and reshape for input to DNN
X = mfccs.T
X = X.reshape(X.shape[0], -1)

# Dummy labels (for classification simulation)
y_dummy = np.random.randint(0, 3, size=(X.shape[0],))
y_dummy = tf.keras.utils.to_categorical(y_dummy, num_classes=3)

# Simple DNN
model = tf.keras.Sequential([
    tf.keras.layers.Input(shape=(X.shape[1],)),
    tf.keras.layers.Dense(64, activation='relu'),
    tf.keras.layers.Dense(32, activation='relu'),
    tf.keras.layers.Dense(3, activation='softmax')
])
model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

# Train DNN
start_dnn = time.time()
model.fit(X, y_dummy, epochs=3, verbose=0)
end_dnn = time.time()

# Profile times
print(f"MFCC extraction time: {end_mfcc - start_mfcc:.4f} seconds")
print(f"DNN training time: {end_dnn - start_dnn:.4f} seconds")
