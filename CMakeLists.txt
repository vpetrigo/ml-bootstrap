cmake_minimum_required(VERSION 3.5...3.27)
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(ml_bootstrap)


include(cmake/tflite-micro.cmake)
include(cmake/utils.cmake)

macro(add_zephyr_interface_to_library target_name)
    target_link_libraries(${target_name} PRIVATE zephyr_interface)
endmacro()

macro(add_zephyr_interface_to_interface target_name)
    target_link_libraries(${target_name} INTERFACE zephyr_interface)
endmacro()

# CMSIS-NN specific variables
set(CORE M7)
set(ARM_CPU ARMC${CORE})
set(FPU_FEATURES _DP)
set(OPTIMIZED_KERNEL_NAME CMSIS_NN)

# CMSIS
add_library(cmsis INTERFACE)
target_include_directories(cmsis INTERFACE
        ${CMAKE_CURRENT_LIST_DIR}/deps/CMSIS_5/Device/ARM/ARMCM7/Include)
add_subdirectory(deps/CMSIS_5/CMSIS/NN)
# kissfft
add_library(kissfft deps/kissfft/kiss_fft.c deps/kissfft/tools/kiss_fftr.c)
target_include_directories(kissfft PUBLIC ${CMAKE_CURRENT_LIST_DIR}/deps/kissfft)
add_zephyr_interface_to_library(kissfft)
## Flatbuffers
add_library(flatbuffers INTERFACE)
target_include_directories(flatbuffers INTERFACE ${CMAKE_CURRENT_LIST_DIR}/deps/flatbuffers/include)
add_zephyr_interface_to_interface(flatbuffers)
## Ruy
add_library(ruy INTERFACE)
target_include_directories(ruy INTERFACE ${CMAKE_CURRENT_LIST_DIR}/deps/ruy)
add_zephyr_interface_to_interface(ruy)
## Fixedpoint
add_library(fixedpoint INTERFACE)
target_include_directories(fixedpoint INTERFACE
        ${CMAKE_CURRENT_LIST_DIR}/deps/gemmlowp)
target_link_libraries(fixedpoint INTERFACE zephyr_interface)
add_zephyr_interface_to_interface(fixedpoint)
## tflite-micro
add_library(tflite-micro OBJECT ${lib_srcs})
target_include_directories(tflite-micro PUBLIC
        ${CMAKE_CURRENT_LIST_DIR}/deps/tflite-micro)
target_compile_definitions(tflite-micro
        PRIVATE
        -DFARMHASH_NO_CXX_STRING
        PUBLIC
        # CMSIS-NN specific defines
        -DCMSIS_DEVICE_ARM_CORTEX_M_XX_HEADER_FILE=\"${ARM_CPU}${FPU_FEATURES}.h\"
        -D${ARM_CPU} -D${OPTIMIZED_KERNEL_NAME}
)
target_link_libraries(tflite-micro
        PRIVATE
        zephyr_interface kissfft ruy
        cmsis
        cmsis-nn
        PUBLIC
        flatbuffers fixedpoint
)
add_zephyr_interface_to_library(tflite-micro)

add_subdirectory(src/)
