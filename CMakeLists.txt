# Required to keep CMake happy.
cmake_minimum_required(VERSION 3.18.2...3.20 FATAL_ERROR)

find_package(cetmodules 2.17.03 REQUIRED)

# Project information.
project(cetbuildtools VERSION 8.19.02 LANGUAGES NONE)

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

# Make sure this is a transitive dependency.
cet_find_package(cetmodules REQUIRED)

####################################
# Build components.
####################################

####################################
# Generate CMake (and UPS, if appropriate) configuration files and
# packaging.
cet_cmake_config(CONFIG_POST_DEPS config/${PROJECT_NAME}-quiet-warnings.cmake)
