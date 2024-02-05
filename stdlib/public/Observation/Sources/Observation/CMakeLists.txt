#===--- CMakeLists.txt - Observation support library ---------------------===#
#
# This source file is part of the Swift.org open source project
#
# Copyright (c) 2023 - 2024 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See https://swift.org/LICENSE.txt for license information
# See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
#
#===----------------------------------------------------------------------===#

add_library(swiftObservation
  Locking.cpp
  Locking.swift
  Observable.swift
  ObservationRegistrar.swift
  ObservationTracking.swift
  ThreadLocal.cpp
  ThreadLocal.swift)
target_link_libraries(swiftObservation PRIVATE swift_Concurrency swiftCore swiftShims)
set_target_properties(swiftObservation PROPERTIES Swift_MODULE_NAME Observation)
target_compile_options(swiftObservation PRIVATE
  $<$<COMPILE_LANGUAGE:Swift>:-nostdimport>
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-enable-experimental-feature Macros>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-enable-experimental-feature ExtensionMacros>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -disable-implicit-string-processing-module-import>")

if(SwiftStdlib_ENABLE_LIBRARY_EVOLUTION)
  emit_swift_interface(swiftObservation)
  install_swift_interface(swiftObservation)
endif()
