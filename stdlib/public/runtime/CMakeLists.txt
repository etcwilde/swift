add_library(swiftRuntime OBJECT
  ../CompatibilityOverride/CompatibilityOverride.cpp
  AnyHashableSupport.cpp
  Array.cpp
  AutoDiffSupport.cpp
  Bincompat.cpp
  BytecodeLayouts.cpp
  Casting.cpp
  CrashReporter.cpp
  Demangle.cpp
  DynamicCast.cpp
  Enum.cpp
  EnvironmentVariables.cpp
  ErrorObjectCommon.cpp
  ErrorObjectNative.cpp
  Errors.cpp
  ErrorDefaultImpls.cpp
  Exclusivity.cpp
  ExistentialContainer.cpp
  Float16Support.cpp
  FoundationSupport.cpp
  FunctionReplacement.cpp
  GenericMetadataBuilder.cpp
  Heap.cpp
  HeapObject.cpp
  ImageInspectionCommon.cpp
  ImageInspectionMachO.cpp
  ImageInspectionELF.cpp
  ImageInspectionCOFF.cpp
  ImageInspectionStatic.cpp
  ImageInspectionWasm.cpp
  SymbolInfo.cpp
  KeyPaths.cpp
  KnownMetadata.cpp
  LibPrespecialized.cpp
  Metadata.cpp
  MetadataLookup.cpp
  Numeric.cpp
  Once.cpp
  Paths.cpp
  Portability.cpp
  ProtocolConformance.cpp
  RefCount.cpp
  ReflectionMirror.cpp
  RuntimeInvocationsTracking.cpp
  SwiftDtoa.cpp
  SwiftTLSContext.cpp
  ThreadingError.cpp
  Tracing.cpp
  AccessibleFunction.cpp)
target_link_libraries(swiftRuntime PRIVATE swiftShims)
# Needed for access to swift_readAtKeyPath and friends
target_compile_definitions(swiftRuntime PRIVATE
  $<$<COMPILE_LANGUAGE:C,CXX>:-DswiftCore_EXPORTS>
  $<$<BOOL:${SwiftStdlib_ENABLE_REFLECTION}>:-DSWIFT_ENABLE_REFLECTION>)

if(WIN32)
  target_sources(swiftRuntime PRIVATE
    Win32.cpp)
endif()

# ObjC sources
target_sources(swiftRuntime PRIVATE
  ErrorObject.mm
  SwiftObject.mm
  SwiftValue.mm
  ReflectionMirrorObjC.mm
  ObjCRuntimeGetImageNameFromClass.mm)

if(SwiftStdlib_ENABLE_LEAK_CHECKER)
  target_compile_definitions(swiftRuntime PRIVATE $<$<COMPILE_LANGUAGE:C,CXX>:-DSWIFT_RUNTIME_ENABLE_LEAK_CHECKER=1>)
  target_sources(swiftRuntime PRIVATE Leaks.mm)
endif()

if(SwiftStdlib_ENABLE_CRASH_REPORTER_CLIENT)
  target_compile_definitions(swiftRuntime PRIVATE $<$<COMPILE_LANGUAGE:C,CXX>:-DSWIFT_HAVE_CRASHREPORTERCLIENT=1>)
endif()

if(SwiftStdlib_CLOBBER_FREED_OBJECT)
  target_compile_definitions(swiftRuntime PRIVATE $<$<COMPILE_LANGUAGE:C,CXX>:-DSWIFT_RUNTIME_CLOBBER_FREED_OBJECTS=1>)
endif()

if(SwiftStdlib_ENABLE_TYPE_PRINTING)
  target_compile_definitions(swiftRuntime PRIVATE -DSWIFT_STDLIB_HAS_TYPE_PRINTING)
endif()

# TODO: Setup backtracer stuff
# if(SWIFT_RUNTIME_FIXED_BACKTRACER_PATH)
#   list(APPEND swift_runtime_compile_flags
#     "-DSWIFT_RUNTIME_FIXED_BACKTRACER_PATH=\"${SWIFT_RUNTIME_FIXED_BACKTRACER_PATH}\"")
# endif()

if(SwiftStdlib_ENABLE_BACKTRACING)
  target_sources(swiftRuntime PRIVATE
    Backtrace.cpp
    BacktraceUtils.cpp
    CrashHandlerMacOS.cpp
    CrashHandlerLinux.cpp)
  target_compile_definitions(swiftRuntime PRIVATE $<$<COMPILE_LANGUAGE:C,CXX>:-DSWIFT_ENABLE_BACKTRACING>)
endif()

# We pull this in separately here because other dylibs will need it, but only
# will have the __tsan_on_initialize called, and on Darwin, RTLD_NEXT can't be
# used to call subsequence dylibs' copies of that.
# FIXME: Refactor so we're not pulling sources from the compiler
target_sources(swiftRuntime PRIVATE ${CMAKE_SOURCE_DIR}/../lib/Threading/ThreadSanitizer.cpp)

# Needed to find ../CompatibilityOverride/CompatibilityOverride.h
target_include_directories(swiftRuntime PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}")
target_compile_definitions(swiftRuntime PRIVATE -DSWIFT_TARGET_LIBRARY_NAME=swiftRuntime -DSWIFT_RUNTIME)

if(WIN32)
  add_library(swiftrt OBJECT SwiftRT-COFF.cpp)
  target_link_libraries(swiftrt PRIVATE swiftShims)
  install(TARGETS swiftrt DESTINATION "${CMAKE_INSTALL_LIBDIR}/swift")
elseif(NOT APPLE)
  add_library(swiftrt OBJECT SwiftRT-ELF-WASM.cpp)
  target_link_libraries(swiftrt PRIVATE swiftShims)
  install(TARGETS swiftrt DESTINATION "${CMAKE_INSTALL_LIBDIR}/swift")
endif()

if(NOT BUILD_SHARED_LIBS)
# Install the static link response files
# TODO: install the static link flags response file
endif()
