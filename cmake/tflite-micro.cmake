set(tflite_dir "${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite")
set(tfmicro_dir "${tflite_dir}/micro")
set(tfmicro_frontend_dir "${tflite_dir}/experimental/microfrontend/lib")
set(tfmicro_kernels_dir "${tfmicro_dir}/kernels")


if (FALSE)
    set(srcs_micro_platform
            ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_time.cc
            ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/debug_log.cc
    )
else ()
    # Cortex-M specific
    # Use along with the CMSIS-NN library
    set(srcs_micro_platform
            ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/cortex_m_generic/debug_log.cc
            ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/cortex_m_generic/debug_log_callback.h
            ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/cortex_m_generic/micro_time.cc
    )
endif ()


set(srcs_micro
        ${srcs_micro_platform}
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/compatibility.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/debug_log.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/fake_micro_context.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/fake_micro_context.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/flatbuffer_utils.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/flatbuffer_utils.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/memory_helpers.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/memory_helpers.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_allocation_info.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_allocation_info.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_allocator.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_allocator.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_arena_constants.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_common.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_context.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_context.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_graph.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_interpreter.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_interpreter.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_interpreter_context.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_interpreter_context.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_interpreter_graph.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_interpreter_graph.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_log.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_log.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_mutable_op_resolver.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_op_resolver.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_op_resolver.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_profiler.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_profiler.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_profiler_interface.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_resource_variable.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_resource_variable.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_time.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_utils.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/micro_utils.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/recording_micro_allocator.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/recording_micro_allocator.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/recording_micro_interpreter.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/system_setup.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/system_setup.h
)

set(srcs_micro_tflite_bridge
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/tflite_bridge/flatbuffer_conversions_bridge.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/tflite_bridge/flatbuffer_conversions_bridge.h
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/tflite_bridge/micro_error_reporter.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/deps/tflite-micro/tensorflow/lite/micro/tflite_bridge/micro_error_reporter.h
)

#file(GLOB srcs_micro
#        "${tfmicro_dir}/*.cc"
#        "${tfmicro_dir}/*.c"
#        "${tfmicro_dir}/tflite_bridge/*.cc"
#        "${tfmicro_dir}/tflite_bridge/*.c"
#        "${tfmicro_dir}")

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
        "${srcs_micro_tflite_bridge}"
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
