# ML on Cortex-M MCU

## Build options

- "ZEPHYR_TOOLCHAIN_VARIANT": "gnuarmemb"
- "GNUARMEMB_TOOLCHAIN_PATH": "<path/to/arm/gcc/bin>"
- "BOARD": "stm32f769i_disco"

## Requirements

- DTC compiler should be in the `PATH` to allow Zephyr kernel build
  - Window: install via [Chocolatey](https://community.chocolatey.org/packages/dtc-msys2) or download
  [required packages](https://community.chocolatey.org/packages/dtc-msys2#files). You can download all packages from
  [MSYS2 registry](https://packages.msys2.org/package/dtc?repo=msys&variant=x86_64)
