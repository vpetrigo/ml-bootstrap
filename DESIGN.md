# Benchmarks

- Build with the FPU enabled and `-O2` optimization level

## TensorFlow Lite with the standard kernel

- Run `100000` iterations from 0 to 360 degress with the standard TensorFlow Lite kernels:

```
Benchmarking result (float model):
  model execution time (ns): 21354
  library execution time (ns): 636
Benchmarking result (quantized [int8] model):
  model execution time (ns): 24132
  library execution time (ns): 639
```

## TensorFlow Lite with the CMSIS-NN kernel

```
Benchmarking result (float model):
  model execution time (ns): 21475
  library execution time (ns): 630
Benchmarking result (quantized [int8] model):
  model execution time (ns): 16973
  library execution time (ns): 634
```
