cmake_minimum_required(VERSION 3.18)
project(reelay_pybind LANGUAGES CXX)
set(PY_VERSION_SUFFIX "")
set(PY_FULL_VERSION ${PROJECT_VERSION}${PY_VERSION_SUFFIX})

# Make sure that the Python and CMake versions match
if (DEFINED PY_BUILD_CMAKE_PROJECT_VERSION)
    if (NOT "${PY_BUILD_CMAKE_PROJECT_VERSION}" MATCHES "^${PY_FULL_VERSION}$")
        message(FATAL_ERROR "Version number does not match "
                             "(${PY_BUILD_CMAKE_PROJECT_VERSION} - ${PY_FULL_VERSION}).")
    endif()
endif()

# Find the Python interpreter and the development files
if (CMAKE_CROSSCOMPILING AND NOT (APPLE AND "$ENV{CIBUILDWHEEL}" STREQUAL "1"))
    find_package(Python3 REQUIRED COMPONENTS Development.Module)
else()
    find_package(Python3 REQUIRED COMPONENTS Interpreter Development.Module)
endif()

# Find the pybind11 package
include(cmake/QueryPythonForPybind11.cmake)
find_pybind11_python_first()

# include(FetchContent)
# FetchContent_Declare(
#     pybind11
#     GIT_REPOSITORY https://github.com/pybind/pybind11.git
#     GIT_TAG        v2.13.6
# )
# FetchContent_MakeAvailable(pybind11)

# Set module name and source
pybind11_add_module(_reelay_module MODULE "src/main.cpp")

# Link dependencies
target_link_libraries(_reelay_module
  PRIVATE
    reelay::reelay
    pybind11::pybind11
)

# Add Python version info (optional but useful)
# You can define PY_FULL_VERSION in CMake or extract from Python3_VERSION
if(NOT DEFINED PY_FULL_VERSION)
  set(PY_FULL_VERSION "${Python3_VERSION}")
endif()
target_compile_definitions(_reelay_module
  PRIVATE
    MODULE_NAME="$<TARGET_FILE_BASE_NAME:_reelay_module>"
    VERSION_INFO="${PY_FULL_VERSION}"
)

# Hide all symbols by default (including external libraries on Linux)
set_target_properties(_reelay_module PROPERTIES
    CXX_VISIBILITY_PRESET "hidden"
    VISIBILITY_INLINES_HIDDEN true
)

if (CMAKE_SYSTEM_NAME MATCHES "Linux")
    target_link_options(_reelay_module PRIVATE "LINKER:--exclude-libs,ALL")
endif()

# Install the Python module
install(TARGETS _reelay_module
        EXCLUDE_FROM_ALL
        COMPONENT python_modules
        DESTINATION reelay
)
