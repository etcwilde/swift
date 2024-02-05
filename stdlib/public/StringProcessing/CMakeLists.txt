#===--- CMakeLists.txt - String processing support library -----------------===#
#
# This source file is part of the Swift.org open source project
#
# Copyright (c) 2024 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See https://swift.org/LICENSE.txt for license information
# See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
#
#===------------------------------------------------------------------------===#

# FIXME: StringProcessing should be moved from the experimental repo into the
#        stdlib and built like a normal library.

if(NOT StringProcessing_ROOT_DIR)
  find_path(StringProcessing_ROOT_DIR
    swift-experimental-string-processing
    HINTS "${CMAKE_SOURCE_DIR}/../../"
    REQUIRED)
endif()
set(StringProcessing_SOURCE_DIR
  "${StringProcessing_ROOT_DIR}/swift-experimental-string-processing/Sources")
message(STATUS "StringProcessing found: ${StringProcessing_SOURCE_DIR}")

# Setup _RegexParser
block()
  file(GLOB_RECURSE RegexParser_SOURCES
    "${StringProcessing_SOURCE_DIR}/_RegexParser/*.swift")
  add_library(swift_RegexParser ${RegexParser_SOURCES})
  set_target_properties(swift_RegexParser PROPERTIES Swift_MODULE_NAME _RegexParser)
  target_link_libraries(swift_RegexParser PRIVATE
    swiftCore swiftShims)

  install(TARGETS swift_RegexParser)
  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/_RegexParser.swiftmodule"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/swift/_RegexParser.swiftmodule"
    RENAME "${SwiftStdlib_MODULE_TRIPLE}.swiftmodule")
  if(SwiftStdlib_ENABLE_LIBRARY_EVOLUTION)
    emit_swift_interface(swift_RegexParser)
    install_swift_interface(swift_RegexParser)
  endif()
endblock()

# Setup _StringProcessing
block()
  file(GLOB_RECURSE StringProcessing_SOURCES
    "${StringProcessing_SOURCE_DIR}/_StringProcessing/*.swift"
    "${StringProcessing_SOURCE_DIR}/_CUnicode/*.c")

  add_library(swift_StringProcessing ${StringProcessing_SOURCES})
  set_target_properties(swift_StringProcessing PROPERTIES Swift_MODULE_NAME _StringProcessing)
  target_link_libraries(swift_StringProcessing PRIVATE
    swiftCore swiftShims swift_RegexParser)

  install(TARGETS swift_StringProcessing)
  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/_StringProcessing.swiftmodule"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/swift/_StringProcessing.swiftmodule"
    RENAME "${SwiftStdlib_MODULE_TRIPLE}.swiftmodule")

  if(SwiftStdlib_ENABLE_LIBRARY_EVOLUTION)
    emit_swift_interface(swift_StringProcessing)
    install_swift_interface(swift_StringProcessing)
  endif()
endblock()

# Setup RegexBuilder
block()
  file(GLOB_RECURSE RegexBuilder_SOURCES
    "${StringProcessing_SOURCE_DIR}/RegexBuilder/*.swift")

  add_library(swiftRegexBuilder ${RegexBuilder_SOURCES})
  set_target_properties(swiftRegexBuilder PROPERTIES Swift_MODULE_NAME RegexBuilder)
  target_link_libraries(swiftRegexBuilder PRIVATE
    swiftCore swiftShims swift_StringProcessing)

  install(TARGETS swiftRegexBuilder)
  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/RegexBuilder.swiftmodule"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/swift/RegexBuilder.swiftmodule"
    RENAME "${SwiftStdlib_MODULE_TRIPLE}.swiftmodule")

  if(SwiftStdlib_ENABLE_LIBRARY_EVOLUTION)
    emit_swift_interface(swiftRegexBuilder)
    install_swift_interface(swiftRegexBuilder)
  endif()
endblock()
