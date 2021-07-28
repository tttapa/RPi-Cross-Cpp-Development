cmake_minimum_required(VERSION 3.16)
project(hello VERSION 0.1.0)

find_package(Boost REQUIRED COMPONENTS program_options)

add_executable(hello main.cpp)
target_link_libraries(hello PRIVATE Boost::program_options)