cmake_minimum_required(VERSION 3.25)
cmake_policy(SET CMP0167 NEW)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR AND NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

# Read version numbers from version.hpp
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/include/reelay/version.hpp" version)

string(REGEX MATCH "#define[ \t]+REELAY_VERSION_MAJOR[ \t]+([0-9]+)" _ "${version}")
set(version_major "${CMAKE_MATCH_1}")

string(REGEX MATCH "#define[ \t]+REELAY_VERSION_MINOR[ \t]+([0-9]+)" _ "${version}")
set(version_minor "${CMAKE_MATCH_1}")

project(
  reelay
  DESCRIPTION "A header-only C++ library for system-level verification and declarative testing of real-time systems with Python bindings"
  HOMEPAGE_URL "https://github.com/doganulus/reelay"
  VERSION "${version_major}.${version_minor}"
  LANGUAGES CXX
)
string(TOUPPER ${PROJECT_NAME} PROJECT_PREFIX)

# C++ build settings
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Optional: coverage flags (used only in special configs)
set(CMAKE_CXX_FLAGS_COVERAGE "-O0 --coverage")

# Build options
option(REELAY_BUILD_APPS "Build Reelay Apps" OFF)
option(REELAY_BUILD_TESTS "Build the C++ unit tests" OFF)
option(REELAY_BUILD_PYTHON_BINDINGS "Build Python bindings" OFF)
option(REELAY_CUDD_BUILD_SHARED_LIBS "Build CUDD as shared library" OFF)

find_package(Threads REQUIRED)

# Fetch CUDD library
add_subdirectory(external/boost)
add_subdirectory(external/cudd)

# Create the main interface library
add_library(reelay INTERFACE)
add_library(reelay::reelay ALIAS reelay)

# Link dependencies
target_link_libraries(reelay INTERFACE
  Threads::Threads
  cudd::cudd
)

# Header and link dependencies
target_include_directories(
  reelay INTERFACE
    $<BUILD_INTERFACE:${Boost_INCLUDE_DIRS}>
    $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Install helpers
include(GNUInstallDirs)

# Install headers
install(DIRECTORY include/ DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}")

# Install targets
install(TARGETS reelay cudd EXPORT reelayTargets)

# Export config files
install(
  EXPORT reelayTargets
  NAMESPACE reelay::
  FILE reelayTargets.cmake
  DESTINATION "${CMAKE_INSTALL_DATADIR}/reelay/cmake"
)

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/reelayConfigVersion.cmake"
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY AnyNewerVersion
)

configure_package_config_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/reelayConfig.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/reelayConfig.cmake"
  INSTALL_DESTINATION "${CMAKE_INSTALL_DATADIR}/reelay/cmake")

install(FILES "${CMAKE_CURRENT_BINARY_DIR}/reelayConfig.cmake"
              "${CMAKE_CURRENT_BINARY_DIR}/reelayConfigVersion.cmake"
        DESTINATION "${CMAKE_INSTALL_DATADIR}/reelay/cmake")

# Add sources and tests

if(REELAY_BUILD_APPS)
  message(STATUS "Building Reelay apps...")
  add_subdirectory(apps)
endif()

if(REELAY_BUILD_TESTS)
  enable_testing()
  add_subdirectory(external/catch2)
  add_subdirectory(tests)
endif()

if(REELAY_BUILD_PYTHON_BINDINGS)
  add_subdirectory(python)
endif()

# Compile Commands
if (PROJECT_IS_TOP_LEVEL AND UNIX)
    # Create symlink to compile_commands.json for IDE to pick it up
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E create_symlink
            ${CMAKE_BINARY_DIR}/compile_commands.json
            ${CMAKE_CURRENT_SOURCE_DIR}/compile_commands.json
    )
endif()
