/**
 * \file
 * \brief
 * \author
 */
#define _USE_MATH_DEFINES // for C++

#include "model.h"

#include "tensorflow/lite/micro/micro_interpreter.h"
#include "tensorflow/lite/micro/micro_mutable_op_resolver.h"
#include "tensorflow/lite/micro/tflite_bridge/micro_error_reporter.h"
#include "tensorflow/lite/schema/schema_generated.h"

#include <cmath>
#include <iostream>

namespace
{
using HelloWorldOpResolver = tflite::MicroMutableOpResolver<1>;

TfLiteStatus RegisterOps(HelloWorldOpResolver &op_resolver) {
    TF_LITE_ENSURE_STATUS(op_resolver.AddFullyConnected());
    return kTfLiteOk;
}
} // namespace

int main() {
    HelloWorldOpResolver op_resolver;
    TF_LITE_ENSURE_STATUS(RegisterOps(op_resolver));
    const tflite::Model *model = ::tflite::GetModel(model_get());
    constexpr std::size_t tensor_arena_size = 2 * 1024;
    std::array<uint8_t, tensor_arena_size> tensor_arena{0};
    tflite::MicroInterpreter interpreter{model, op_resolver, tensor_arena.data(), tensor_arena_size};

    TF_LITE_ENSURE_STATUS(interpreter.AllocateTensors());
    float *input_tensor = interpreter.typed_input_tensor<float>(0);
    const float *output_tensor = interpreter.typed_output_tensor<float>(0);

    for (float i = 0.f; i <= 2 * M_PI; i += M_PI / 8) {
        input_tensor[0] = i;
        interpreter.Invoke();
    }

    return 0;
}
