#include "model.h"

#include "tensorflow/lite/core/c/common.h"
#include "tensorflow/lite/core/interpreter.h"
#include "tensorflow/lite/kernels/internal/constants.h"
#include "tensorflow/lite/kernels/register.h"
#include "tensorflow/lite/op_resolver.h"
#include "tensorflow/lite/version.h"

#include <cmath>
#include <iostream>

namespace
{
void model_run() {
    tflite::MutableOpResolver op_resolver;
    tflite::StderrReporter error_reporter;
    const tflite::Model *model = tflite::GetModel(model_get());

    if (model->version() != TFLITE_SCHEMA_VERSION) {
        TF_LITE_REPORT_ERROR(&error_reporter,
                             "Model provided is schema version %d not equal "
                             "to supported version %d.\n",
                             model->version(), TFLITE_SCHEMA_VERSION);
    }

    tflite::ops::builtin::BuiltinOpResolver resolver;
    tflite::InterpreterBuilder builder{model, resolver, &error_reporter};
    std::unique_ptr<tflite::Interpreter> interpreter;

    builder(&interpreter);
    interpreter->AllocateTensors();

    auto input = interpreter->typed_input_tensor<float>(0);
    auto output = interpreter->typed_output_tensor<float>(0);

    for (float i = 0.; i <= 2. * M_PI; i += M_PI / 4.) {
        const auto original_sin = std::sin(i);

        input[0] = i;
        interpreter->Invoke();

        const auto model_sin = output[0];

        std::cout << "Sin(" << i << "): Original: " << original_sin << " Model: " << model_sin << '\n';
        std::cout << "Diff: " << original_sin - model_sin << '\n';
    }
}
} // namespace

int main() {
    model_run();

    return 0;
}
