include(FetchContent)

set(CUDD_BUILD_SHARED_LIBS ${REELAY_CUDD_BUILD_SHARED_LIBS} CACHE BOOL "")

FetchContent_Declare(
  cudd
  GIT_REPOSITORY https://github.com/cuddorg/cudd.git
  GIT_TAG        pitchfork-layout
)
FetchContent_MakeAvailable(cudd)
