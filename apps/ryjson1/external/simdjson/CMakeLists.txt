include(FetchContent)

set(SIMDJSON_VERSION "3.13.0" CACHE STRING "Simdjson version")

FetchContent_Declare(
  simdjson
  GIT_REPOSITORY https://github.com/simdjson/simdjson.git
  GIT_TAG        v${SIMDJSON_VERSION}
  GIT_SHALLOW    TRUE
)
FetchContent_MakeAvailable(simdjson)
