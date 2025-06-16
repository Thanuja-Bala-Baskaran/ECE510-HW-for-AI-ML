# output/ - Simulation Outputs & Test Artifacts

This directory holds all the simulation output files generated during Verilator and Icarus Verilog runs. These include waveform traces, compiled simulation executables, and preprocessed frame input data.

---

## Contents

| File Name             | Description |
|----------------------|-------------|
| `fft.vcd`            | VCD (Value Change Dump) waveform file from `fft` simulation. Can be viewed using GTKWave. |
| `fft.vvp`            | Compiled simulation output for `fft.v` using Icarus Verilog (`.vvp` format). |
| `frame_input.txt`    | 512-sample audio frame in plain text format. Generated from `.wav` input using `extract_frame.py`. |
| `mel_filter_tb.out`  | Verilator-generated simulation executable output for `mel_filter_tb.v`. Used during verification. |
| `mfcc_top_tb.out`    | Verilator-generated simulation executable output for `mfcc_top_tb.v`. Used for full MFCC pipeline simulation. |

---

## Notes

- `*.vcd` files are helpful for debugging signal transitions in waveform viewers.
- `*.vvp` and `*.out` files are **compiled simulation executables**, created using `iverilog` or `verilator` and `make`.
- `frame_input.txt` is often the intermediate file between dataset preprocessing and RTL testbench input.
- This folder is **auto-generated during simulation** and can be cleaned/regenerated as needed.
