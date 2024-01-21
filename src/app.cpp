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
#include <utility>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

extern unsigned char hello_world_float_tflite[];
extern unsigned char hello_world_int8_tflite[];

namespace
{
using HelloWorldOpResolver = tflite::MicroMutableOpResolver<1>;
using BenchmarkResult = std::pair<std::uint64_t, std::uint64_t>;

template <typename T>
class ModelWorker
{
  public:
    explicit ModelWorker(tflite::MicroInterpreter &interpreter) noexcept : interpreter_{interpreter} {
        TF_LITE_ASSERT(interpreter.AllocateTensors() == kTfLiteOk);
        input_ = interpreter_.typed_input_tensor<T>(0);
        output_ = interpreter_.typed_output_tensor<T>(0);
    }
    ~ModelWorker() = default;

    void SetInputValue(float value) noexcept {
        input_[0] = value;
    }

    TfLiteStatus Invoke() noexcept {
        return interpreter_.Invoke();
    }

    float GetValue() noexcept {
        return output_[0];
    }

  private:
    tflite::MicroInterpreter &interpreter_;
    T *input_;
    T *output_;
};

template <>
class ModelWorker<std::int8_t>
{
  public:
    using type = std::int8_t;

    explicit ModelWorker(tflite::MicroInterpreter &interpreter) noexcept : interpreter_{interpreter} {
        TF_LITE_ASSERT(interpreter.AllocateTensors() == kTfLiteOk);
        input_ = interpreter_.typed_input_tensor<type>(0);
        output_ = interpreter_.typed_output_tensor<type>(0);

        const auto input = interpreter_.input_tensor(0);
        const auto output = interpreter_.output_tensor(0);

        input_scale_ = input->params.scale;
        input_zero_point_ = input->params.zero_point;
        output_scale_ = output->params.scale;
        output_zero_point_ = output->params.zero_point;
    }

    ~ModelWorker() = default;

    void SetInputValue(float value) noexcept {
        input_[0] = static_cast<type>(value / input_scale_ + input_zero_point_);
    }

    TfLiteStatus Invoke() noexcept {
        return interpreter_.Invoke();
    }

    float GetValue() noexcept {
        return static_cast<float>((static_cast<int>(output_[0]) - output_zero_point_)) * output_scale_;
    }

  private:
    tflite::MicroInterpreter &interpreter_;
    std::int8_t *input_;
    float input_scale_;
    int input_zero_point_;
    std::int8_t *output_;
    float output_scale_;
    int output_zero_point_;
};

TfLiteStatus RegisterOps(HelloWorldOpResolver &op_resolver) {
    TF_LITE_ENSURE_STATUS(op_resolver.AddFullyConnected());
    return kTfLiteOk;
}

constexpr float radians_to_degrees(const float rad) {
    return rad * (180.f / static_cast<float>(M_PI));
}

template <typename T>
constexpr T calculate_average(T average, T new_value, size_t iteration) {
    average += (new_value / (iteration + 1) - average / (iteration + 1));

    return average;
}

template <typename T>
BenchmarkResult benchmark_runner(const unsigned char *tflite_model) {
    HelloWorldOpResolver op_resolver;
    constexpr float epsilon = 0.09f;
    const auto register_result = RegisterOps(op_resolver);
    TF_LITE_ASSERT(register_result == kTfLiteOk);
    const tflite::Model *model = tflite::GetModel(tflite_model);
    constexpr std::size_t tensor_arena_size = 2 * 1024;
    std::array<uint8_t, tensor_arena_size> tensor_arena{0};
    tflite::MicroInterpreter interpreter{model, op_resolver, tensor_arena.data(), tensor_arena_size};
    timing_t start{0};
    timing_t end{0};
    uint64_t cycles{0};
    size_t iteration{0};
    uint64_t model_execution_time_avg{0};
    uint64_t lib_execution_time_avg{0};
    ModelWorker<T> worker{interpreter};

    timing_init();
    timing_start();

    for (std::size_t i = 0; i < 10000; ++i) {
        for (float angle = 0.f; angle <= 2 * M_PI; angle += M_PI / 8.) {
            worker.SetInputValue(angle);

            start = timing_counter_get();
            TFLITE_CHECK_EQ(worker.Invoke(), kTfLiteOk);
            const float result_model = worker.GetValue();
            end = timing_counter_get();
            cycles = timing_cycles_get(&start, &end);
            const uint64_t time_ns_model = timing_cycles_to_ns(cycles);
            model_execution_time_avg = calculate_average(model_execution_time_avg, time_ns_model, iteration);

            start = timing_counter_get();
            const volatile float result_lib = sinf(angle);
            end = timing_counter_get();
            cycles = timing_cycles_get(&start, &end);
            const uint64_t time_ns_lib = timing_cycles_to_ns(cycles);
            lib_execution_time_avg = calculate_average(lib_execution_time_avg, time_ns_lib, iteration);
            TFLITE_CHECK_LE(fabsf(result_lib - result_model), epsilon);
            ++iteration;
        }
    }

    timing_stop();

    return std::make_pair(model_execution_time_avg, lib_execution_time_avg);
}

int benchmark_float_model() {
    const auto result = benchmark_runner<float>(hello_world_float_tflite);

    std::cout << "Benchmarking result (float model):\n";
    std::cout << "  model execution time (ns): " << result.first << '\n';
    std::cout << "  library execution time (ns): " << result.second << '\n';

    return 0;
}

int benchmark_int8_model() {
    const auto result = benchmark_runner<std::int8_t>(hello_world_int8_tflite);

    std::cout << "Benchmarking result (quantized [int8] model):\n";
    std::cout << "  model execution time (ns): " << result.first << '\n';
    std::cout << "  library execution time (ns): " << result.second << '\n';

    return 0;
}
} // namespace

int main(void) {
    benchmark_float_model();
    benchmark_int8_model();

    for (;;) {
        k_sleep(K_SECONDS(2));
    }

    return 0;
}
