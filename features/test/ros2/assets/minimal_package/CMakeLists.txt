cmake_minimum_required(VERSION 3.8)
project(devcontainers_minimal)

find_package(ament_cmake REQUIRED)

add_executable(devcontainers_minimal_node src/main.cpp)
install(TARGETS devcontainers_minimal_node DESTINATION lib/${PROJECT_NAME})

if(BUILD_TESTING)
  find_package(ament_cmake_gtest REQUIRED)
  ament_add_gtest(devcontainers_minimal_test test/test_main.cpp)
endif()

ament_package()
