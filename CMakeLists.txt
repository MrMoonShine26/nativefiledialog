cmake_minimum_required(VERSION 3.20)
project(NFD C)

# Set C standard
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

# Output directories
set(OUTPUT_DIR "${CMAKE_BINARY_DIR}/bin/${CMAKE_BUILD_TYPE}")

# Define the static library target
add_library(NFD STATIC)

# Set target output directories
set_target_properties(NFD PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${OUTPUT_DIR}
)

# Source files
target_sources(NFD PRIVATE
        src/include/nfd.h
)

# Include directories
target_include_directories(NFD PUBLIC
        src/include
)

# Platform-specific settings
if(WIN32)
    set_source_files_properties(src/nfd_win.cpp PROPERTIES LANGUAGE CXX)
    target_sources(NFD PRIVATE
            src/nfd_common.c
            src/nfd_win.cpp
    )
    target_link_libraries(NFD PRIVATE comdlg32)

elseif(APPLE)
    target_sources(NFD PRIVATE
            src/nfd_common.c
            src/nfd_cocoa.m
    )
    target_link_libraries(NFD PRIVATE "-framework Cocoa")

elseif(UNIX)
    target_sources(NFD PRIVATE
            src/nfd_common.c
            src/nfd_gtk.c
    )
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(GTK REQUIRED gtk+-3.0)
    target_link_libraries(NFD PRIVATE ${GTK_LIBRARIES})
    target_include_directories(NFD PRIVATE ${GTK_INCLUDE_DIRS})
endif()

# Configuration-specific settings
foreach(config IN ITEMS Debug Release Dist)
    string(TOUPPER "${config}" config_upper)

    if(${config_upper} STREQUAL "DEBUG")
        set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -g")
        target_compile_definitions(NFD PRIVATE DEBUG)
    elseif(${config_upper} STREQUAL "RELEASE")
        set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O2")
        target_compile_definitions(NFD PRIVATE RELEASE)
    elseif(${config_upper} STREQUAL "DIST")
        set(CMAKE_C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL} -O3")
        target_compile_definitions(NFD PRIVATE DIST)
    endif()
endforeach()
