#===--- CMakeLists.txt - Concurrency support library ---------------------===#
#
# This source file is part of the Swift.org open source project
#
# Copyright (c) 2019 - 2024 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See https://swift.org/LICENSE.txt for license information
# See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
#
#===----------------------------------------------------------------------===#

add_library(swiftDistributed
  DistributedActor.cpp
  DistributedActor.swift
  DistributedActorSystem.swift
  DistributedAssertions.swift
  DistributedDefaultExecutor.swift
  DistributedMacros.swift
  DistributedMetadata.swift
  LocalTestingDistributedActorSystem.swift)
target_link_libraries(swiftDistributed PRIVATE swiftCore swift_Concurrency swiftShims)
target_compile_options(swiftDistributed PRIVATE
  $<$<COMPILE_LANGUAGE:Swift>:-parse-stdlib>
  $<$<COMPILE_LANGUAGE:Swift>:-nostdimport>)
set_target_properties(swiftDistributed PROPERTIES Swift_MODULE_NAME Distributed)
install(TARGETS swiftDistributed)
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/Distributed.swiftmodule"
  DESTINATION "${CMAKE_INSTALL_LIBDIR}/swift/Distributed.swiftmodule"
  RENAME "${SwiftStdlib_MODULE_TRIPLE}.swiftmodule")

if(SwiftStdlib_ENABLE_LIBRARY_EVOLUTION)
  emit_swift_interface(swiftDistributed)
  install_swift_interface(swiftDistributed)
endif()
