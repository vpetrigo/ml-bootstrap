set(tflite_dir "${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite")
set(tfmicro_dir "${tflite_dir}/micro")
set(tfmicro_frontend_dir "${tflite_dir}/experimental/microfrontend/lib")
set(tfmicro_kernels_dir "${tfmicro_dir}/kernels")

file(GLOB srcs_micro
        "${tfmicro_dir}/*.cc"
        "${tfmicro_dir}/*.c")

file(GLOB src_micro_frontend
        "${tfmicro_frontend_dir}/*.c"
        "${tfmicro_frontend_dir}/*.cc")

file(GLOB srcs_kernels
        "${tfmicro_kernels_dir}/*.c"
        "${tfmicro_kernels_dir}/*.cc")

set(lib_srcs
        "${srcs_micro}"
        "${srcs_kernels}"
        "${src_micro_frontend}"
)

list(FILTER lib_srcs EXCLUDE REGEX ".*_test\.(c|cc)")
list(FILTER lib_srcs EXCLUDE REGEX "test_.*\.(c|cc)")
list(FILTER lib_srcs EXCLUDE REGEX ".*_main.c")
list(FILTER lib_srcs EXCLUDE REGEX "kiss.*.(c|cc)")
#foreach ()
#        "${tflite_dir}/kernels/kernel_util.cc"
#        "${tflite_dir}/micro/memory_planner/greedy_memory_planner.cc"
#        "${tflite_dir}/micro/memory_planner/linear_memory_planner.cc"
#        "${tflite_dir}/c/common.c"
#        "${tflite_dir}/core/api/error_reporter.cc"
#        "${tflite_dir}/core/api/flatbuffer_conversions.cc"
#        "${tflite_dir}/core/api/op_resolver.cc"
#        "${tflite_dir}/core/api/tensor_utils.cc"
#        "${tflite_dir}/kernels/internal/quantization_util.cc"
#        "${tflite_dir}/schema/schema_utils.cc")
