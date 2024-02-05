if(NOT SwiftStdlib_SIZEOF_POINTER)
  # This seems to be the most reliable way to actually get the size of a pointer
  file(WRITE ${CMAKE_BINARY_DIR}/cmake/CompilerChecks/ptr_size "__SIZEOF_POINTER__")
  set(size_check_command ${CMAKE_C_COMPILER} -x c -P -E -o - ${CMAKE_BINARY_DIR}/cmake/CompilerChecks/ptr_size)
  if(CMAKE_C_COMPILER_TARGET)
    list(APPEND size_check_command -target ${CMAKE_C_COMPILER_TARGET})
  endif()
  execute_process(
    COMMAND ${size_check_command}
    OUTPUT_VARIABLE ptr_bytes
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  set(SwiftStdlib_SIZEOF_POINTER ${ptr_bytes} CACHE STRING "Size of a pointer in bytes")
  mark_as_advanced(SwiftStdlib_SIZEOF_POINTER)
endif()

if(NOT SwiftStdlib_MODULE_TRIPLE)
  # TODO: This logic should migrate to CMake once CMake supports installing swiftmodules
  set(module_triple_command "${CMAKE_Swift_COMPILER}" -print-target-info)
  if(CMAKE_Swift_COMPILER_TARGET)
    list(APPEND module_triple_command -target ${CMAKE_Swift_COMPILER_TARGET})
  endif()
  execute_process(COMMAND ${module_triple_command} OUTPUT_VARIABLE target_info_json)
  string(JSON module_triple GET "${target_info_json}" "target" "moduleTriple")
  set(SwiftStdlib_MODULE_TRIPLE "${module_triple}" CACHE STRING "swift module triple used for installed swiftmodule and swiftinterface files")
  mark_as_advanced(SwiftStdlib_MODULE_TRIPLE)
endif()

if(NOT SwiftStdlib_SWIFTC_CLANGIMPORTER_RESOURCE_DIR)
  # TODO: We need to separate the concept of compiler resources and the stdlib.
  #       Compiler-resources in the compiler-resource directory are specific to
  #       a given compiler. The headers in `lib/clang/include` and
  #       `lib/swift/clang/include` correspond with that specific copy clang and
  #       should not be mixed. This won't cause modularization issues because
  #       the one copy of clang should never be looking in the other's resource
  #       directory. If there are issues here, something has gone horribly wrong
  #       and you're looking in the wrong place.
  set(module_triple_command "${CMAKE_Swift_COMPILER}" -print-target-info)
  if(CMAKE_Swift_COMPILER_TARGET)
    list(APPEND module_triple_command -target ${CMAKE_Swift_COMPILER_TARGET})
  endif()
  execute_process(COMMAND ${module_triple_command} OUTPUT_VARIABLE target_info_json)
  string(JSON resource_dir GET "${target_info_json}" "paths" "runtimeResourcePath")
  cmake_path(APPEND resource_dir "clang")
  set(SwiftStdlib_SWIFTC_CLANGIMPORTER_RESOURCE_DIR "${resource_dir}" CACHE STRING "Swift clang-importer resource directory")
  mark_as_advanced(SwiftStdlib_SWIFTC_CLANGIMPORTER_RESOURCE_DIR)
endif()
