cmake_minimum_required(VERSION 3.16)
project(blink VERSION 0.1.0 LANGUAGES CXX)

add_executable(blink blink.cpp)
target_link_libraries(blink PRIVATE gpiodcxx)