cmake_minimum_required(VERSION 3.27)
project(ml_bootstrap)

set(CMAKE_CXX_STANDARD 17)

add_compile_options(/DTFLITE_MMAP_DISABLED)
add_subdirectory(deps/tensorflow/tensorflow/lite/)

file(GLOB_RECURSE tflite_micro_src
        "${CMAKE_CURRENT_LIST_DIR}/deps/tflite-micro/tensorflow/lite/*.cc"
        "${CMAKE_CURRENT_LIST_DIR}/deps/tflite-micro/tensorflow/lite/*.cpp"
        "${CMAKE_CURRENT_LIST_DIR}/deps/tflite-micro/tensorflow/lite/*.cxx"
        "${CMAKE_CURRENT_LIST_DIR}/deps/tflite-micro/tensorflow/lite/*.c"
)

add_library(tflite-micro ${tflite_micro_src})
target_include_directories(tflite-micro PUBLIC ${CMAKE_CURRENT_LIST_DIR}/deps/tflite-micro)

message("SRC: ${tflite_micro_src}")

add_subdirectory(src/)
