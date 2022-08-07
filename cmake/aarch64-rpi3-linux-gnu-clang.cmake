# https://cmake.org/cmake/help/book/mastering-cmake/chapter/Cross%20Compiling%20With%20CMake.html

# Cross-compilation system information
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# The sysroot contains all the libraries we might need to link against and 
# possibly headers we need for compilation
set(CMAKE_SYSROOT /var/lib/schroot/chroots/schroot-name-arm64)
set(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT}) 
set(CMAKE_LIBRARY_ARCHITECTURE aarch64-linux-gnu)
set(CMAKE_STAGING_PREFIX $ENV{HOME}/RPi-dev/staging-aarch64-rpi3)

# Select the GCC toolchain to use
set(RPI_GCC_TRIPLE "aarch64-rpi3-linux-gnu")
set(RPI_C_COMPILER ${RPI_GCC_TRIPLE}-gcc)

# Find Clang
set(RPI_CLANG_PREFIX "" CACHE STRING "Prefix to the Clang command")
set(RPI_CLANG_SUFFIX "" CACHE STRING "Suffix to the Clang command")
set(RPI_C_COMPILER_CLANG ${RPI_CLANG_PREFIX}clang${RPI_CLANG_SUFFIX}
    CACHE FILEPATH "Full name or path of the clang command")
set(RPI_CXX_COMPILER_CLANG ${RPI_CLANG_PREFIX}clang++${RPI_CLANG_SUFFIX}
    CACHE FILEPATH "Full name or path of the clang++ command")
# Use Clang as the cross-compiler
set(CMAKE_C_COMPILER ${RPI_C_COMPILER_CLANG} CACHE FILEPATH "C compiler")
set(CMAKE_CXX_COMPILER ${RPI_CXX_COMPILER_CLANG} CACHE FILEPATH "C++ compiler")

# Get the machine triple from GCC
execute_process(COMMAND ${RPI_C_COMPILER} -dumpmachine
                OUTPUT_VARIABLE RPI_GCC_TRIPLE_EFFECTIVE
                OUTPUT_STRIP_TRAILING_WHITESPACE)
set(RPI_GCC_TRIPLE_EFFECTIVE ${RPI_GCC_TRIPLE_EFFECTIVE}
    CACHE STRING "The GNU triple of the toolchain actually in use")
if (NOT RPI_GCC_TRIPLE_EFFECTIVE)
    message(FATAL_ERROR "Unable to determine GCC triple")
endif()

# Get the installation folder from GCC
execute_process(COMMAND ${RPI_C_COMPILER} -print-search-dirs
                OUTPUT_VARIABLE RPI_GCC_INSTALL)
string(REGEX MATCH "(^|\r|\n)install: +([^\r\n]*)" 
       RPI_GCC_INSTALL_LINE ${RPI_GCC_INSTALL})
if (NOT RPI_GCC_INSTALL_LINE)
    message(FATAL_ERROR "Unable to determine GCC installation")
endif()
cmake_path(SET RPI_GCC_INSTALL NORMALIZE ${CMAKE_MATCH_2})
cmake_path(APPEND RPI_GCC_INSTALL "../../../..")
cmake_path(ABSOLUTE_PATH RPI_GCC_INSTALL)
set(RPI_GCC_INSTALL ${RPI_GCC_INSTALL} CACHE PATH "Path to GCC installation")

# Find a linker
find_program(RPI_LINKER ${RPI_GCC_TRIPLE}-ld REQUIRED)

# Specify architecture-specific flags
set(ARCH_FLAGS "-target ${RPI_GCC_TRIPLE_EFFECTIVE} \
                -mcpu=cortex-a53+crc+simd")
# Make sure that Clang finds the GCC installation and a suitable linker
set(TOOLCHAIN_FLAGS "--gcc-toolchain=${RPI_GCC_INSTALL}")
set(TOOLCHAIN_LINK_FLAGS "-fuse-ld=${RPI_LINKER}")
# Compilation flags
set(CMAKE_C_FLAGS_INIT "${ARCH_FLAGS} ${TOOLCHAIN_FLAGS}")
set(CMAKE_CXX_FLAGS_INIT "${ARCH_FLAGS} ${TOOLCHAIN_FLAGS} ")
# Linker flags
string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " ${TOOLCHAIN_LINK_FLAGS}")
string(APPEND CMAKE_MODULE_LINKER_FLAGS_INIT " ${TOOLCHAIN_LINK_FLAGS}")
string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT " ${TOOLCHAIN_LINK_FLAGS}")

# Don't look for programs in the sysroot (these are ARM programs, they won't run
# on the build machine)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# Only look for libraries, headers and packages in the sysroot, don't look on 
# the build machine
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE arm64)
