cmake_minimum_required(VERSION 3.19)
project(first_fuzz_project)

# GoogleTest requires at least C++17
set(CMAKE_CXX_STANDARD 20)

message(STATUS "CMAKE_CXX_COMPILER_ID: ${CMAKE_CXX_COMPILER_ID}")

add_subdirectory(fuzztest)

enable_testing()

include(GoogleTest)

fuzztest_setup_fuzzing_flags()

find_package(Boost REQUIRED)

add_executable(
  silkworm_fuzz_test
  runner.cc
)

# If you have other dependencies than FuzzTest, link them:
# target_link_libraries(silkworm_fuzz_test PRIVATE other_deps)

link_fuzztest(silkworm_fuzz_test)
gtest_discover_tests(silkworm_fuzz_test)


