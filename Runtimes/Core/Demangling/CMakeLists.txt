# FIXME: Refactor demangling library so that we aren't pulling sources from
#        the compiler.
add_library(swiftDemangling OBJECT
  "${PROJECT_SOURCE_DIR}/../../lib/Demangling/Context.cpp"
  "${PROJECT_SOURCE_DIR}/../../lib/Demangling/Demangler.cpp"
  "${PROJECT_SOURCE_DIR}/../../lib/Demangling/ManglingUtils.cpp"
  "${PROJECT_SOURCE_DIR}/../../lib/Demangling/NodePrinter.cpp"
  "${PROJECT_SOURCE_DIR}/../../lib/Demangling/Punycode.cpp"
  "${PROJECT_SOURCE_DIR}/../../lib/Demangling/Remangler.cpp"
  "${PROJECT_SOURCE_DIR}/../../lib/Demangling/NodeDumper.cpp"
  "${PROJECT_SOURCE_DIR}/../../lib/Demangling/Errors.cpp")
target_compile_definitions(swiftDemangling PRIVATE swiftCore_EXPORTS
  -DSWIFT_SUPPORT_OLD_MANGLING=$<BOOL:${SwiftCore_ENABLE_OBJC_INTEROP}>
  $<$<BOOL:${SwiftCore_ENABLE_TYPE_PRINTING}>:-DSWIFT_STDLIB_HAS_TYPE_PRINTING>
  -DSWIFT_HAVE_CRASHREPORTERCLIENT=$<BOOL:${SwiftCore_ENABLE_CRASH_REPORTER_CLIENT}>)

target_include_directories(swiftDemangling
  PRIVATE
    "${PROJECT_SOURCE_DIR}/../../include"
    "${PROJECT_BINARY_DIR}/include")

if(SwiftCore_ENABLE_CRASH_REPORTER_CLIENT)
  target_sources(swiftDemangling PRIVATE
    "${PROJECT_SOURCE_DIR}/../../lib/Demangling/CrashReporter.cpp")
  target_link_libraries(swiftDemangling PRIVATE swiftShims)
endif()

if(SwiftCore_ENABLE_OBJC_INTEROP)
  target_sources(swiftDemangling PRIVATE
    "${PROJECT_SOURCE_DIR}/../../lib/Demangling/OldDemangler.cpp"
    "${PROJECT_SOURCE_DIR}/../../lib/Demangling/OldRemangler.cpp")
endif()

if(LINUX)
  target_compile_options(swiftDemangling PRIVATE -fno-lto)
endif()

if(NOT BUILD_SHARED_LIBS)
  install(TARGETS swiftDemangling)
endif()
