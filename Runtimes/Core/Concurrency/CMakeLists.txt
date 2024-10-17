add_subdirectory(InternalShims)

set(SwiftCore_CONCURRENCY_BACKEND "dispatch" CACHE STRING
  "Swift concurrency backend. Options: dispatch singlethreaded hooked none")

add_library(swift_Concurrency
  "${PROJECT_SOURCE_DIR}/CompatibilityOverride/CompatibilityOverride.cpp"
  Actor.cpp
  AsyncLet.cpp
  Clock.cpp
  GlobalExecutor.cpp
  ConcurrencyHooks.cpp
  EmbeddedSupport.cpp
  Error.cpp
  ExecutorChecks.cpp
  Setup.cpp
  Task.cpp
  TaskAlloc.cpp
  TaskStatus.cpp
  TaskGroup.cpp
  TaskLocal.cpp
  ThreadingError.cpp
  TracingSignpost.cpp
  AsyncStream.cpp
  linker-support/magic-symbols-for-install-name.c
  Actor.swift
  AsyncLet.swift
  CheckedContinuation.swift
  Errors.swift
  Executor.swift
  ExecutorAssertions.swift
  AsyncCompactMapSequence.swift
  AsyncDropFirstSequence.swift
  AsyncDropWhileSequence.swift
  AsyncFilterSequence.swift
  AsyncFlatMapSequence.swift
  AsyncIteratorProtocol.swift
  AsyncMapSequence.swift
  AsyncPrefixSequence.swift
  AsyncPrefixWhileSequence.swift
  AsyncSequence.swift
  AsyncThrowingCompactMapSequence.swift
  AsyncThrowingDropWhileSequence.swift
  AsyncThrowingFilterSequence.swift
  AsyncThrowingFlatMapSequence.swift
  AsyncThrowingMapSequence.swift
  AsyncThrowingPrefixWhileSequence.swift
  GlobalActor.swift
  GlobalConcurrentExecutor.swift
  MainActor.swift
  PartialAsyncTask.swift
  SourceCompatibilityShims.swift
  Task.swift
  Task+TaskExecutor.swift
  TaskCancellation.swift
  TaskGroup.swift
  TaskGroup+TaskExecutor.swift
  DiscardingTaskGroup.swift
  TaskLocal.swift
  TaskSleep.swift
  AsyncStreamBuffer.swift
  AsyncStream.swift
  AsyncThrowingStream.swift
  Deque/_DequeBuffer.swift
  Deque/_DequeBufferHeader.swift
  Deque/_DequeSlot.swift
  Deque/_UnsafeWrappedBuffer.swift
  Deque/Compatibility.swift
  Deque/Deque+Storage.swift
  Deque/Deque+UnsafeHandle.swift
  Deque/Deque.swift
  Deque/Deque+Codable.swift
  Deque/Deque+Collection.swift
  Deque/Deque+CustomDebugStringConvertible.swift
  Deque/Deque+CustomReflectable.swift
  Deque/Deque+CustomStringConvertible.swift
  Deque/Deque+Equatable.swift
  Deque/Deque+ExpressibleByArrayLiteral.swift
  Deque/Deque+Extras.swift
  Deque/Deque+Hashable.swift
  Deque/Deque+Testing.swift
  Deque/UnsafeMutableBufferPointer+Utilities.swift
  Clock.swift
  ContinuousClock.swift
  SuspendingClock.swift
  TaskSleepDuration.swift)

string(TOLOWER "${SwiftCore_CONCURRENCY_BACKEND}x" _ConcurrencyBackend)
if("${_ConcurrencyBackend}" STREQUAL "dispatchx")
  target_sources(swift_Concurrency PRIVATE DispatchGlobalExecutor.cpp)
  target_compile_definitions(swift_Concurrency PRIVATE
    -DSWIFT_CONCURRENCY_USES_DISPATCH)
elseif("${_ConcurrencyBackend}" STREQUAL "singlethreadedx")
  target_sources(swift_Concurrency PRIVATE CooperativeGlobalExecutor.cpp)
elseif("${_ConcurrencyBackend}" STREQUAL "hookedx" OR
       "${_ConcurrencyBackend}" STREQUAL "nonex")
  target_sources(swift_Concurrency PRIVATE NonDispatchGlobalExecutor.cpp)
endif()

set_target_properties(swift_Concurrency PROPERTIES
  Swift_MODULE_NAME _Concurrency)

target_compile_definitions(swift_Concurrency PRIVATE
  $<$<COMPILE_LANGUAGE:C,CXX>:-DSWIFT_TARGET_LIBRARY_NAME=swift_Concurrency>
  $<$<COMPILE_LANGUAGE:C,CXX>:-D__STDC_WANT_LIB_EXT1__=1>)

target_compile_options(swift_Concurrency PRIVATE
  $<$<COMPILE_LANGUAGE:Swift>:-parse-stdlib>
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -empty-abi-descriptor>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-enable-experimental-feature IsolatedAny>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-enable-experimental-feature AllowUnsafeAttribute>")

if(APPLE)
  target_compile_options(swift_Concurrency PRIVATE
    $<$<COMPILE_LANGUAGE:C,CXX>:-fswift-async-fp=always>
    "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -swift-async-frame-pointer=always>")
else()
  target_compile_options(swift_Concurrency PRIVATE
    $<$<COMPILE_LANGUAGE:C,CXX>:-fswift-async-fp=never>)
endif()

# Used by compatibility override
target_include_directories(swift_Concurrency PRIVATE
  ${PROJECT_SOURCE_DIR}/../../include)

target_include_directories(swift_Concurrency PRIVATE
  "${PROJECT_BINARY_DIR}/include")


target_link_libraries(swift_Concurrency
  PRIVATE
    swiftShims
    SwiftConcurrencyInternalShims
    swiftCore
    swiftThreading)

if(NOT POLICY CMP0157)
  target_compile_options(swift_Concurrency PRIVATE $<TARGET_OBJECTS:swiftThreading>)
endif()

install(TARGETS swift_Concurrency)
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/_Concurrency.swiftmodule"
  DESTINATION "${CMAKE_INSTALL_LIBDIR}/swift/_Concurrency.swiftmodule"
  RENAME "${SwiftCore_MODULE_TRIPLE}.swiftmodule")
emit_swift_interface(swift_Concurrency)
install_swift_interface(swift_Concurrency)
