set(tflite_dir "${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite")
set(tfmicro_dir "${tflite_dir}/micro")
set(tfmicro_frontend_dir "${tflite_dir}/experimental/microfrontend/lib")
set(tfmicro_kernels_dir "${tfmicro_dir}/kernels")

file(GLOB srcs_micro
        "${tfmicro_dir}/*.cc"
        "${tfmicro_dir}/*.c"
        "${tfmicro_dir}/tflite_bridge/*.cc"
        "${tfmicro_dir}/tflite_bridge/*.c"
        "${tfmicro_dir}")

file(GLOB src_micro_frontend
        "${tfmicro_frontend_dir}/*.c"
        "${tfmicro_frontend_dir}/*.cc")

file(GLOB srcs_kernels
        "${tflite_dir}/kernels/internal/*.c"
        "${tflite_dir}/kernels/internal/*.cc"
        "${tflite_dir}/kernels/internal/reference/*.c"
        "${tflite_dir}/kernels/internal/reference/*.cc"
        "${tflite_dir}/kernels/*.c"
        "${tflite_dir}/kernels/*.cc"
        "${tfmicro_kernels_dir}/*.c"
        "${tfmicro_kernels_dir}/*.cc")

file(GLOB srcs_mem
        "${tfmicro_dir}/arena_allocator/persistent_arena_buffer_allocator.cc"
        "${tfmicro_dir}/arena_allocator/non_persistent_arena_buffer_allocator.cc"
        "${tfmicro_dir}/arena_allocator/recording_single_arena_buffer_allocator.cc"
        "${tfmicro_dir}/arena_allocator/single_arena_buffer_allocator.cc"
        "${tfmicro_dir}/memory_planner/greedy_memory_planner.cc"
        "${tfmicro_dir}/memory_planner/linear_memory_planner.cc"
)

file(GLOB srcs_core
#        "${tflite_dir}/array.cc"
        "${tflite_dir}/core/api/*.c"
        "${tflite_dir}/core/api/*.cc"
        "${tflite_dir}/core/c/*.c"
        "${tflite_dir}/core/c/*.cc"
)

file(GLOB srcs_schemas
        "${tflite_dir}/schema/schema_utils.cc"
)

set(lib_srcs
        "${srcs_core}"
        "${srcs_micro}"
        "${srcs_kernels}"
        "${src_micro_frontend}"
        "${srcs_schemas}"
        "${srcs_mem}"
)

list(FILTER lib_srcs EXCLUDE REGEX ".*_test\.(c|cc)")
list(FILTER lib_srcs EXCLUDE REGEX "test_.*\.(c|cc)")
list(FILTER lib_srcs EXCLUDE REGEX ".*_main.c")
list(FILTER lib_srcs EXCLUDE REGEX "frontend_memmap_generator.c")
list(FILTER lib_srcs EXCLUDE REGEX "kernel_runner.cc")
list(FILTER lib_srcs EXCLUDE REGEX "kiss.*.(c|cc)")
list(FILTER lib_srcs EXCLUDE REGEX "mock_.*.(c|cc)")
