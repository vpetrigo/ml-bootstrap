cmake_minimum_required(VERSION 3.27)
project(ml_bootstrap)

if (MSVC)
    add_compile_options(/DTFLITE_MMAP_DISABLED)
endif ()

include(cmake/tflite-micro.cmake)
include(cmake/utils.cmake)

add_compile_options(
        $<$<COMPILE_LANGUAGE:C>:-std=gnu17>
        $<$<COMPILE_LANGUAGE:CXX>:-std=gnu++17>
)
add_compile_options(-mcpu=cortex-m7 -mfpu=vfpv4-d16)
add_compile_options(
        -fno-unwind-tables -ffunction-sections -fdata-sections -fmessage-length=0
        $<$<COMPILE_LANGUAGE:CXX>:-fno-rtti>
        $<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>
        $<$<COMPILE_LANGUAGE:CXX>:-fno-threadsafe-statics>)
add_compile_options(
        -Wsign-compare -Wdouble-promotion -Wshadow
        -Wunused-variable -Wmissing-field-initializers
        -Wno-return-type -Wno-strict-aliasing
        -Wunused-function -Wswitch -Wvla -Wall -Wextra
        -Wstrict-aliasing -Wno-unused-parameter -Wno-nonnull)

message("tflite-micro dir: ${tflite_dir}")
message("tflite-micro src: ${lib_srcs}")

# kissfft
add_library(kissfft deps/kissfft/kiss_fft.c deps/kissfft/tools/kiss_fftr.c)
#target_compile_definitions(kissfft PUBLIC -DFIXED_POINT=16)
target_include_directories(kissfft PUBLIC
        ${CMAKE_CURRENT_LIST_DIR}/deps/kissfft)
add_library(kissfft::kissfft ALIAS kissfft)
# Flatbuffers
if (NOT MSVC)
    # We do not have relative path interface on embedded systems
    set(HAVE_REALPATH OFF CACHE BOOL "")
endif ()
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
add_library(tflite-micro OBJECT ${lib_srcs})
target_include_directories(tflite-micro PUBLIC
        ${CMAKE_CURRENT_LIST_DIR}/deps/tflite-micro
        ${CMAKE_CURRENT_LIST_DIR}/deps/ruy
        ${CMAKE_CURRENT_LIST_DIR}/deps/kissfft)
target_link_libraries(tflite-micro PRIVATE
        kissfft::kissfft)
target_link_libraries(tflite-micro PUBLIC
        flatbuffers fixedpoint)
target_compile_definitions(tflite-micro PRIVATE -DFARMHASH_NO_CXX_STRING)

if (MSVC)
    target_compile_definitions(tflite-micro
            PRIVATE TF_LITE_STATIC_MEMORY
    )
else ()
    target_compile_options(tflite-micro
            PUBLIC
            -Wno-sign-compare -Wno-unused-parameter -fno-exceptions
            PRIVATE
            -DTF_LITE_STATIC_MEMORY -DTF_LITE_DISABLE_X86_NEON
    )
endif ()

add_subdirectory(src/)
