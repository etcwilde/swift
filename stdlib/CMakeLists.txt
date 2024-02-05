# TODO:
#   - embedded stdlib builds          ** -- -Xfrontend -emit-empty-object-file
#   - TBD-only builds                 **
#   - SDK overlay
#   - Catalyst support                *
#   - install *.abi.json, swiftdoc, and swiftsourceinfo
#   - Cxx interop
#   - Backtracing
#   - Missing Defines
#     - SWIFT_STDLIB_HAS_LOCALE
#     - SWIFT_STDLIB_HAS_STDIN
#     - SWIFT_OBJC_INTEROP
#     - SWIFT_PTRAUTH
#     - SWIFT_STDLIB_HAS_ASL
#     - SWIFT_STDLIB_HAS_MALLOC_TYPE
#     - SWIFT_STDLIB_HAS_ENVIRON
#     - SWIFT_RUNTIME_OS_VERSIONING
#     - SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
#   - Find flag causing '<unknown>:0: warning: module 'SwiftOnoneSupport' cannot be built with any of the -experimental-skip-*-function-bodies* flags; they have been automatically disabled'
#   - Fully isolate build against SDK swiftShims
#     Modularization sees both the one we just built and the one from the SDK.
#     swiftShims should actually be a compiler resource and come from the
#     compiler. (fixed with explicit modules)
#     - Differentiation
#     - swiftCxx

cmake_minimum_required(VERSION 3.26...3.29)

set(CMAKE_Swift_LANGUAGE_VERSION 5)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules/CMakeWorkarounds.cmake)
project(SwiftStdlib LANGUAGES Swift C CXX VERSION 6.1)

# Ensure we're standalone for now so that we're not pulling in any LLVM
# dependencies. We can drop this requirement once we're certain that things are
# working correctly without any unexpected dependencies.
if(NOT "${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_SOURCE_DIR}")
  message(FATAL_ERROR "Swift stdlib must built as a standalone project")
endif()

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${SwiftStdlib_BINARY_DIR}/lib")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${SwiftStdlib_BINARY_DIR}/bin")

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")

include(GNUInstallDirs)
include(CompilerChecks)
include(gyb)
include(PlatformInfo)
include(AvailabilityMacros)
include(EmitSwiftInterface)

option(SwiftStdlib_ENABLE_TESTING "Enable Swift stdlib testing targets" OFF)

option(SwiftStdlib_ENABLE_CRASH_REPORTER_CLIENT "" OFF)

option(SwiftStdlib_ENABLE_OBJC_INTEROP "" OFF)

option(SwiftStdlib_ENABLE_TYPE_PRINTING "" OFF)

option(SwiftStdlib_ENABLE_EMBEDDED "Include Embedded stdlib targets" OFF)

option(SwiftStdlib_ENABLE_LEAK_CHECKER "" OFF)

option(SwiftStdlib_CLOBBER_FREED_OBJECT "" OFF)

option(SwiftStdlib_ENABLE_ASYNC_FP "Emit asynchronous framepointer support in swiftConcurrency" OFF)

option(SwiftStdlib_ENABLE_EXTRA_CHECKS "Enable extra checking in the stdlib" OFF)

option(SwiftStdlib_ENABLE_VECTOR_TYPES "Include vector types in built stdlib" ON)

option(SwiftStdlib_ENABLE_COMMANDLINE_SUPPORT "Enable swift CommandLine support" OFF)

option(SwiftStdlib_ENABLE_PRESPECIALIZATION "Enable generic metadata prespecialization" OFF)
if(SwiftStdlib_ENABLE_PRESPECIALIZATION)
  check_compiler_flag(Swift "-Xfrontend -prespecialize-generic-metadata" HAVE_PRESPECIALIZE_GENERIC_METADATA)
  if(NOT HAVE_PRESPECIALIZE_GENERIC_METADATA)
    message(WARNING "Generic metadata prespecialization not supported by Swift compiler")
  else()
    add_compile_options($<$<COMPILE_LANGUAGE:Swift>:-Xfrontend$<SEMICOLON>-prespecialize-generic-metadata>)
  endif()
