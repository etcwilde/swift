gyb_expand(tgmath.swift.gyb tgmath.swift)
gyb_expand(Darwin.swift.gyb Darwin.swift)

add_library(swiftDarwin SHARED
  Platform.swift
  POSIXError.swift
  MachError.swift
  "${CMAKE_CURRENT_BINARY_DIR}/tgmath.swift"
  "${CMAKE_CURRENT_BINARY_DIR}/Darwin.swift"
  "${CMAKE_SOURCE_DIR}/linker-support/magic-symbols-for-install-name.c")
set_target_properties(swiftDarwin PROPERTIES Swift_MODULE_NAME Darwin)
target_compile_options(swiftDarwin PRIVATE
  $<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend$<SEMICOLON>-disable-objc-attr-requires-foundation-module>)
target_compile_definitions(swiftDarwin PRIVATE
  $<$<BOOL:${SwiftStdlib_ENABLE_REFLECTION}>:SWIFT_ENABLE_REFLECTION>)
target_link_libraries(swiftDarwin PRIVATE swiftCore swiftShims)

if(SwiftStdlib_ENABLE_LIBRARY_EVOLUTION)
  emit_swift_interface(swiftDarwin)
  install_swift_interface(swiftDarwin)
endif()

add_library(PlatformOverlay ALIAS swiftDarwin)
