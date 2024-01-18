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
target_compile_definitions(tflite-micro PRIVATE -DFARMHASH_NO_CXX_STRING)
target_link_libraries(tflite-micro
        PRIVATE
        zephyr_interface kissfft ruy
        PUBLIC
        flatbuffers fixedpoint
)
add_zephyr_interface_to_library(tflite-micro)

add_subdirectory(src/)
