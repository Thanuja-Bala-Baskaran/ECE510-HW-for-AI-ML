import numpy as np

frame = np.loadtxt("output/frame_input.txt", dtype=int)
assert len(frame) == 512, "Expected 512-sample frame!"

with open("sim/input_array.h", "w") as f:
    f.write("const int16_t input_frame[512] = {\n    ")
    for i, val in enumerate(frame):
        f.write(f"{val}, ")
        if (i + 1) % 8 == 0:
            f.write("\n    ")
    f.write("\n};\n")

print("[DONE] C++ array written to sim/input_array.h")
