gyb_expand(AtomicInt.swift.gyb
  AtomicInt.swift
  FLAGS "-DCMAKE_SIZEOF_VOID_P=${SwiftStdlib_SIZEOF_POINTER}")

add_library(swiftSwiftPrivate
  SwiftPrivate.swift
  IO.swift
  ShardedAtomicCounter.swift
  "${CMAKE_CURRENT_BINARY_DIR}/AtomicInt.swift"
  "${CMAKE_SOURCE_DIR}/linker-support/magic-symbols-for-install-name.c")
target_link_libraries(swiftSwiftPrivate PRIVATE
  swiftCore
  swiftShims
  PlatformOverlay)
set_target_properties(swiftSwiftPrivate PROPERTIES Swift_MODULE_NAME SwiftPrivate)
target_compile_options(swiftSwiftPrivate PRIVATE
  $<$<COMPILE_LANGUAGE:Swift>:-parse-stdlib>
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -require-explicit-availability=ignore>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -enforce-exclusivity=unchecked>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -disable-access-control>")
>>>>>>> 6800196610e (Build stdlib with correct CMake usage)
