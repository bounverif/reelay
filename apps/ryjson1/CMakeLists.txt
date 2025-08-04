project(ryjson CXX)

add_subdirectory(external/simdjson)

add_executable(ryjson)

target_sources(ryjson PRIVATE "main.cpp")
target_link_libraries(ryjson PRIVATE reelay::reelay simdjson::simdjson)

install(TARGETS ryjson)