endif()

option(SwiftStdlib_ENABLE_LIBRARY_EVOLUTION "Enable library evolution" OFF)
if(SwiftStdlib_ENABLE_LIBRARY_EVOLUTION)
  add_compile_options($<$<COMPILE_LANGUAGE:Swift>:-enable-library-evolution>)
  add_definitions(-DSWIFT_LIBRARY_EVOLUTION)
endif()

option(SwiftStdlib_ENABLE_EXTRA_SOURCES "Enable non-essential sources in swiftCore" ON)

option(SwiftStdlib_ENABLE_REFLECTION "Enable Mirror in swiftCore" ON)

# TODO: Finish CXX interop support and turn this back on
option(SwiftStdlib_ENABLE_CXX_INTEROP "Include CXX interop library targets" OFF)

option(SwiftStdlib_ENABLE_CONCURRENCY "Enable swift concurrency build targets" ON)

option(SwiftStdlib_ENABLE_DIFFERENTIATION "Include differentiation build target" OFF)

#TODO: Shims are conflicting with the copy in the SDK and resulting in a build
#      failure
option(SwiftStdlib_ENABLE_DISTRIBUTED "Include swiftDistributed build targets" OFF)

option(SwiftStdlib_ENABLE_OBSERVATION "Include swiftObservation build targets" ON)

option(SwiftStdlib_ENABLE_BACKTRACING "Include Swift backtracing build targets" OFF)

option(SwiftStdlib_ENABLE_STRINGPROCESSING "Include Swift StringProcessing build targets" OFF)

#TODO: Finish hooking up synchronization and turn this back on
option(SwiftStdlib_ENABLE_SYNCHRONIZATION "Include Swift synchronization build targets" OFF)

# The old driver is unable to reliably produce the index store correctly resulting in failed builds.
# Enable this if you're using the Swift-Swift-Driver and want improved LSP support.
option(SwiftStdlib_ENABLE_INDEX_STORE "Enable generating the index store for improved LSP functionality" OFF)

# Configure the platform overlay
# If the platform vends an overlay, use that overlay. If you are the owner of
# the platform vending the overlay or the platform does not vend an overlay,
# then you should build the platform overlay.
set(SwiftStdlib_PLATFORM_OVERLAY "Darwin" CACHE STRING "Platform overlay module name. Options are: Darwin glibc musl wasi")
option(SwiftStdlib_BUILD_PLATFORM_OVERLAY "Include platform overlay build target in build graph." OFF)

# FIXME: We should not be pulling in the ../include directory here!
#        It is necessary because we are a menace to ourselves and society and
#        decided mixing the two was a good idea. We need to figure out how we
#        want to vend the headers that are used by both the stdlib/runtime and
#        compiler for ABI purposes. Everything else should just be split because
#        they end up in different places.
include_directories(include "${CMAKE_SOURCE_DIR}/../include")

add_compile_options($<$<COMPILE_LANGUAGE:Swift>:-explicit-module-build>
                    $<$<COMPILE_LANGUAGE:Swift>:-nostdimport>
                    "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -enforce-exclusivity=unchecked>"
                    "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -target-min-inlining-version -Xfrontend min>"
                    "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -enable-ossa-modules>"
                    "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -enable-lexical-lifetimes=false>"
                    "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -disable-implicit-concurrency-module-import>"
                    "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -disable-implicit-string-processing-module-import>"
                    "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -disable-implicit-backtracing-module-import>"
                    $<$<COMPILE_LANGUAGE:Swift>:-save-optimization-record=bitstream>
                    "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -target-min-inlining-version -Xfrontend min>"
                    $<$<COMPILE_LANGUAGE:Swift>:-runtime-compatibility-version$<SEMICOLON>none>)

add_subdirectory(public)
add_subdirectory(private)
