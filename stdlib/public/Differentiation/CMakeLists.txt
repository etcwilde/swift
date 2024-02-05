#===--- CMakeLists.txt - Differentiable programming support library ------===#
#
# This source file is part of the Swift.org open source project
#
# Copyright (c) 2019 - 2020 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See https://swift.org/LICENSE.txt for license information
# See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
#
#===----------------------------------------------------------------------===#

if(NOT SwiftStdlib_ENABLE_EXTRA_SOURCES OR NOT SwiftStdlib_ENABLE_REFLECTION)
  message(FATAL_ERROR "swift_Differentiation requires SwiftStdlib_ENABLE_EXTRA_SOURCES")
endif()

gyb_expand(FloatingPointDifferentiation.swift.gyb
    "${SwiftStdlib_SIZEOF_POINTER}/FloatingPointDifferentiation.swift"
    FLAGS "-DCMAKE_SIZEOF_VOID_P=${SwiftStdlib_SIZEOF_POINTER}")
gyb_expand(TgmathDerivatives.swift.gyb
   "${SwiftStdlib_SIZEOF_POINTER}/TgmathDerivatives.swift"
   FLAGS "-DCMAKE_SIZEOF_VOID_P=${SwiftStdlib_SIZEOF_POINTER}")

add_library(swift_Differentiation
  Differentiable.swift
  DifferentialOperators.swift
  DifferentiationUtilities.swift
  AnyDifferentiable.swift
  ArrayDifferentiation.swift
  OptionalDifferentiation.swift
  "${CMAKE_CURRENT_BINARY_DIR}/${SwiftStdlib_SIZEOF_POINTER}/FloatingPointDifferentiation.swift"
  "${CMAKE_CURRENT_BINARY_DIR}/${SwiftStdlib_SIZEOF_POINTER}/TgmathDerivatives.swift")
set_target_properties(swift_Differentiation PROPERTIES Swift_MODULE_NAME _Differentiation)
target_compile_options(swift_Differentiation PRIVATE
  $<$<COMPILE_LANGUAGE:Swift>:-parse-stdlib>
  $<$<COMPILE_LANGUAGE:Swift>:-nostdimport>)
target_link_libraries(swift_Differentiation PRIVATE
  swiftCore
  swiftShims
  PlatformOverlay)

if(SwiftStdlib_ENABLE_VECTOR_TYPES)
  gyb_expand(SIMDDifferentiation.swift.gyb
    "${SwiftStdlib_SIZEOF_POINTER}/SIMDDifferentiation.swift"
    FLAGS "-DCMAKE_SIZEOF_VOID_P=${SwiftStdlib_SIZEOF_POINTER}")
  target_sources(swift_Differentiation PRIVATE
    "${CMAKE_CURRENT_BINARY_DIR}/${SwiftStdlib_SIZEOF_POINTER}/SIMDDifferentiation.swift")
endif()

install(TARGETS swift_Differentiation)
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/_Differentiation.swiftmodule"
  DESTINATION "${CMAKE_INSTALL_LIBDIR}/swift/_Differentiation.swiftmodule"
  RENAME "${SwiftStdlib_MODULE_TRIPLE}.swiftmodule")

if(SwiftStdlib_ENABLE_LIBRARY_EVOLUTION)
  emit_swift_interface(swift_Differentiation)
  install_swift_interface(swift_Differentiation)
endif()
