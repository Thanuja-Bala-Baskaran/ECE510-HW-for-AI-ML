# Dataset - RAVDESS Audio and MFCC Reference Data

This folder contains the input dataset used for testing, profiling, and validating both the hardware and software MFCC pipelines. It consists of audio files from the RAVDESS dataset and their corresponding MFCC outputs generated using NumPy.

## Contents

### `raw_audio/`

- Contains `.wav` audio files downloaded from the **RAVDESS** (Ryerson Audio-Visual Database of Emotional Speech and Song) dataset.
- These audio files serve as:
  - Input for real-time MFCC extraction and emotion recognition profiling.
  - Test vectors for end-to-end hardware-software validation.

> All files in this directory are assumed to be mono-channel 16-bit PCM `.wav` files sampled at 48kHz.

### `mfcc_numpy/`

- Contains `.npy` files (NumPy arrays) storing reference MFCC vectors for each `.wav` file in `raw_audio/`.
- Generated using a Python-based MFCC extraction pipeline (`librosa` or custom NumPy logic).
- Used for performance benchmarking and correctness validation against hardware-generated MFCCs.

## Notes

- RAVDESS dataset includes audio clips representing different emotions (happy, sad, angry, calm, etc.).
- Only a selected subset of the RAVDESS corpus is used for faster iteration and focused testing.
- Ensure that all `.npy` and `.wav` filenames are aligned to enable pairing between raw audio and expected MFCC output.

## Typical Usage

- `raw_audio/` → Used by: `extract_frame.py`, real-time testing
- `mfcc_numpy/` → Used by: `compare_outputs.py`, software benchmark scripts

---
