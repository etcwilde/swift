add_library(swiftSwiftPrivateLibcExtras
  SwiftPrivateLibcExtras.swift
  Subprocess.c
  Subprocess.swift)

set_target_properties(swiftSwiftPrivateLibcExtras PROPERTIES
  Swift_MODULE_NAME SwiftPrivateLibcExtras)
target_link_libraries(swiftSwiftPrivateLibcExtras PRIVATE
  swiftCore
  swiftSwiftPrivate
  $<$<BOOL:${SwiftStdlib_ENABLE_COMMANDLINE_SUPPORT}>:swiftCommandLineSupport>
  swiftShims)

if(SwiftStdlib_BUILD_PLATFORM_OVERLAY)
  target_link_libraries(swiftSwiftPrivateLibcExtras PRIVATE PlatformOverlay)
else()
  # TODO: Wire up finding the module
endif()
