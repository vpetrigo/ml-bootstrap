/**
 * \file
 * \brief
 * \author
 */

#include "model.h"

#include "tensorflow/lite/micro/micro_interpreter.h"
#include "tensorflow/lite/micro/micro_mutable_op_resolver.h"
#include "tensorflow/lite/micro/tflite_bridge/micro_error_reporter.h"
#include "tensorflow/lite/schema/schema_generated.h"

#include "zephyr/kernel.h"
#include "zephyr/timing/timing.h"

#include <cmath>
#include <iostream>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

namespace
{
using HelloWorldOpResolver = tflite::MicroMutableOpResolver<1>;

TfLiteStatus RegisterOps(HelloWorldOpResolver &op_resolver) {
    TF_LITE_ENSURE_STATUS(op_resolver.AddFullyConnected());
    return kTfLiteOk;
}

constexpr float radians_to_degrees(const float rad) {
    return rad * (180.f / static_cast<float>(M_PI));
}
} // namespace

int main(void) {
    HelloWorldOpResolver op_resolver;
    TF_LITE_ENSURE_STATUS(RegisterOps(op_resolver));
    const tflite::Model *model = ::tflite::GetModel(model_get());
    constexpr std::size_t tensor_arena_size = 2 * 1024;
    std::array<uint8_t, tensor_arena_size> tensor_arena{0};
    tflite::MicroInterpreter interpreter{model, op_resolver, tensor_arena.data(), tensor_arena_size};

    TF_LITE_ENSURE_STATUS(interpreter.AllocateTensors());
    float *input_tensor = interpreter.typed_input_tensor<float>(0);
    const float *output_tensor = interpreter.typed_output_tensor<float>(0);
    timing_t start;
    timing_t end;

    for (;;) {
        timing_init();
        timing_start();

        for (float i = 0.f; i <= 2 * M_PI; i += M_PI / 8) {
            input_tensor[0] = i;
            start = timing_counter_get();
            interpreter.Invoke();
            end = timing_counter_get();

            uint64_t cycles = timing_cycles_get(&start, &end);
            const uint64_t time_ns_model = timing_cycles_to_ns(cycles);
            const float result_model = output_tensor[0];

            start = timing_counter_get();
            const float result_lib = sinf(i);
            end = timing_counter_get();
            cycles = timing_cycles_get(&start, &end);
            const uint64_t time_ns_lib = timing_cycles_to_ns(cycles);

            std::cout << "Sin(" << radians_to_degrees(i) << ") output: model - " << result_model << " lib - "
                      << result_lib << '\n';
            std::cout << "Model execution time: " << time_ns_model << " ns\n";
            std::cout << "Library execution time: " << time_ns_lib << " ns\n";
            k_sleep(K_MSEC(400));
        }

        timing_stop();
        k_sleep(K_SECONDS(2));
    }

    return 0;
}
