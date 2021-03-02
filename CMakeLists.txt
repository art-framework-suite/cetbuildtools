# Required to keep CMake happy.
cmake_minimum_required(VERSION 3.18.2 FATAL_ERROR)

find_package(cetmodules 2.11.00)

# Project information.
project(cetbuildtools VERSION 8.01.00 LANGUAGES NONE)

# No tests of cetmodules.
set(BUILD_TESTING OFF)

# Other configuration.
set(${PROJECT_NAME}_BIN_DIR "")
set(${PROJECT_NAME}_FHICL_DIR "")
set(${PROJECT_NAME}_INCLUDE_DIR "")
set(${PROJECT_NAME}_LIBRARY_DIR "")
set(${PROJECT_NAME}_NOARCH TRUE)

# Basic build environment.
include(CetCMakeEnv)
cet_cmake_env()

####################################
# Build components.
####################################

####################################
# Generate CMake (and UPS, if appropriate) configuration files and
# packaging.
cet_cmake_config(NO_CMAKE_CONFIG)
