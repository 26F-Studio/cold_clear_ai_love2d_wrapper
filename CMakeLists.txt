cmake_minimum_required(VERSION 3.18)


### Create project
project(CCloader C)


### Set C standard
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD 11 CACHE STRING "Cmake c standard" FORCE)


### Print
message(STATUS "C standard is ${CMAKE_C_STANDARD}")
message(STATUS "Processor is ${CMAKE_SYSTEM_PROCESSOR}")

### Detect libs
if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/lib/libcold_clear.a")
    set(COLD_CLEAR_LIB "${CMAKE_CURRENT_SOURCE_DIR}/lib/libcold_clear.a")
else ()
    message(FATAL_ERROR "Could not find libcold_clear.a in the ./lib/ directory")
endif ()

if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/lib/libluajit.a")
    set(LUA_JIT_LIB "${CMAKE_CURRENT_SOURCE_DIR}/lib/libluajit.a")
else ()
    message(FATAL_ERROR "Could not find libcold_clear.a in the ./lib/ directory")
endif ()


### Build static library
add_library(${PROJECT_NAME} cold_clear_wrapper.c)

find_library(FRAMEWORK_Security
        NAMES Security
        PATHS ${CMAKE_OSX_SYSROOT}/System/Library
        PATH_SUFFIXES Frameworks
        NO_DEFAULT_PATH)

target_link_libraries(${PROJECT_NAME} PRIVATE ${FRAMEWORK_Security} ${COLD_CLEAR_LIB} ${LUA_JIT_LIB})

target_include_directories(${PROJECT_NAME} PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
        ${CMAKE_CURRENT_SOURCE_DIR}/cold-clear/c-api)


### install static library
set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}")
install(TARGETS ${PROJECT_NAME} EXPORT ${PROJECT_NAME}Config
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        RUNTIME DESTINATION bin)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cc.lua DESTINATION lua/)