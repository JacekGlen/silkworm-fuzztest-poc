

function(conan_message MESSAGE_OUTPUT)
    if(NOT CONAN_CMAKE_SILENT_OUTPUT)
        message(${ARGV${0}})
    endif()
endfunction()


macro(conan_find_apple_frameworks FRAMEWORKS_FOUND FRAMEWORKS FRAMEWORKS_DIRS)
    if(APPLE)
        foreach(_FRAMEWORK ${FRAMEWORKS})
            # https://cmake.org/pipermail/cmake-developers/2017-August/030199.html
            find_library(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND NAMES ${_FRAMEWORK} PATHS ${FRAMEWORKS_DIRS} CMAKE_FIND_ROOT_PATH_BOTH)
            if(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND)
                list(APPEND ${FRAMEWORKS_FOUND} ${CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND})
            else()
                message(FATAL_ERROR "Framework library ${_FRAMEWORK} not found in paths: ${FRAMEWORKS_DIRS}")
            endif()
        endforeach()
    endif()
endmacro()


function(conan_package_library_targets libraries package_libdir deps out_libraries out_libraries_target build_type package_name)
    unset(_CONAN_ACTUAL_TARGETS CACHE)
    unset(_CONAN_FOUND_SYSTEM_LIBS CACHE)
    foreach(_LIBRARY_NAME ${libraries})
        find_library(CONAN_FOUND_LIBRARY NAMES ${_LIBRARY_NAME} PATHS ${package_libdir}
                     NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
        if(CONAN_FOUND_LIBRARY)
            conan_message(STATUS "Library ${_LIBRARY_NAME} found ${CONAN_FOUND_LIBRARY}")
            list(APPEND _out_libraries ${CONAN_FOUND_LIBRARY})
            if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
                # Create a micro-target for each lib/a found
                string(REGEX REPLACE "[^A-Za-z0-9.+_-]" "_" _LIBRARY_NAME ${_LIBRARY_NAME})
                set(_LIB_NAME CONAN_LIB::${package_name}_${_LIBRARY_NAME}${build_type})
                if(NOT TARGET ${_LIB_NAME})
                    # Create a micro-target for each lib/a found
                    add_library(${_LIB_NAME} UNKNOWN IMPORTED)
                    set_target_properties(${_LIB_NAME} PROPERTIES IMPORTED_LOCATION ${CONAN_FOUND_LIBRARY})
                    set(_CONAN_ACTUAL_TARGETS ${_CONAN_ACTUAL_TARGETS} ${_LIB_NAME})
                else()
                    conan_message(STATUS "Skipping already existing target: ${_LIB_NAME}")
                endif()
                list(APPEND _out_libraries_target ${_LIB_NAME})
            endif()
            conan_message(STATUS "Found: ${CONAN_FOUND_LIBRARY}")
        else()
            conan_message(STATUS "Library ${_LIBRARY_NAME} not found in package, might be system one")
            list(APPEND _out_libraries_target ${_LIBRARY_NAME})
            list(APPEND _out_libraries ${_LIBRARY_NAME})
            set(_CONAN_FOUND_SYSTEM_LIBS "${_CONAN_FOUND_SYSTEM_LIBS};${_LIBRARY_NAME}")
        endif()
        unset(CONAN_FOUND_LIBRARY CACHE)
    endforeach()

    if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
        # Add all dependencies to all targets
        string(REPLACE " " ";" deps_list "${deps}")
        foreach(_CONAN_ACTUAL_TARGET ${_CONAN_ACTUAL_TARGETS})
            set_property(TARGET ${_CONAN_ACTUAL_TARGET} PROPERTY INTERFACE_LINK_LIBRARIES "${_CONAN_FOUND_SYSTEM_LIBS};${deps_list}")
        endforeach()
    endif()

    set(${out_libraries} ${_out_libraries} PARENT_SCOPE)
    set(${out_libraries_target} ${_out_libraries_target} PARENT_SCOPE)
endfunction()


include(FindPackageHandleStandardArgs)

conan_message(STATUS "Conan: Using autogenerated FindSQLiteCpp.cmake")
# Global approach
set(SQLiteCpp_FOUND 1)
set(SQLiteCpp_VERSION "3.3.0")

find_package_handle_standard_args(SQLiteCpp REQUIRED_VARS
                                  SQLiteCpp_VERSION VERSION_VAR SQLiteCpp_VERSION)
mark_as_advanced(SQLiteCpp_FOUND SQLiteCpp_VERSION)


set(SQLiteCpp_INCLUDE_DIRS "/home/jacek/.conan/data/sqlitecpp/3.3.0/_/_/package/5df62ddc329c4160b08d8ac4778c8b84e508cfea/include")
set(SQLiteCpp_INCLUDE_DIR "/home/jacek/.conan/data/sqlitecpp/3.3.0/_/_/package/5df62ddc329c4160b08d8ac4778c8b84e508cfea/include")
set(SQLiteCpp_INCLUDES "/home/jacek/.conan/data/sqlitecpp/3.3.0/_/_/package/5df62ddc329c4160b08d8ac4778c8b84e508cfea/include")
set(SQLiteCpp_RES_DIRS )
set(SQLiteCpp_DEFINITIONS )
set(SQLiteCpp_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(SQLiteCpp_COMPILE_DEFINITIONS )
set(SQLiteCpp_COMPILE_OPTIONS_LIST "" "")
set(SQLiteCpp_COMPILE_OPTIONS_C "")
set(SQLiteCpp_COMPILE_OPTIONS_CXX "")
set(SQLiteCpp_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(SQLiteCpp_LIBRARIES "") # Will be filled later
set(SQLiteCpp_LIBS "") # Same as SQLiteCpp_LIBRARIES
set(SQLiteCpp_SYSTEM_LIBS pthread dl m)
set(SQLiteCpp_FRAMEWORK_DIRS )
set(SQLiteCpp_FRAMEWORKS )
set(SQLiteCpp_FRAMEWORKS_FOUND "") # Will be filled later
set(SQLiteCpp_BUILD_MODULES_PATHS "/home/jacek/.conan/data/sqlitecpp/3.3.0/_/_/package/5df62ddc329c4160b08d8ac4778c8b84e508cfea/lib/cmake/conan-official-sqlitecpp-targets.cmake")

conan_find_apple_frameworks(SQLiteCpp_FRAMEWORKS_FOUND "${SQLiteCpp_FRAMEWORKS}" "${SQLiteCpp_FRAMEWORK_DIRS}")

mark_as_advanced(SQLiteCpp_INCLUDE_DIRS
                 SQLiteCpp_INCLUDE_DIR
                 SQLiteCpp_INCLUDES
                 SQLiteCpp_DEFINITIONS
                 SQLiteCpp_LINKER_FLAGS_LIST
                 SQLiteCpp_COMPILE_DEFINITIONS
                 SQLiteCpp_COMPILE_OPTIONS_LIST
                 SQLiteCpp_LIBRARIES
                 SQLiteCpp_LIBS
                 SQLiteCpp_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to SQLiteCpp_LIBS and SQLiteCpp_LIBRARY_LIST
set(SQLiteCpp_LIBRARY_LIST SQLiteCpp)
set(SQLiteCpp_LIB_DIRS "/home/jacek/.conan/data/sqlitecpp/3.3.0/_/_/package/5df62ddc329c4160b08d8ac4778c8b84e508cfea/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_SQLiteCpp_DEPENDENCIES "${SQLiteCpp_FRAMEWORKS_FOUND} ${SQLiteCpp_SYSTEM_LIBS} SQLite::SQLite")

conan_package_library_targets("${SQLiteCpp_LIBRARY_LIST}"  # libraries
                              "${SQLiteCpp_LIB_DIRS}"      # package_libdir
                              "${_SQLiteCpp_DEPENDENCIES}"  # deps
                              SQLiteCpp_LIBRARIES            # out_libraries
                              SQLiteCpp_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "SQLiteCpp")                                      # package_name

set(SQLiteCpp_LIBS ${SQLiteCpp_LIBRARIES})

foreach(_FRAMEWORK ${SQLiteCpp_FRAMEWORKS_FOUND})
    list(APPEND SQLiteCpp_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND SQLiteCpp_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${SQLiteCpp_SYSTEM_LIBS})
    list(APPEND SQLiteCpp_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND SQLiteCpp_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(SQLiteCpp_LIBRARIES_TARGETS "${SQLiteCpp_LIBRARIES_TARGETS};SQLite::SQLite")
set(SQLiteCpp_LIBRARIES "${SQLiteCpp_LIBRARIES};SQLite::SQLite")

set(CMAKE_MODULE_PATH "/home/jacek/.conan/data/sqlitecpp/3.3.0/_/_/package/5df62ddc329c4160b08d8ac4778c8b84e508cfea/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/jacek/.conan/data/sqlitecpp/3.3.0/_/_/package/5df62ddc329c4160b08d8ac4778c8b84e508cfea/" ${CMAKE_PREFIX_PATH})

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET SQLiteCpp::SQLiteCpp)
        add_library(SQLiteCpp::SQLiteCpp INTERFACE IMPORTED)
        if(SQLiteCpp_INCLUDE_DIRS)
            set_target_properties(SQLiteCpp::SQLiteCpp PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${SQLiteCpp_INCLUDE_DIRS}")
        endif()
        set_property(TARGET SQLiteCpp::SQLiteCpp PROPERTY INTERFACE_LINK_LIBRARIES
                     "${SQLiteCpp_LIBRARIES_TARGETS};${SQLiteCpp_LINKER_FLAGS_LIST}")
        set_property(TARGET SQLiteCpp::SQLiteCpp PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     ${SQLiteCpp_COMPILE_DEFINITIONS})
        set_property(TARGET SQLiteCpp::SQLiteCpp PROPERTY INTERFACE_COMPILE_OPTIONS
                     "${SQLiteCpp_COMPILE_OPTIONS_LIST}")
        
        # Library dependencies
        include(CMakeFindDependencyMacro)

        if(NOT SQLite3_FOUND)
            find_dependency(SQLite3 REQUIRED)
        else()
            message(STATUS "Dependency SQLite3 already found")
        endif()

    endif()
endif()

foreach(_BUILD_MODULE_PATH ${SQLiteCpp_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
