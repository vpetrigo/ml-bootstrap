# Benchmarks

- Build with the FPU enabled and `-O2` optimization level

## TensorFlow Lite with the standard kernel

- Run `10000` iterations from 0 to 360 degress with the standard TensorFlow Lite kernels:

```
Benchmarking result (float model):
  model execution time (ns): 21283
  library execution time (ns): 630
Benchmarking result (quantized [int8] model):
  model execution time (ns): 24122
  library execution time (ns): 629
```

## TensorFlow Lite with the CMSIS-NN kernel

```
Benchmarking result (float model):
  model execution time (ns): 21473
  library execution time (ns): 630
Benchmarking result (quantized [int8] model):
  model execution time (ns): 16988
  library execution time (ns): 666
```
