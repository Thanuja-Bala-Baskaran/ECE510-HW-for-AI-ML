# python_pipeline/ - Full Software Workflow: Profiling + DNN Training

This folder contains the complete **software-only implementation** of the Speech Emotion Recognition (SER) pipeline. It includes MFCC feature extraction, performance profiling, dataset preparation, and DNN model training using the RAVDESS dataset.

---

## Contents

| File Name                      | Description |
|-------------------------------|-------------|
| `batch_mfcc_profiler.py`      | Runs MFCC extraction (basic timing) for all `.wav` files in the dataset. |
| `batch_mfcc_profiler_detailed.py` | Same as above, but logs per-stage timing (FFT, Mel, Log, DCT) for each file. |
| `mfcc_profiling_results.csv`  | Output of `batch_mfcc_profiler.py` — contains basic timing per audio file. |
| `mfcc_detailed_profiling.csv` | Detailed timing for every MFCC stage per file. Used to identify bottlenecks. |
| `prepare_dataset.py`          | Prepares features and labels for training. Outputs `X.npy` and `y.npy`. |
| `X.npy`, `y.npy`              | Numpy arrays of MFCC features and emotion class labels. |
| `train_dnn_on_ravdess.py`     | Trains a DNN model using the extracted MFCCs. Supports multiple architectures. |
| `dnn_training_results.txt`    | Logs final training/testing accuracy of the trained model. |
| `ser_baseline.py`             | A simple baseline SER pipeline to compare against hardware acceleration. |

---

## Notes

- This folder was used to **profile** and **validate** which MFCC stages are the most time-consuming.
- The same dataset (`raw_audio/`) used in RTL testing is processed here for DNN training.
- Performance here serves as the **software baseline** against which hardware speedups are benchmarked.
