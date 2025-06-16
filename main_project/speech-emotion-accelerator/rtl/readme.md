# RTL Module Specification for MFCC Accelerator

This document defines the individual RTL blocks required to implement the MFCC accelerator. Each block will be written in Verilog, simulated, and later integrated into a Python co-design flow.

---

## Block-Level Specification

| Module Name         | Inputs                       | Outputs                     | Notes                                  |
|---------------------|------------------------------|-----------------------------|----------------------------------------|
| `pre_emphasis.v`    | Sample                       | Filtered sample             | y[n] = x[n] - α * x[n-1], α ≈ 0.95     |
| `frame_buffer.v`    | Stream of samples            | 1 frame (e.g., 400 samples) | With optional Hamming/Hanning window   |
| `fft.v`             | Frame of samples             | FFT output (complex bins)   | Use radix-2 or Cooley-Tukey FFT logic  |
| `mel_filterbank.v`  | Power spectrum               | 40 Mel energies             | Filter bank mapping via coefficient ROM|
| `log_compression.v` | Mel energies                 | Log-scaled energies         | Use LUT or approximation method        |
| `dct.v`             | Log Mel energies             | 13 MFCC coefficients        | Discrete Cosine Transform Type II      |

---

## Data Precision

- Fixed-point format: Q1.15 (signed 16-bit)
- FFT inputs/outputs may require wider intermediate widths (e.g., Q2.14 or Q4.12)

---

## Control Signals (Generic)

Each module should support:

- `clk`, `rst`
- `valid_in`, `data_in`
- `ready_out`, `valid_out`, `data_out`
- `start`, `done` (if non-streaming)

---

## Interfaces

- Most blocks: Streaming data pipeline (valid/ready)
- FFT & DCT may use BRAM-style or buffered input interfaces
- Final accelerator block: receives framed, normalized samples and outputs 13 MFCCs

---
