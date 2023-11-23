cmake_minimum_required(VERSION 3.19)
project(first_fuzz_project)

# GoogleTest requires at least C++17
set(CMAKE_CXX_STANDARD 20)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")


# ************************************************************
include(cmake/conan.cmake)

set_property(
  DIRECTORY
  APPEND
  PROPERTY CMAKE_CONFIGURE_DEPENDS conanfile.py
)

# ************************************************************

find_package(nlohmann_json REQUIRED)
find_package(absl REQUIRED)
find_package(GTest REQUIRED)
find_package(asio-grpc REQUIRED)
find_package(Boost REQUIRED headers)

add_subdirectory(fuzztest)

enable_testing()

include(GoogleTest)

fuzztest_setup_fuzzing_flags()

add_executable(
  silkworm_fuzz_test
  runner.cc
)

# If you have other dependencies than FuzzTest, link them:
# target_link_libraries(silkworm_fuzz_test PRIVATE other_deps)

link_fuzztest(silkworm_fuzz_test)
gtest_discover_tests(silkworm_fuzz_test)

target_link_libraries(silkworm_fuzz_test PRIVATE nlohmann_json::nlohmann_json Boost::headers absl::strings GTest::gtest asio-grpc::asio-grpc )

# try using different linkers
# set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fuse-ld=lld")
# set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fuse-ld=mold")
