# RTL - MFCC Hardware Modules

This folder contains the RTL (Register-Transfer Level) Verilog implementation of the core MFCC (Mel Frequency Cepstral Coefficients) pipeline. Each module corresponds to a stage in the MFCC extraction process. These modules are written in synthesizable Verilog and tested via simulation testbenches.

## Contents

| File Name              | Description                                                                       |
|------------------------|-----------------------------------------------------------------------------------|
| `fft.v`                | Top-level FFT module (1-stage implementation) for computing real FFT.             |
| `butterfly.v`          | Submodule used inside FFT for complex pair computation (butterfly operation).     |
| `mel_filter_bank.v`    | Calculates mel energies using a triangular filter bank over FFT power output.     |
| `log_compression.v`    | Applies logarithmic compression to mel energy outputs.                            |
| `dct.v`                | Computes the Discrete Cosine Transform (DCT) on log-mel energies to get 13 MFCCs. |
| `dct_cos_rom.mem`      | Hex memory file containing precomputed cosine coefficients for DCT.               |
| `mel_coeff_rom.hex`    | Hex memory file containing mel filter coefficients used in `mel_filter_bank.v`.   |

## Notes

- All modules are parameterized for easy modification.
- Input/output widths are 18 bits where necessary to allow signal precision for audio processing.
- The FFT currently uses a 512-point input and outputs 256 frequency bins (due to symmetry in real-input FFTs).
- `mel_filter_bank.v` uses ROM-based coefficients and accumulates energy over 40 mel bands.
- DCT outputs the first 13 coefficients (standard for MFCC applications).
- All computation stages are pipelined with handshaking (e.g., `valid_in`, `done`) for integration.
- ROM memory initialization uses `readmemh` during simulation.

## Usage

These RTL modules are instantiated in the top-level `mfcc_top.v` file and verified through simulation using testbenches found in the `sim/` directory.

---
