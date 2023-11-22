

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

conan_message(STATUS "Conan: Using autogenerated Findasio-grpc.cmake")
# Global approach
set(asio-grpc_FOUND 1)
set(asio-grpc_VERSION "2.4.0")

find_package_handle_standard_args(asio-grpc REQUIRED_VARS
                                  asio-grpc_VERSION VERSION_VAR asio-grpc_VERSION)
mark_as_advanced(asio-grpc_FOUND asio-grpc_VERSION)


set(asio-grpc_INCLUDE_DIRS "/home/jacek/.conan/data/asio-grpc/2.4.0/_/_/package/389aa2c1555e8e32714f724dd412481b22d9bf3b/include")
set(asio-grpc_INCLUDE_DIR "/home/jacek/.conan/data/asio-grpc/2.4.0/_/_/package/389aa2c1555e8e32714f724dd412481b22d9bf3b/include")
set(asio-grpc_INCLUDES "/home/jacek/.conan/data/asio-grpc/2.4.0/_/_/package/389aa2c1555e8e32714f724dd412481b22d9bf3b/include")
set(asio-grpc_RES_DIRS )
set(asio-grpc_DEFINITIONS "-DAGRPC_BOOST_ASIO")
set(asio-grpc_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(asio-grpc_COMPILE_DEFINITIONS "AGRPC_BOOST_ASIO")
set(asio-grpc_COMPILE_OPTIONS_LIST "" "")
set(asio-grpc_COMPILE_OPTIONS_C "")
set(asio-grpc_COMPILE_OPTIONS_CXX "")
set(asio-grpc_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(asio-grpc_LIBRARIES "") # Will be filled later
set(asio-grpc_LIBS "") # Same as asio-grpc_LIBRARIES
set(asio-grpc_SYSTEM_LIBS )
set(asio-grpc_FRAMEWORK_DIRS )
set(asio-grpc_FRAMEWORKS )
set(asio-grpc_FRAMEWORKS_FOUND "") # Will be filled later
set(asio-grpc_BUILD_MODULES_PATHS "/home/jacek/.conan/data/asio-grpc/2.4.0/_/_/package/389aa2c1555e8e32714f724dd412481b22d9bf3b/lib/cmake/asio-grpc/AsioGrpcProtobufGenerator.cmake")

conan_find_apple_frameworks(asio-grpc_FRAMEWORKS_FOUND "${asio-grpc_FRAMEWORKS}" "${asio-grpc_FRAMEWORK_DIRS}")

mark_as_advanced(asio-grpc_INCLUDE_DIRS
                 asio-grpc_INCLUDE_DIR
                 asio-grpc_INCLUDES
                 asio-grpc_DEFINITIONS
                 asio-grpc_LINKER_FLAGS_LIST
                 asio-grpc_COMPILE_DEFINITIONS
                 asio-grpc_COMPILE_OPTIONS_LIST
                 asio-grpc_LIBRARIES
                 asio-grpc_LIBS
                 asio-grpc_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to asio-grpc_LIBS and asio-grpc_LIBRARY_LIST
set(asio-grpc_LIBRARY_LIST )
set(asio-grpc_LIB_DIRS )

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_asio-grpc_DEPENDENCIES "${asio-grpc_FRAMEWORKS_FOUND} ${asio-grpc_SYSTEM_LIBS} gRPC::grpc++_unsecure;Boost::headers;Boost::container")

conan_package_library_targets("${asio-grpc_LIBRARY_LIST}"  # libraries
                              "${asio-grpc_LIB_DIRS}"      # package_libdir
                              "${_asio-grpc_DEPENDENCIES}"  # deps
                              asio-grpc_LIBRARIES            # out_libraries
                              asio-grpc_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "asio-grpc")                                      # package_name

set(asio-grpc_LIBS ${asio-grpc_LIBRARIES})

foreach(_FRAMEWORK ${asio-grpc_FRAMEWORKS_FOUND})
    list(APPEND asio-grpc_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND asio-grpc_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${asio-grpc_SYSTEM_LIBS})
    list(APPEND asio-grpc_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND asio-grpc_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(asio-grpc_LIBRARIES_TARGETS "${asio-grpc_LIBRARIES_TARGETS};gRPC::grpc++_unsecure;Boost::headers;Boost::container")
set(asio-grpc_LIBRARIES "${asio-grpc_LIBRARIES};gRPC::grpc++_unsecure;Boost::headers;Boost::container")

set(CMAKE_MODULE_PATH "/home/jacek/.conan/data/asio-grpc/2.4.0/_/_/package/389aa2c1555e8e32714f724dd412481b22d9bf3b/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/jacek/.conan/data/asio-grpc/2.4.0/_/_/package/389aa2c1555e8e32714f724dd412481b22d9bf3b/" ${CMAKE_PREFIX_PATH})

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET asio-grpc::asio-grpc)
        add_library(asio-grpc::asio-grpc INTERFACE IMPORTED)
        if(asio-grpc_INCLUDE_DIRS)
            set_target_properties(asio-grpc::asio-grpc PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${asio-grpc_INCLUDE_DIRS}")
        endif()
        set_property(TARGET asio-grpc::asio-grpc PROPERTY INTERFACE_LINK_LIBRARIES
                     "${asio-grpc_LIBRARIES_TARGETS};${asio-grpc_LINKER_FLAGS_LIST}")
        set_property(TARGET asio-grpc::asio-grpc PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     ${asio-grpc_COMPILE_DEFINITIONS})
        set_property(TARGET asio-grpc::asio-grpc PROPERTY INTERFACE_COMPILE_OPTIONS
                     "${asio-grpc_COMPILE_OPTIONS_LIST}")
        
        # Library dependencies
        include(CMakeFindDependencyMacro)

        if(NOT gRPC_FOUND)
            find_dependency(gRPC REQUIRED)
        else()
            message(STATUS "Dependency gRPC already found")
        endif()


        if(NOT Boost_FOUND)
            find_dependency(Boost REQUIRED)
        else()
            message(STATUS "Dependency Boost already found")
        endif()


        if(NOT Boost_FOUND)
            find_dependency(Boost REQUIRED)
        else()
            message(STATUS "Dependency Boost already found")
        endif()

    endif()
endif()

foreach(_BUILD_MODULE_PATH ${asio-grpc_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
