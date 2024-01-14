cmake_minimum_required(VERSION 3.27)
project(ml_bootstrap)

set(CMAKE_CXX_STANDARD 17)

add_compile_options(/DTFLITE_MMAP_DISABLED)
#add_subdirectory(deps/tensorflow/tensorflow/lite/)

#file(GLOB_RECURSE tflite_micro_src
#        "${CMAKE_CURRENT_LIST_DIR}/deps/tflite-micro/tensorflow/lite/*.cc"
#        "${CMAKE_CURRENT_LIST_DIR}/deps/tflite-micro/tensorflow/lite/*.cpp"
#        "${CMAKE_CURRENT_LIST_DIR}/deps/tflite-micro/tensorflow/lite/*.cxx"
#        "${CMAKE_CURRENT_LIST_DIR}/deps/tflite-micro/tensorflow/lite/*.c"
#)
#
#add_library(tflite-micro ${tflite_micro_src})
#target_include_directories(tflite-micro PUBLIC ${CMAKE_CURRENT_LIST_DIR}/deps/tflite-micro)
#
#message("SRC: ${tflite_micro_src}")

include(cmake/tflite-micro.cmake)

message("tflite-micro dir: ${tflite_dir}")
message("tflite-micro src: ${lib_srcs}")

# kissfft
#set(KISSFFT_PKGCONFIG OFF CACHE BOOL "")
#set(KISSFFT_TEST OFF CACHE BOOL "")
#set(KISSFFT_TOOLS OFF CACHE BOOL "")
#set(KISSFFT_DATATYPE "int16_t" CACHE STRING "")
#add_subdirectory(deps/kissfft)
#set(kissfft_src
#        deps/kissfft/kiss_fft.c
#        deps/kissfft/tools/kiss_fftr.c
#)
#add_library(kissfft ${kissfft_src})
add_library(kissfft INTERFACE)
#target_compile_definitions(kissfft PUBLIC -DFIXED_POINT=16)
target_include_directories(kissfft INTERFACE
        ${CMAKE_CURRENT_LIST_DIR}/deps/kissfft)
add_library(kissfft::kissfft ALIAS kissfft)
# Flatbuffers
add_subdirectory(deps/flatbuffers)
# Ruy
set(RUY_PROFILER ON CACHE BOOL "")
add_subdirectory(deps/ruy)
# Cpuinfo
add_subdirectory(deps/cpuinfo)
# Fixedpoint
add_library(fixedpoint INTERFACE)
target_include_directories(fixedpoint INTERFACE
        ${CMAKE_CURRENT_LIST_DIR}/deps/gemmlowp)

# tflite-micro
add_library(tflite-micro ${lib_srcs})
target_include_directories(tflite-micro PUBLIC
        ${CMAKE_CURRENT_LIST_DIR}/deps/tflite-micro
        ${CMAKE_CURRENT_LIST_DIR}/deps/ruy
        ${CMAKE_CURRENT_LIST_DIR}/deps/kissfft)
target_link_libraries(tflite-micro PRIVATE
        flatbuffers fixedpoint kissfft::kissfft)

add_subdirectory(src/)
