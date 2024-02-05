add_subdirectory(LLVMSupport)
add_subdirectory(SwiftShims/swift/shims)

if(SwiftStdlib_ENABLE_COMMANDLINE_SUPPORT)
  add_subdirectory(CommandLineSupport)
endif()

add_subdirectory(Threading)

block()
  # FIXME: Refactor this. Does this belong in a separate repo so that the compiler
  #        and stdlib can share, or should each have a copy?
  add_library(swiftDemangling STATIC
    "${CMAKE_SOURCE_DIR}/../lib/Demangling/Context.cpp"
    "${CMAKE_SOURCE_DIR}/../lib/Demangling/Demangler.cpp"
    "${CMAKE_SOURCE_DIR}/../lib/Demangling/ManglingUtils.cpp"
    "${CMAKE_SOURCE_DIR}/../lib/Demangling/NodePrinter.cpp"
    "${CMAKE_SOURCE_DIR}/../lib/Demangling/Punycode.cpp"
    "${CMAKE_SOURCE_DIR}/../lib/Demangling/Remangler.cpp"
    "${CMAKE_SOURCE_DIR}/../lib/Demangling/NodeDumper.cpp"
    "${CMAKE_SOURCE_DIR}/../lib/Demangling/Errors.cpp")
  target_compile_definitions(swiftDemangling PRIVATE -DswiftCore_EXPORTS)

  if(SwiftStdlib_ENABLE_CRASH_REPORTER_CLIENT)
    target_sources(swiftDemangling PRIVATE "${CMAKE_SOURCE_DIR}/../lib/Demangling/CrashReporter.cpp")
    target_compile_definitions(swiftDemangling PRIVATE -DSWIFT_HAVE_CRASHREPORDERCLIENT=1)
  endif()

  if(SwiftStdlib_ENABLE_OBJC_INTEROP)
    target_sources(swiftDemangling PRIVATE
    "${CMAKE_SOURCE_DIR}/../lib/Demangling/OldDemangler.cpp"
    "${CMAKE_SOURCE_DIR}/../lib/Demangling/OldRemangler.cpp")
    target_compile_definitions(swiftDemangling PRIVATE -DSWIFT_SUPPORT_OLD_MANGLING=1)
  endif()

  if(SwiftStdlib_ENABLE_TYPE_PRINTING)
    target_compile_definitions(swiftDemangling PRIVATE -DSWIFT_STDLIB_HAS_TYPE_PRINTING)
  endif()

  if(LINUX)
    target_compile_options(swiftDemangling PRIVATE -fno-lto)
  endif()

  if(NOT BUILD_SHARED_LIBS)
    install(TARGETS swiftDemangling)
  endif()
endblock()

# TODO: Figure out what the heck we do with Embedded
#       They're technically different triples, which would suggest an entirely
#       separate CMake invocation is the appropriate approach. Not sure how to
#       get CMake to handle them though since most of it is built on the object
#       deps graph

add_subdirectory(runtime)
add_subdirectory(stubs)
add_subdirectory(core)
add_subdirectory(SwiftOnoneSupport)

if(SwiftStdlib_BUILD_PLATFORM_OVERLAY)
  add_subdirectory(Platform)
endif()

if(SwiftStdlib_ENABLE_CONCURRENCY)
  add_subdirectory(Concurrency)
endif()

if(SwiftStdlib_ENABLE_CXX_INTEROP)
  add_subdirectory(Cxx)
endif()

if(SwiftStdlib_ENABLE_DISTRIBUTED)
  # TODO: This one may need to come after concurrency
  add_subdirectory(distributed)
endif()

if(SwiftStdlib_ENABLE_DIFFERENTIATION)
  add_subdirectory(differentiation)
endif()

if(SwiftStdlib_ENABLE_STRINGPROCESSING)
  add_subdirectory(StringProcessing)
endif()

if(SwiftStdlib_ENABLE_OBSERVATION)
  # TODO... there's nothing in the intermediate folders. Flatten this directory
  #         structure. Leaving it like this to reduce patch size.
  add_subdirectory(Observation/Sources/Observation)
endif()

if(SwiftStdlib_ENABLE_BACKTRACING)
  add_subdirectory(Backtracing)
endif()

if(SwiftStdlib_ENABLE_SYNCHRONIZATION)
  add_subdirectory(Synchronization)
endif()
