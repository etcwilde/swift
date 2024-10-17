add_library(swiftSwiftOnoneSupport
  SwiftOnoneSupport.swift)

# FIXME: The driver is injecting
#   '-experimental-skip-non-inlinable-function-bodies-without-types' on the
#   frontend invocation here, resulting in the warning about the
#   'experimental-skip-*-function-bodies' flag.

set_target_properties(swiftSwiftOnoneSupport PROPERTIES Swift_MODULE_NAME SwiftOnoneSupport)
target_compile_options(swiftSwiftOnoneSupport PRIVATE
  $<$<COMPILE_LANGUAGE:Swift>:-parse-stdlib>
  $<$<COMPILE_LANGUAGE:Swift>:-nostdimport>
  $<$<COMPILE_LANGUAGE:Swift>:-explicit-module-build>
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -disable-implicit-concurrency-module-import>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -disable-implicit-backtracing-module-import>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -disable-implicit-string-processing-module-import>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -check-onone-completeness>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -disable-access-control>")
target_link_libraries(swiftSwiftOnoneSupport PRIVATE swiftCore swiftShims)

install(TARGETS swiftSwiftOnoneSupport)
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/SwiftOnoneSupport.swiftmodule"
  DESTINATION "${CMAKE_INSTALL_LIBDIR}/swift/SwiftOnoneSupport.swiftmodule"
  RENAME "${SwiftCore_MODULE_TRIPLE}.swiftmodule")
emit_swift_interface(swiftSwiftOnoneSupport)
install_swift_interface(swiftSwiftOnoneSupport)
