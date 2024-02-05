add_library(swiftSwiftPrivateThreadExtras
  SwiftPrivateThreadExtras.swift
  ThreadBarriers.swift)

set_target_properties(swiftSwiftPrivateThreadExtras PROPERTIES
  Swift_MODULE_NAME SwiftPrivateThreadExtras)
target_link_libraries(swiftSwiftPrivateThreadExtras PRIVATE
  swiftSwiftPrivate
  swiftCore
  swiftShims)

if(SwiftStdlib_BUILD_PLATFORM_OVERLAY)
  target_link_libraries(swiftSwiftPrivateThreadExtras PRIVATE PlatformOverlay)
else()
  # TODO: Wire up the module
endif()
