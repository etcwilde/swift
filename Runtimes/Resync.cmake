# This CMake script keeps the files in the new standard library build in sync
# with the existing standard library.

# TODO: Once the migration is completed, we can delete this file

cmake_minimum_required(VERSION 3.21)

# Where the standard library lives today
set(StdlibSources "${CMAKE_CURRENT_LIST_DIR}/../stdlib")

message(STATUS "Source dir: ${StdlibSources}")

# Copy the files under the "name" directory in the standard library into the new
# location under Runtimes
function(copy_library_sources name from_prefix to_prefix)
  message(STATUS "${name}[${StdlibSources}/${from_prefix}/${name}] -> ${to_prefix}/${name} ")

  file(GLOB_RECURSE filenames
    FOLLOW_SYMLINKS
    LIST_DIRECTORIES FALSE
    RELATIVE "${StdlibSources}/${from_prefix}"
    "${StdlibSources}/${from_prefix}/${name}/*.swift"
    "${StdlibSources}/${from_prefix}/${name}/*.h"
    "${StdlibSources}/${from_prefix}/${name}/*.cpp"
    "${StdlibSources}/${from_prefix}/${name}/*.c"
    "${StdlibSources}/${from_prefix}/${name}/*.mm"
    "${StdlibSources}/${from_prefix}/${name}/*.m"
    "${StdlibSources}/${from_prefix}/${name}/*.def"
    "${StdlibSources}/${from_prefix}/${name}/*.gyb"
    "${StdlibSources}/${from_prefix}/${name}/*.apinotes"
    "${StdlibSources}/${from_prefix}/${name}/*.yaml")

  foreach(file ${filenames})
    # Get and create the directory
    get_filename_component(dirname ${file} DIRECTORY)
    file(MAKE_DIRECTORY "${to_prefix}/${dirname}")
    file(COPY_FILE
      "${StdlibSources}/${from_prefix}/${file}"         # From
      "${CMAKE_CURRENT_LIST_DIR}/${to_prefix}/${file}"  # To
      RESULT _output
      ONLY_IF_DIFFERENT)
    if(_output)
      message(WARNING "Copy ${from_prefix}/${file} -> ${to_prefix}/${file} Failed: ${_output}")
    endif()
  endforeach()
endfunction()

# Directories in the existing standard library that make up the Core project

# Copy shared core headers
copy_library_sources(include "" "Core")

set(CoreLibs
  LLVMSupport
  SwiftShims)

  # Add these as we get them building
  # core
  # Concurrency
  # SwiftOnoneSUpport
  # CommandLineSupport
  # Demangling
  # runtime)

foreach(library ${CoreLibs})
  copy_library_sources(${library} "public" "Core")
endforeach()

# Directories in the existing standard library build that make up the platform
# overlays

# Directories in the existing standard library build that make up the
# supplemental libraries

# Directories in the existing standard library that make up the testing support
# libraries

set(SupplementalLibs
  Distributed
  Observation)

# set(CoreDires VALUE)
