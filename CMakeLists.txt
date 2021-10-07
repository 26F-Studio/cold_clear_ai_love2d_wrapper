cmake_minimum_required(VERSION 3.18)


### Create project
project(CCloader C)


### Set C standard
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD 11 CACHE STRING "Cmake c standard" FORCE)


### Print
message(STATUS "C standard is ${CMAKE_C_STANDARD}")
message(STATUS "Processor is ${CMAKE_SYSTEM_PROCESSOR}")


### Detect cold_clear lib
if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/lib/libcold_clear.a")
    set(COLD_CLEAR_LIB "${CMAKE_CURRENT_SOURCE_DIR}/lib/libcold_clear.a")
else ()
    message(FATAL_ERROR "Could not find libcold_clear.a in the ./lib/ directory")
endif ()


### Build shared library
add_library(${PROJECT_NAME} SHARED cold_clear_wrapper.c)

target_link_libraries(${PROJECT_NAME} PRIVATE ${COLD_CLEAR_LIB})

target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)


### install shared library
set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}")
install(TARGETS ${PROJECT_NAME} EXPORT ${PROJECT_NAME}Config
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        RUNTIME DESTINATION bin)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cc.lua DESTINATION lua/)