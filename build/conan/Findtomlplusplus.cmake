

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

conan_message(STATUS "Conan: Using autogenerated Findtomlplusplus.cmake")
# Global approach
set(tomlplusplus_FOUND 1)
set(tomlplusplus_VERSION "3.3.0")

find_package_handle_standard_args(tomlplusplus REQUIRED_VARS
                                  tomlplusplus_VERSION VERSION_VAR tomlplusplus_VERSION)
mark_as_advanced(tomlplusplus_FOUND tomlplusplus_VERSION)


set(tomlplusplus_INCLUDE_DIRS "/home/jacek/.conan/data/tomlplusplus/3.3.0/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include")
set(tomlplusplus_INCLUDE_DIR "/home/jacek/.conan/data/tomlplusplus/3.3.0/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include")
set(tomlplusplus_INCLUDES "/home/jacek/.conan/data/tomlplusplus/3.3.0/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include")
set(tomlplusplus_RES_DIRS )
set(tomlplusplus_DEFINITIONS )
set(tomlplusplus_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(tomlplusplus_COMPILE_DEFINITIONS )
set(tomlplusplus_COMPILE_OPTIONS_LIST "" "")
set(tomlplusplus_COMPILE_OPTIONS_C "")
set(tomlplusplus_COMPILE_OPTIONS_CXX "")
set(tomlplusplus_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(tomlplusplus_LIBRARIES "") # Will be filled later
set(tomlplusplus_LIBS "") # Same as tomlplusplus_LIBRARIES
set(tomlplusplus_SYSTEM_LIBS )
set(tomlplusplus_FRAMEWORK_DIRS )
set(tomlplusplus_FRAMEWORKS )
set(tomlplusplus_FRAMEWORKS_FOUND "") # Will be filled later
set(tomlplusplus_BUILD_MODULES_PATHS )

conan_find_apple_frameworks(tomlplusplus_FRAMEWORKS_FOUND "${tomlplusplus_FRAMEWORKS}" "${tomlplusplus_FRAMEWORK_DIRS}")

mark_as_advanced(tomlplusplus_INCLUDE_DIRS
                 tomlplusplus_INCLUDE_DIR
                 tomlplusplus_INCLUDES
                 tomlplusplus_DEFINITIONS
                 tomlplusplus_LINKER_FLAGS_LIST
                 tomlplusplus_COMPILE_DEFINITIONS
                 tomlplusplus_COMPILE_OPTIONS_LIST
                 tomlplusplus_LIBRARIES
                 tomlplusplus_LIBS
                 tomlplusplus_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to tomlplusplus_LIBS and tomlplusplus_LIBRARY_LIST
set(tomlplusplus_LIBRARY_LIST )
set(tomlplusplus_LIB_DIRS )

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_tomlplusplus_DEPENDENCIES "${tomlplusplus_FRAMEWORKS_FOUND} ${tomlplusplus_SYSTEM_LIBS} ")

conan_package_library_targets("${tomlplusplus_LIBRARY_LIST}"  # libraries
                              "${tomlplusplus_LIB_DIRS}"      # package_libdir
                              "${_tomlplusplus_DEPENDENCIES}"  # deps
                              tomlplusplus_LIBRARIES            # out_libraries
                              tomlplusplus_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "tomlplusplus")                                      # package_name

set(tomlplusplus_LIBS ${tomlplusplus_LIBRARIES})

foreach(_FRAMEWORK ${tomlplusplus_FRAMEWORKS_FOUND})
    list(APPEND tomlplusplus_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND tomlplusplus_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${tomlplusplus_SYSTEM_LIBS})
    list(APPEND tomlplusplus_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND tomlplusplus_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(tomlplusplus_LIBRARIES_TARGETS "${tomlplusplus_LIBRARIES_TARGETS};")
set(tomlplusplus_LIBRARIES "${tomlplusplus_LIBRARIES};")

set(CMAKE_MODULE_PATH "/home/jacek/.conan/data/tomlplusplus/3.3.0/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/jacek/.conan/data/tomlplusplus/3.3.0/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_PREFIX_PATH})

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET tomlplusplus::tomlplusplus)
        add_library(tomlplusplus::tomlplusplus INTERFACE IMPORTED)
        if(tomlplusplus_INCLUDE_DIRS)
            set_target_properties(tomlplusplus::tomlplusplus PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${tomlplusplus_INCLUDE_DIRS}")
        endif()
        set_property(TARGET tomlplusplus::tomlplusplus PROPERTY INTERFACE_LINK_LIBRARIES
                     "${tomlplusplus_LIBRARIES_TARGETS};${tomlplusplus_LINKER_FLAGS_LIST}")
        set_property(TARGET tomlplusplus::tomlplusplus PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     ${tomlplusplus_COMPILE_DEFINITIONS})
        set_property(TARGET tomlplusplus::tomlplusplus PROPERTY INTERFACE_COMPILE_OPTIONS
                     "${tomlplusplus_COMPILE_OPTIONS_LIST}")
        
    endif()
endif()

foreach(_BUILD_MODULE_PATH ${tomlplusplus_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
