#===--- CMakeLists.txt - Concurrency support library ---------------------===#
#
# This source file is part of the Swift.org open source project
#
# Copyright (c) 2019 - 2024 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See https://swift.org/LICENSE.txt for license information
# See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
#
#===----------------------------------------------------------------------===#

add_subdirectory(InternalShims)

set(SwiftStdlib_CONCURRENCY_BACKEND "dispatch" CACHE STRING
  "Swift concurrency backend. Options are: dispatch singlethreaded hooked none")

add_library(swift_Concurrency
  ../CompatibilityOverride/CompatibilityOverride.cpp
  Actor.cpp
  Actor.swift
  AsyncCompactMapSequence.swift
  AsyncDropFirstSequence.swift
  AsyncDropWhileSequence.swift
  AsyncFilterSequence.swift
  AsyncFlatMapSequence.swift
  AsyncIteratorProtocol.swift
  AsyncLet.cpp
  AsyncLet.swift
  AsyncMapSequence.swift
  AsyncPrefixSequence.swift
  AsyncPrefixWhileSequence.swift
  AsyncSequence.swift
  AsyncStream.cpp
  AsyncStream.swift
  AsyncStreamBuffer.swift
  AsyncThrowingCompactMapSequence.swift
  AsyncThrowingDropWhileSequence.swift
  AsyncThrowingFilterSequence.swift
  AsyncThrowingFlatMapSequence.swift
  AsyncThrowingMapSequence.swift
  AsyncThrowingPrefixWhileSequence.swift
  AsyncThrowingStream.swift
  CheckedContinuation.swift
  Clock.cpp
  Clock.swift
  ContinuousClock.swift
  Deque/Compatibility.swift
  Deque/Deque+Codable.swift
  Deque/Deque+Collection.swift
  Deque/Deque+CustomDebugStringConvertible.swift
  Deque/Deque+CustomReflectable.swift
  Deque/Deque+CustomStringConvertible.swift
  Deque/Deque+Equatable.swift
  Deque/Deque+ExpressibleByArrayLiteral.swift
  Deque/Deque+Extras.swift
  Deque/Deque+Hashable.swift
  Deque/Deque+Storage.swift
  Deque/Deque+Testing.swift
  Deque/Deque+UnsafeHandle.swift
  Deque/Deque.swift
  Deque/UnsafeMutableBufferPointer+Utilities.swift
  Deque/_DequeBuffer.swift
  Deque/_DequeBufferHeader.swift
  Deque/_DequeSlot.swift
  Deque/_UnsafeWrappedBuffer.swift
  DiscardingTaskGroup.swift
  EmbeddedSupport.cpp
  Error.cpp
  Errors.swift
  Executor.swift
  ExecutorAssertions.swift
  GlobalActor.swift
  GlobalConcurrentExecutor.swift
  GlobalExecutor.cpp
  MainActor.swift
  PartialAsyncTask.swift
  Setup.cpp
  SourceCompatibilityShims.swift
  SuspendingClock.swift
  Task+TaskExecutor.swift
  Task.cpp
  Task.swift
  TaskAlloc.cpp
  TaskCancellation.swift
  TaskGroup+TaskExecutor.swift
  TaskGroup.cpp
  TaskGroup.swift
  TaskLocal.cpp
  TaskLocal.swift
  TaskSleep.swift
  TaskSleepDuration.swift
  TaskStatus.cpp
  ThreadingError.cpp
  TracingSignpost.cpp
  linker-support/magic-symbols-for-install-name.c)
set_target_properties(swift_Concurrency PROPERTIES Swift_MODULE_NAME _Concurrency
  Swift_MODULE_LINK_NAME swift_Concurrency)
target_link_libraries(swift_Concurrency PRIVATE swiftCore swiftThreading swiftShims SwiftConcurrencyInternalShims)
target_compile_options(swift_Concurrency PRIVATE
  $<$<COMPILE_LANGUAGE:Swift>:-parse-stdlib>
  $<$<COMPILE_LANGUAGE:Swift>:-nostdimport>
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-enable-experimental-feature IsolatedAny>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-enable-experimental-feature IsolatedAny2>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-enable-experimental-feature OptionalIsolatedParameters>"
  "$<$<AND:$<COMPILE_LANGUAGE:Swift>,$<BOOL:${SwiftStdlib_ENABLE_ASYNC_FP}>>:SHELL:-Xfrontend -swift-async-frame-pointer=always>"
  "$<$<AND:$<COMPILE_LANGUAGE:C,CXX>,$<BOOL:${SwiftStdlib_ENABLE_ASYNC_FP}>>:-fswift-async-fp=always>")
  # "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -require-explicit-availability=ignore>")
target_compile_definitions(swift_Concurrency PRIVATE
  swift_concurrency_EXPORTS
  $<$<COMPILE_LANGUAGE:C,CXX>:SWIFT_TARGET_LIBRARY_NAME=swift_Concurrency>
  $<$<COMPILE_LANGUAGE:C,CXX>:__STDC_WANT_LIB_EXT1__=1>)

install(TARGETS swift_Concurrency)
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/_Concurrency.swiftmodule"
        DESTINATION "${CMAKE_INSTALL_LIBDIR}/swift/_Concurrency.swiftmodule"
        RENAME "${SwiftStdlib_MODULE_TRIPLE}.swiftmodule")

if(HAVE_WGLOBAL_CONSTRUCTORS)
  # swift::jobHeapMetadata, swift::taskHeapMetadata both require global constructors.
  target_compile_options(swift_Concurrency PRIVATE $<$<COMPILE_LANGUAGE:C,CXX>:-Wno-global-constructors>)
endif()

if(SwiftStdlib_ENABLE_LIBRARY_EVOLUTION)
  emit_swift_interface(swift_Concurrency)
  install_swift_interface(swift_Concurrency)
endif()

if(${SwiftStdlib_CONCURRENCY_BACKEND} STREQUAL "dispatch")
  # TODO: Consider moving SWIFT_CONCURRENCY_ENABLE_DISPATCH to a generated
  #       config.h file and remove SWIFT_CONCURRENCY_USES_DISPATCH.
  target_compile_definitions(swift_Concurrency PRIVATE SWIFT_CONCURRENCY_USES_DISPATCH)
endif()

# TODO: Figure out what's going on here
# (_TaskExecutor usage in GlobalConcurrentExecutor.swift is trigging
# availability checking)
target_compile_options(swift_Concurrency PRIVATE "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -disable-availability-checking>")
