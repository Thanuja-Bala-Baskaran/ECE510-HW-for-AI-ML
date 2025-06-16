# Phase 1 Profiling Results (Baseline Python SER Pipeline)

MFCC extraction time: 5.8780 seconds  
DNN training time: 3.7089 seconds  

Notes:
- MFCC is significantly more compute-heavy.
- We will target the MFCC (especially DCT/filterbank stage) for hardware acceleration in RTL.
