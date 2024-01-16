#add_executable(ml_app main.cpp model.c model.h)
#target_link_libraries(ml_app PRIVATE tensorflow-lite)

add_executable(ml_lite_app main_lite.cpp model.c model.h)
target_compile_options(ml_lite_app PRIVATE --specs=nosys.specs)
target_link_libraries(ml_lite_app PRIVATE tflite-micro kissfft::kissfft)
target_link_options(ml_lite_app PRIVATE --specs=nosys.specs -T ${CMAKE_CURRENT_LIST_DIR}/mcu/stm32f7x6ni/linker.ld)

firmware_size(ml_lite_app berkley)
