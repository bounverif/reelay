include(FetchContent)
set(FETCHCONTENT_QUIET OFF)

set(REELAY_BOOST_VERSION_MINIMUM "1.83.0" CACHE STRING "Boost minimum version")
set(REELAY_BOOST_VERSION_FETCH   "1.88.0" CACHE STRING "Boost version to fetch")

set(Boost_USE_STATIC_LIBS ON CACHE BOOL "Use static Boost libraries")

# FetchContent_Declare(
#   Boost
#   URL "https://github.com/boostorg/boost/releases/download/boost-${REELAY_BOOST_VERSION_FETCH}/boost-${REELAY_BOOST_VERSION_FETCH}-cmake.tar.gz"
#   EXCLUDE_FROM_ALL
#   FIND_PACKAGE_ARGS ${REELAY_BOOST_VERSION_MINIMUM} COMPONENTS ALL CONFIG
# )
# FetchContent_MakeAvailable(Boost)

find_package(Boost ${REELAY_BOOST_VERSION_MINIMUM} REQUIRED COMPONENTS json)
