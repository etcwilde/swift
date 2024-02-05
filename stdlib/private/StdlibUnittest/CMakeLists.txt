add_library(swiftStdlibUnittest
  StdlibUnittest.swift
  CheckStrideable.swift
  InspectValue.cpp
  InspectValue.swift
  InterceptTraps.cpp
  LifetimeTracked.swift
  MinimalTypes.swift
  OpaqueIdentityFunctions.cpp
  OpaqueIdentityFunctions.swift
  RaceTest.swift
  Statistics.swift
  StdlibCoreExtras.swift
  StringConvertible.swift
  StringTestHelpers.swift
  TestHelpers.swift
  TypeIndexed.swift)

set_source_files_properties(InspectValue.cpp PROPERTIES COMPILE_FLAGS -std=c++17)
set_target_properties(swiftStdlibUnittest PROPERTIES Swift_MODULE_NAME StdlibUnittest)
target_link_libraries(swiftStdlibUnittest
  PRIVATE
    swiftCore
    swiftShims
    swiftOnoneSupport
    swift_Concurrency
    swiftSwiftPrivate
    swiftSwiftPrivateThreadExtras
    swiftSwiftPrivateLibcExtras
    swift_StringProcessing
    swiftObservation
    PlatformOverlay)
target_compile_options(swiftStdlibUnittest PRIVATE
  $<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend$<SEMICOLON>-disable-objc-attr-requires-foundation-module>
  $<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend$<SEMICOLON>-disable-availability-checking>
  $<$<AND:$<COMPILE_LANGUAGE:Swift>,$<BOOL:${SwiftStdlib_ENABLE_LIBRARY_EVOLUTION}>>:-library-level$<SEMICOLON>api>)

if(APPLE)
  # We need the Foundation, CoreFoundation, and Dispatch swift overlays in
  # order to build the tests. They're located next to the SDK copy of the Swift
  # shims, so if we include them in the search paths, we'll have two copies of
  # the shims and explode. Copy the needed SDK content out of the SDK into an
  # isolated spot so that we don't have conflicting modules.
  # TODO: pretty sure this violates the SDK licensing, but we need some way to
  #       separate the SDK content from the Swift stdlib in the SDK.
  #       We should probably use a VFS overlay to do this in the future though.
  add_custom_target(COPY_TEST_SDK_CONTENT
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/SDKContent
    COMMAND ${CMAKE_COMMAND} -E copy_directory_if_different ${CMAKE_OSX_SYSROOT}/usr/lib/swift/Dispatch.swiftmodule ${CMAKE_BINARY_DIR}/SDKContent/Dispatch.swiftmodule
    COMMAND ${CMAKE_COMMAND} -E copy_directory_if_different ${CMAKE_OSX_SYSROOT}/usr/lib/swift/ObjectiveC.swiftmodule ${CMAKE_BINARY_DIR}/SDKContent/ObjectiveC.swiftmodule
    COMMAND ${CMAKE_COMMAND} -E copy_directory_if_different ${CMAKE_OSX_SYSROOT}/usr/lib/swift/XPC.swiftmodule ${CMAKE_BINARY_DIR}/SDKContent/XPC.swiftmodule
    COMMAND ${CMAKE_COMMAND} -E copy_directory_if_different ${CMAKE_OSX_SYSROOT}/usr/lib/swift/CoreFoundation.swiftmodule ${CMAKE_BINARY_DIR}/SDKContent/CoreFoundation.swiftmodule
    COMMAND ${CMAKE_COMMAND} -E copy_directory_if_different ${CMAKE_OSX_SYSROOT}/usr/lib/swift/IOKit.swiftmodule ${CMAKE_BINARY_DIR}/SDKContent/IOKit.swiftmodule
    COMMAND ${CMAKE_COMMAND} -E copy_directory_if_different ${CMAKE_OSX_SYSROOT}/usr/lib/swift/OSLog.swiftmodule ${CMAKE_BINARY_DIR}/SDKContent/OSLog.swiftmodule
    COMMAND ${CMAKE_COMMAND} -E copy_directory_if_different ${CMAKE_OSX_SYSROOT}/usr/lib/swift/System.swiftmodule ${CMAKE_BINARY_DIR}/SDKContent/System.swiftmodule
    COMMAND ${CMAKE_COMMAND} -E copy_directory_if_different ${CMAKE_OSX_SYSROOT}/usr/lib/swift/_System_Foundation.swiftmodule ${CMAKE_BINARY_DIR}/SDKContent/_System_Foundation.swiftmodule
    )
  add_dependencies(swiftStdlibUnittest COPY_TEST_SDK_CONTENT)
  target_include_directories(swiftStdlibUnittest PRIVATE
    "${CMAKE_BINARY_DIR}/SDKContent"
    "${CMAKE_OSX_SYSROOT}/usr/include")
  target_compile_options(swiftStdlibUnittest PRIVATE
    $<$<COMPILE_LANGUAGE:Swift>:SHELL:-F$<SEMICOLON>${CMAKE_OSX_SYSROOT}/System/Library/Frameworks>)
endif()
