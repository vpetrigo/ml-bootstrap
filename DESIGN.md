# Initial tflite-micro integration results

- Simple prediction of the `sin` function (with `-Os` optimization):

```
Sin(270) output: model - -1.00883 lib - -1
Model execution time: 22148 ns
Library execution time: 763 ns
Sin(292.5) output: model - -0.915045 lib - -0.923879
Model execution time: 22013 ns
Library execution time: 750 ns
Sin(315) output: model - -0.710789 lib - -0.707107
Model execution time: 22064 ns
Library execution time: 805 ns
Sin(337.5) output: model - -0.380449 lib - -0.382683
Model execution time: 22041 ns
Library execution time: 666 ns
```

# tflite-micro with CMSIS-NN

- Simple prediction of the `sin` function (with `-O2` optimization):

```
Sin(270) output: model - -1.00883 lib - -1
Model execution time: 22412 ns
Library execution time: 791 ns
Sin(292.5) output: model - -0.915045 lib - -0.923879
Model execution time: 22222 ns
Library execution time: 703 ns
Sin(315) output: model - -0.710789 lib - -0.707107
Model execution time: 22236 ns
Library execution time: 763 ns
Sin(337.5) output: model - -0.380449 lib - -0.382683
Model execution time: 22509 ns
Library execution time: 763 ns
```
