import numpy as np
import os

N_INPUTS = 40     # Mel filterbank outputs
N_OUTPUTS = 13    # DCT coefficients to keep
Q_SCALE = 512     # For Q1.9 fixed-point (2^9)

output_dir = "rtl/dct"
os.makedirs(output_dir, exist_ok=True)

filename = os.path.join(output_dir, "dct_cos_table.hex")
with open(filename, "w") as f:
    for k in range(N_OUTPUTS):
        for n in range(N_INPUTS):
            angle = np.pi / N_INPUTS * (n + 0.5) * k
            val = np.cos(angle)
            fixed_val = int(round(val * Q_SCALE))  # Convert to Q1.9
            fixed_val = np.clip(fixed_val, -512, 511)  # Clamp to 10-bit signed range
            f.write(f"{fixed_val & 0x3FF:03x}\n")  # 10-bit hex (unsigned for Verilog)
print(f"✅ DCT cosine table written to: {filename}")
