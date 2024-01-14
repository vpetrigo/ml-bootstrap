add_executable(ml_app main.cpp model.c model.h)
target_link_libraries(ml_app PRIVATE tensorflow-lite)
