

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

conan_message(STATUS "Conan: Using autogenerated Findmagic_enum.cmake")
# Global approach
set(magic_enum_FOUND 1)
set(magic_enum_VERSION "0.8.2")

find_package_handle_standard_args(magic_enum REQUIRED_VARS
                                  magic_enum_VERSION VERSION_VAR magic_enum_VERSION)
mark_as_advanced(magic_enum_FOUND magic_enum_VERSION)


set(magic_enum_INCLUDE_DIRS "/home/jacek/.conan/data/magic_enum/0.8.2/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include")
set(magic_enum_INCLUDE_DIR "/home/jacek/.conan/data/magic_enum/0.8.2/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include")
set(magic_enum_INCLUDES "/home/jacek/.conan/data/magic_enum/0.8.2/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include")
set(magic_enum_RES_DIRS )
set(magic_enum_DEFINITIONS )
set(magic_enum_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(magic_enum_COMPILE_DEFINITIONS )
set(magic_enum_COMPILE_OPTIONS_LIST "" "")
set(magic_enum_COMPILE_OPTIONS_C "")
set(magic_enum_COMPILE_OPTIONS_CXX "")
set(magic_enum_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(magic_enum_LIBRARIES "") # Will be filled later
set(magic_enum_LIBS "") # Same as magic_enum_LIBRARIES
set(magic_enum_SYSTEM_LIBS )
set(magic_enum_FRAMEWORK_DIRS )
set(magic_enum_FRAMEWORKS )
set(magic_enum_FRAMEWORKS_FOUND "") # Will be filled later
set(magic_enum_BUILD_MODULES_PATHS )

conan_find_apple_frameworks(magic_enum_FRAMEWORKS_FOUND "${magic_enum_FRAMEWORKS}" "${magic_enum_FRAMEWORK_DIRS}")

mark_as_advanced(magic_enum_INCLUDE_DIRS
                 magic_enum_INCLUDE_DIR
                 magic_enum_INCLUDES
                 magic_enum_DEFINITIONS
                 magic_enum_LINKER_FLAGS_LIST
                 magic_enum_COMPILE_DEFINITIONS
                 magic_enum_COMPILE_OPTIONS_LIST
                 magic_enum_LIBRARIES
                 magic_enum_LIBS
                 magic_enum_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to magic_enum_LIBS and magic_enum_LIBRARY_LIST
set(magic_enum_LIBRARY_LIST )
set(magic_enum_LIB_DIRS )

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_magic_enum_DEPENDENCIES "${magic_enum_FRAMEWORKS_FOUND} ${magic_enum_SYSTEM_LIBS} ")

conan_package_library_targets("${magic_enum_LIBRARY_LIST}"  # libraries
                              "${magic_enum_LIB_DIRS}"      # package_libdir
                              "${_magic_enum_DEPENDENCIES}"  # deps
                              magic_enum_LIBRARIES            # out_libraries
                              magic_enum_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "magic_enum")                                      # package_name

set(magic_enum_LIBS ${magic_enum_LIBRARIES})

foreach(_FRAMEWORK ${magic_enum_FRAMEWORKS_FOUND})
    list(APPEND magic_enum_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND magic_enum_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${magic_enum_SYSTEM_LIBS})
    list(APPEND magic_enum_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND magic_enum_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(magic_enum_LIBRARIES_TARGETS "${magic_enum_LIBRARIES_TARGETS};")
set(magic_enum_LIBRARIES "${magic_enum_LIBRARIES};")

set(CMAKE_MODULE_PATH "/home/jacek/.conan/data/magic_enum/0.8.2/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/jacek/.conan/data/magic_enum/0.8.2/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_PREFIX_PATH})

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET magic_enum::magic_enum)
        add_library(magic_enum::magic_enum INTERFACE IMPORTED)
        if(magic_enum_INCLUDE_DIRS)
            set_target_properties(magic_enum::magic_enum PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${magic_enum_INCLUDE_DIRS}")
        endif()
        set_property(TARGET magic_enum::magic_enum PROPERTY INTERFACE_LINK_LIBRARIES
                     "${magic_enum_LIBRARIES_TARGETS};${magic_enum_LINKER_FLAGS_LIST}")
        set_property(TARGET magic_enum::magic_enum PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     ${magic_enum_COMPILE_DEFINITIONS})
        set_property(TARGET magic_enum::magic_enum PROPERTY INTERFACE_COMPILE_OPTIONS
                     "${magic_enum_COMPILE_OPTIONS_LIST}")
        
    endif()
endif()

foreach(_BUILD_MODULE_PATH ${magic_enum_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()