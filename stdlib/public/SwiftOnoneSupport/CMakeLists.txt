add_library(swiftSwiftOnoneSupport
  SwiftOnoneSupport.swift
  "${CMAKE_SOURCE_DIR}/linker-support/magic-symbols-for-install-name.c")

set_target_properties(swiftSwiftOnoneSupport PROPERTIES Swift_MODULE_NAME SwiftOnoneSupport)
target_link_libraries(swiftSwiftOnoneSupport PRIVATE swiftCore swiftShims)

install(TARGETS swiftSwiftOnoneSupport)
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/SwiftOnoneSupport.swiftmodule"
  DESTINATION "${CMAKE_INSTALL_LIBDIR}/swift/SwiftOnoneSupport.swiftmodule"
  RENAME "${SwiftStdlib_MODULE_TRIPLE}.swiftmodule")

target_compile_options(swiftSwiftOnoneSupport PRIVATE
  "$<$<COMPILE_LANGUAGE:Swift>:-parse-stdlib>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xllvm -sil-inline-generics=false>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -validate-tbd-against-ir=none>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -check-onone-completeness>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -disable-access-control>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -prespecialize-generic-metadata>")

if(SwiftStdlib_ENABLE_LIBRARY_EVOLUTION)
  emit_swift_interface(swiftSwiftOnoneSupport)
  install_swift_interface(swiftSwiftOnoneSupport)
endif()
