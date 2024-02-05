add_library(swiftRuntimeUnittest
    RuntimeUnittest.swift
    ExclusivityTests.cpp)
set_target_properties(swiftRuntimeUnittest PROPERTIES Swift_MODULE_NAME RuntimeUnittest)
target_link_libraries(swiftRuntimeUnittest PRIVATE swiftCore swiftShims)

if(SwiftStdlib_ENABLE_LIBRARY_EVOLUTION)
  target_compile_options(swiftRuntimeUnittest PRIVATE
    $<$<COMPILE_LANGUAGE:Swift>:-emit-module-interface-path$<SEMICOLON>${CMAKE_CURRENT_BINARY_DIR}/RuntimeUnittest.swiftinterface>
    $<$<COMPILE_LANGUAGE:Swift>:-emit-private-module-interface-path$<SEMICOLON>${CMAKE_CURRENT_BINARY_DIR}/RuntimeUnittest.private.swiftinterface>
    $<$<COMPILE_LANGUAGE:Swift>:-library-level$<SEMICOLON>api>)
endif()
