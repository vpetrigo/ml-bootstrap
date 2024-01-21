target_sources(app PRIVATE app.cpp hello_int8_model.c hello_model.c)
target_link_libraries(app PRIVATE tflite-micro)
