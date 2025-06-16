import numpy as np
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout
from tensorflow.keras.utils import to_categorical
from sklearn.model_selection import train_test_split
import time

# Load precomputed features and labels
X = np.load("X.npy")
y = np.load("y.npy")

# Normalize inputs
X = X / np.max(np.abs(X))

# One-hot encode labels
num_classes = len(np.unique(y))
y_cat = to_categorical(y, num_classes)

# Train/test split
X_train, X_test, y_train, y_test = train_test_split(X, y_cat, test_size=0.2, random_state=42)

# Define DNN model
model = Sequential()
model.add(Dense(256, input_shape=(X.shape[1],), activation='relu'))
model.add(Dropout(0.3))
model.add(Dense(128, activation='relu'))
model.add(Dropout(0.3))
model.add(Dense(num_classes, activation='softmax'))

# Compile model
model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])

# Train and profile
start_time = time.time()
history = model.fit(X_train, y_train, epochs=20, batch_size=32, validation_data=(X_test, y_test))
end_time = time.time()

# Print training time
print(f"\n✅ DNN training complete. Total time: {end_time - start_time:.2f} seconds")

# Evaluate model
loss, acc = model.evaluate(X_test, y_test)
print(f"✅ Test Accuracy: {acc:.4f}")

# Save performance results
with open("dnn_training_results.txt", "w") as f:
    f.write(f"DNN Training Time (s): {end_time - start_time:.2f}\n")
    f.write(f"Test Accuracy: {acc:.4f}\n")
