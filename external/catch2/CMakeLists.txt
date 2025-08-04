include(FetchContent)
set(FETCHCONTENT_QUIET OFF)

set(FETCHCONTENT_TRY_FIND_PACKAGE_MODE "NEVER")

set(REELAY_CATCH2_VERSION_MINIMUM "3.8.0" CACHE STRING "Catch2 minimum version")
set(REELAY_CATCH2_VERSION_FETCH   "3.9.0" CACHE STRING "Catch2 version to fetch")

FetchContent_Declare(
  Catch2
  GIT_REPOSITORY https://github.com/catchorg/Catch2.git
  GIT_TAG        v${REELAY_CATCH2_VERSION_FETCH}
  EXCLUDE_FROM_ALL
  FIND_PACKAGE_ARGS ${REELAY_CATCH2_VERSION_MINIMUM}
)
FetchContent_MakeAvailable(Catch2)

set(CMAKE_MODULE_PATH
  "${CMAKE_MODULE_PATH};${Catch2_SOURCE_DIR}/extras"
  CACHE STRING "Extra module path"
)
