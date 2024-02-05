#===--- CMakeLists.txt - Synchronization library ---------------------------===#
#
# This source file is part of the Swift.org open source project
#
# Copyright (c) 2023 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See https://swift.org/LICENSE.txt for license information
# See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
#
#===----------------------------------------------------------------------===#
gyb_expand(Atomics/AtomicIntegers.swift.gyb
  "${SwiftStdlib_SIZEOF_POINTER}/AtomicIntegers.swift"
  FLAGS "-DCMAKE_SIZEOF_VOID_P=${SwiftStdlib_SIZEOF_POINTER}")
gyb_expand(AtomicStorage.swift.gyb
  "${SwiftStdlib_SIZEOF_POINTER}/AtomicStorage.swift"
  FLAGS "-DCMAKE_SIZEOF_VOID_P=${SwiftStdlib_SIZEOF_POINTER}")

add_library(swiftSynchronization
  Atomics/Atomic.swift
  Atomics/AtomicBool.swift
  Atomics/AtomicFloats.swift
  Atomics/AtomicLazyReference.swift
  Atomics/AtomicMemoryOrderings.swift
  Atomics/AtomicOptional.swift
  Atomics/AtomicPointers.swift
  Atomics/AtomicRepresentable.swift
  Atomics/WordPair.swift
  Cell.swift
  Mutex/Mutex.swift
  "${CMAKE_CURRENT_BINARY_DIR}/${SwiftStdlib_SIZEOF_POINTER}/AtomicIntegers.swift"
  "${CMAKE_CURRENT_BINARY_DIR}/${SwiftStdlib_SIZEOF_POINTER}/AtomicStorage.swift")

if(APPLE)
  target_sources(swiftSynchronization PRIVATE Mutex/DarwinImpl.swift)
elseif(LINUX OR ANDROID)
  target_sources(swiftSynchronization PRIVATE
    Mutex/LinuxImpl.swift
    Mutex/SpinLoopHint.swift)
elseif(CMAKE_SYSTEM_NAME STREQUAL "WASM")
  target_sources(swiftSynchronization PRIVATE Mutex/WasmImpl.swift)
elseif(WIN32)
  target_sources(swiftSynchronization PRIVATE Mutex/WindowsImpl.swift)
endif()

add_library(swiftSynchronization
  Atomic.swift
  AtomicBool.swift
  AtomicFloats.swift
  AtomicLazyReference.swift
  AtomicMemoryOrderings.swift
  AtomicOptional.swift
  AtomicPointers.swift
  AtomicRepresentable.swift
  WordPair.swift
  target_compile_options(swiftSynchronization PRIVATE
  -parse-stdlib
  -enable-builtin-module
  "SHELL:-enable-experimental-feature RawLayout"
  "SHELL:-enable-experimental-feature StaticExclusiveOnly"
  "SHELL:-enable-experimental-feature Extern")
target_compile_definitions(swiftSynchronization PRIVATE SWIFT_ENABLE_SYNCHRONIZATION)
set_target_properties(swiftSynchronization PROPERTIES Swift_MODULE_NAME Synchronization)
target_link_libraries(swiftSynchronization PRIVATE swiftCore swiftConcurrency)

install(TARGETS swiftSynchronization)
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/Synchronization.swiftmodule"
  DESTINATION "${CMAKE_INSTALL_LIBDIR}/swift/Synchronization.swiftmodule"
  RENAME "${SwiftStdlib_MODULE_TRIPLE}.swiftmodule")

if(SwiftStdlib_ENABLE_LIBRARY_EVOLUTION)
  emit_swift_interface(swiftSynchronization)
  install_swift_interface(swiftSynchronization)
endif()
