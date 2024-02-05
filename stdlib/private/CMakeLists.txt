if(SwiftStdlib_ENABLE_TESTING)
  add_subdirectory(SwiftPrivate)
  add_subdirectory(SwiftPrivateThreadExtras)
  add_subdirectory(SwiftPrivateLibcExtras)
  add_subdirectory(StdlibUnittest)
  add_subdirectory(RuntimeUnittest)

  # TODO: Figure out how exactly we want to connect up the test suites
  #       Using ctest for the time being though.
  #
  # FIXME: The compiler and stdlib test suites are pretty tightly entwined.
  #        For now, anything that imports the stdlib tests and is an executable
  #        test is a test for the stdlib testing.

  add_executable(ExclusivityTests "${CMAKE_SOURCE_DIR}/../validation-test/Runtime/ExclusivityTest.swift")
  target_link_libraries(ExclusivityTests
    swiftStdlibUnittest
    swiftRuntimeUnittest
    swiftSwiftPrivate
    swiftSwiftPrivateLibcExtras
    swiftSwiftPrivateThreadExtras
    swiftCore
    PlatformOverlay)
endif()
