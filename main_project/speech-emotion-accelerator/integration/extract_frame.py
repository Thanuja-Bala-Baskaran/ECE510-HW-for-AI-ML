import numpy as np
import scipy.io.wavfile as wav

input_wav = "integration/03-01-02-01-02-01-01.wav"
output_txt = "output/frame_input.txt"
frame_size = 512
energy_threshold = 1000  # tune this if needed

rate, signal = wav.read(input_wav)
print(f"[INFO] Sample rate = {rate}")
print(f"[INFO] Shape = {signal.shape}, dtype = {signal.dtype}")

if signal.ndim == 2:
    signal = signal[:, 0]
    print("[INFO] Stereo detected. Using left channel.")

if np.issubdtype(signal.dtype, np.floating):
    signal = (signal * 32767).astype(np.int16)

num_frames = len(signal) // frame_size
frame_found = False

for i in range(num_frames):
    start = i * frame_size
    end = start + frame_size
    frame = signal[start:end]

    energy = np.sum(np.abs(frame))
    if energy > energy_threshold:
        print(f"[INFO] Frame #{i} has energy = {energy}")
        print(f"[INFO] First 10 values: {frame[:10]}")
        np.savetxt(output_txt, frame, fmt='%d', delimiter=' ')
        frame_found = True
        break

if not frame_found:
    print("[WARN] No high-energy frame found. Try lowering the threshold.")

else:
    print(f"[DONE] Frame saved to {output_txt}")

