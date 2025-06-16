# integration/ - Python Integration & Utility Scripts

This folder contains supporting Python scripts used for:
- Preparing dataset frames for RTL simulation
- Generating lookup tables for DCT and Mel filter
- Creating C/C++ headers for testbenches
- Benchmarking a software-only MFCC pipeline (in pure Python)

---

## File Descriptions

| File Name                  | Description |
|---------------------------|-------------|
| `extract_frame.py`        | Extracts a 512-sample frame from a `.wav` file, normalizes it, and writes it to `input_array.h` for Verilator simulation. |
| `gen_cpp_input.py`        | Converts a `.txt` list of integers into a C++-style array for use in Verilator simulations (`input_array.h`). |
| `gen_dct_cos_table.py`    | Creates cosine values in hex format for the hardware DCT block and saves it to `dct_cos_rom.hex`. |
| `gen_mel_coeff.py`        | Generates Mel filter coefficients and saves them in `mel_coeff_rom.hex` for RTL use. |
| `software_mfcc_benchmark.py` | A full pure Python implementation of FFT, Mel Filter Bank, Log Compression, and DCT using `input_array.h` as input. It benchmarks and prints execution time and 13 MFCC outputs. |
| `test.py`                 | Lightweight test utility for debugging and validating specific parts of the RTL output or software logic. |

---

## Notes

- All scripts are written in **pure Python** — `software_mfcc_benchmark.py` avoids using NumPy/SciPy to keep the execution intentionally slower than the hardware version.
- `integration/` acts as the **bridge between the raw dataset, hardware inputs, and testbench orchestration**.
- Used **before simulation** for input/header prep and **after simulation** for result comparison.
