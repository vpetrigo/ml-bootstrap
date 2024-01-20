target_sources(app PRIVATE app.cpp model.h model.c)
target_link_libraries(app PRIVATE tflite-micro)
#        cmsis-nn)
