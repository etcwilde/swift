# Order is important when building the stdlib. Unlike other libraries where
# order doesn't matter, the standard library sources must be in the right order
# in order for definitions that the compiler has sugar for to be available to
# later files. The compiler is particularly sensitive to arrays (especially in
# regards to parameter packs) and optionals (Optional must be defined before the
# first `?`).
gyb_expand(AtomicInt.swift.gyb
           "${SwiftStdlib_SIZEOF_POINTER}/AtomicInt.swift"
           FLAGS "-DCMAKE_SIZEOF_VOID_P=${SwiftStdlib_SIZEOF_POINTER}")

gyb_expand(FloatingPointParsing.swift.gyb
           "${SwiftStdlib_SIZEOF_POINTER}/FloatingPointParsing.swift"
           FLAGS "-DCMAKE_SIZEOF_VOID_P=${SwiftStdlib_SIZEOF_POINTER}")

gyb_expand(FloatingPointTypes.swift.gyb
           "${SwiftStdlib_SIZEOF_POINTER}/FloatingPointTypes.swift"
           FLAGS "-DCMAKE_SIZEOF_VOID_P=${SwiftStdlib_SIZEOF_POINTER}")

gyb_expand(IntegerTypes.swift.gyb
           "${SwiftStdlib_SIZEOF_POINTER}/IntegerTypes.swift"
           FLAGS "-DCMAKE_SIZEOF_VOID_P=${SwiftStdlib_SIZEOF_POINTER}")

gyb_expand(UnsafeBufferPointer.swift.gyb
           "${SwiftStdlib_SIZEOF_POINTER}/UnsafeBufferPointer.swift"
           FLAGS "-DCMAKE_SIZEOF_VOID_P=${SwiftStdlib_SIZEOF_POINTER}")

gyb_expand(UnsafeRawBufferPointer.swift.gyb
           "${SwiftStdlib_SIZEOF_POINTER}/UnsafeRawBufferPointer.swift"
           FLAGS "-DCMAKE_SIZEOF_VOID_P=${SwiftStdlib_SIZEOF_POINTER}")
gyb_expand(LegacyInt128.swift.gyb
           "${SwiftStdlib_SIZEOF_POINTER}/LegacyInt128.swift"
           FLAGS "-DCMAKE_SIZEOF_VOID_P=${SwiftStdlib_SIZEOF_POINTER}")
gyb_expand(Tuple.swift.gyb
           "${SwiftStdlib_SIZEOF_POINTER}/Tuple.swift"
           FLAGS "-DCMAKE_SIZEOF_VOID_P=${SwiftStdlib_SIZEOF_POINTER}")

add_library(swiftCore
  Algorithm.swift
  ArrayBody.swift
  ArrayBuffer.swift
  ArrayBufferProtocol.swift
  ArrayCast.swift
  Array.swift
  ArrayShared.swift
  ArraySlice.swift
  ArrayType.swift
  ASCII.swift
  Assert.swift
  AssertCommon.swift
  BidirectionalCollection.swift
  Bitset.swift
  Bool.swift
  BridgeObjectiveC.swift
  BridgeStorage.swift
  BridgingBuffer.swift
  Builtin.swift
  BuiltinMath.swift
  Character.swift
  CocoaArray.swift
  Codable.swift
  Collection.swift
  CollectionAlgorithms.swift
  Comparable.swift
  CompilerProtocols.swift
  Sendable.swift
  ContiguousArray.swift
  ContiguouslyStored.swift
  ClosedRange.swift
  ContiguousArrayBuffer.swift
  CString.swift
  CTypes.swift
  DebuggerSupport.swift
  Dictionary.swift
  DictionaryBridging.swift
  DictionaryBuilder.swift
  DictionaryCasting.swift
  DictionaryStorage.swift
  DictionaryVariant.swift
  DiscontiguousSlice.swift
  DropWhile.swift
  Dump.swift
  EmptyCollection.swift
  Equatable.swift
  ErrorType.swift
  ExistentialCollection.swift
  Filter.swift
  FlatMap.swift
  Flatten.swift
  FloatingPoint.swift
  Hashable.swift
  AnyHashable.swift
  Hasher.swift
  Hashing.swift
  HashTable.swift
  Identifiable.swift
  Indices.swift
  InputStream.swift
  IntegerParsing.swift
  Integers.swift
  Int128.swift
  Join.swift
  KeyPath.swift
  KeyValuePairs.swift
  LazyCollection.swift
  LazySequence.swift
  LegacyABI.swift
  LifetimeManager.swift
  Macros.swift
  ManagedBuffer.swift
  Map.swift
  MemoryLayout.swift
  UnicodeScalar.swift
  Mirrors.swift
  Misc.swift
  MutableCollection.swift
  NativeDictionary.swift
  NativeSet.swift
  NewtypeWrapper.swift
  NFC.swift
  NFD.swift
  ObjectIdentifier.swift
  Optional.swift
  OptionSet.swift
  OutputStream.swift
  Pointer.swift
  Policy.swift
  PrefixWhile.swift
  Prespecialize.swift
  Print.swift
  PtrAuth.swift
  Random.swift
  RandomAccessCollection.swift
  Range.swift
  RangeReplaceableCollection.swift
  RangeSet.swift
  RangeSetRanges.swift
  ReflectionMirror.swift
  Repeat.swift
  REPL.swift
  Result.swift
  Reverse.swift
  Runtime.swift
  RuntimeFunctionCounters.swift
  SipHash.swift
  Sequence.swift
  SequenceAlgorithms.swift
  Set.swift
  SetAlgebra.swift
  SetAnyHashableExtensions.swift
  SetBridging.swift
  SetBuilder.swift
  SetCasting.swift
  SetStorage.swift
  SetVariant.swift
  ShadowProtocols.swift
  Shims.swift
  Slice.swift
  SmallString.swift
  Sort.swift
  StaticString.swift
  StaticPrint.swift
  Stride.swift
  StringHashable.swift
  String.swift
  StringBreadcrumbs.swift
  StringBridge.swift
  StringCharacterView.swift
  StringComparable.swift
  StringComparison.swift
  StringCreate.swift
  StringGuts.swift
  StringGutsSlice.swift
  StringGutsRangeReplaceable.swift
  StringObject.swift
  StringProtocol.swift
  StringIndex.swift
  StringIndexConversions.swift
  StringIndexValidation.swift
  StringInterpolation.swift
  StringLegacy.swift
  StringNormalization.swift
  StringRangeReplaceableCollection.swift
  StringStorage.swift
  StringStorageBridge.swift
  StringSwitch.swift
  StringTesting.swift
  StringUnicodeScalarView.swift
  StringUTF16View.swift
  StringUTF8View.swift
  StringUTF8Validation.swift
  StringWordBreaking.swift
  Substring.swift
  SwiftNativeNSArray.swift
  TemporaryAllocation.swift
  ThreadLocalStorage.swift
  UInt128.swift
  UIntBuffer.swift
  UnavailableStringAPIs.swift
  UnicodeData.swift
  UnicodeEncoding.swift
  UnicodeBreakProperty.swift
  UnicodeHelpers.swift
  UnicodeParser.swift
  UnicodeScalarProperties.swift
  CharacterProperties.swift
  UnicodeSPI.swift
  Unmanaged.swift
  UnmanagedOpaqueString.swift
  UnmanagedString.swift
  UnsafePointer.swift
  UnsafeRawPointer.swift
  UTFEncoding.swift
  UTF8.swift
  UTF16.swift
  UTF32.swift
  Unicode.swift
  StringGraphemeBreaking.swift
  ValidUTF8Buffer.swift
  WriteBackMutableSlice.swift
  MigrationSupport.swift
  "${CMAKE_SOURCE_DIR}/linker-support/magic-symbols-for-install-name.c"
  "${CMAKE_CURRENT_BINARY_DIR}/${SwiftStdlib_SIZEOF_POINTER}/AtomicInt.swift"
  "${CMAKE_CURRENT_BINARY_DIR}/${SwiftStdlib_SIZEOF_POINTER}/FloatingPointParsing.swift"
  "${CMAKE_CURRENT_BINARY_DIR}/${SwiftStdlib_SIZEOF_POINTER}/FloatingPointTypes.swift"
  "${CMAKE_CURRENT_BINARY_DIR}/${SwiftStdlib_SIZEOF_POINTER}/IntegerTypes.swift"
  "${CMAKE_CURRENT_BINARY_DIR}/${SwiftStdlib_SIZEOF_POINTER}/UnsafeBufferPointer.swift"
  "${CMAKE_CURRENT_BINARY_DIR}/${SwiftStdlib_SIZEOF_POINTER}/UnsafeRawBufferPointer.swift"
  "${CMAKE_CURRENT_BINARY_DIR}/${SwiftStdlib_SIZEOF_POINTER}/LegacyInt128.swift"
  "${CMAKE_CURRENT_BINARY_DIR}/${SwiftStdlib_SIZEOF_POINTER}/Tuple.swift")

set_target_properties(swiftCore PROPERTIES Swift_MODULE_NAME Swift)

install(TARGETS swiftCore)
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/Swift.swiftmodule"
  DESTINATION "${CMAKE_INSTALL_LIBDIR}/swift/Swift.swiftmodule"
  RENAME "${SwiftStdlib_MODULE_TRIPLE}.swiftmodule")

if(SwiftStdlib_ENABLE_EXTRA_SOURCES)
  target_sources(swiftCore PRIVATE
    Availability.swift
    CollectionDifference.swift
    CollectionOfOne.swift
    Diffing.swift
    Duration.swift
    DurationProtocol.swift
    FloatingPointRandom.swift
    Instant.swift
    Mirror.swift
    PlaygroundDisplay.swift
    SliceBuffer.swift
    StaticBigInt.swift
    UnfoldSequence.swift
    UnsafeBufferPointerSlice.swift
    VarArgs.swift
    Zip.swift)

    if(SwiftStdlib_ENABLE_REFLECTION)
      target_compile_definitions(swiftCore PRIVATE -DSWIFT_ENABLE_REFLECTION)
    endif()

    if(SwiftStdlib_ENABLE_COMMANDLINE_SUPPORT)
      # TODO: CommandLine.cpp and CommandLine.swift should likely be joined
      #       in a target since they only make sense together.
      target_sources(swiftCore PRIVATE
        CommandLine.swift)
    endif()
endif()


if(SwiftStdlib_ENABLE_VECTOR_TYPES)
  gyb_expand(SIMDConcreteOperations.swift.gyb
    "${SwiftStdlib_SIZEOF_POINTER}/SIMDConcreteOperations.swift"
    FLAGS "-DCMAKE_SIZEOF_VOID_P=${SwiftStdlib_SIZEOF_POINTER}")
  gyb_expand(SIMDVectorTypes.swift.gyb
    "${SwiftStdlib_SIZEOF_POINTER}/SIMDVectorTypes.swift"
    FLAGS "-DCMAKE_SIZEOF_VOID_P=${SwiftStdlib_SIZEOF_POINTER}")

  target_sources(swiftCore PRIVATE
    SIMDVector.swift
    "${CMAKE_CURRENT_BINARY_DIR}/${SwiftStdlib_SIZEOF_POINTER}/SIMDConcreteOperations.swift"
    "${CMAKE_CURRENT_BINARY_DIR}/${SwiftStdlib_SIZEOF_POINTER}/SIMDVectorTypes.swift")
endif()

target_compile_options(swiftCore PRIVATE
  $<$<COMPILE_LANGUAGE:Swift>:-parse-stdlib>
  $<$<COMPILE_LANGUAGE:Swift>:-nostdimport>
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xcc -DswiftCore_EXPORTS>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -disable-autolinking-runtime-compatibility-concurrency>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -disable-objc-attr-requires-foundation-module>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -group-info-path -Xfrontend ${CMAKE_CURRENT_SOURCE_DIR}/GroupInfo.json>"
  $<$<COMPILE_LANGUAGE:Swift>:-disable-autolinking-runtime-compatibility-dynamic-replacements>
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -enable-experimental-concise-pound-file>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-enable-experimental-feature TypedThrows>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-enable-experimental-feature Macros>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-enable-experimental-feature FreeStandingMacros>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-enable-experimental-feature Extern>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-enable-experimental-feature BitwiseCopyable>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -prespecialize-generic-metadata>")

target_link_libraries(swiftCore PRIVATE swiftRuntime swiftLLVMSupport swiftDemangling swiftStdlibStubs swiftThreading swiftShims)
if(NOT POLICY CMP0157)
  # Linking object libraries into swift libraries is not supported
  # pre-CMake 3.29.
  target_compile_options(swiftCore PRIVATE
    $<TARGET_OBJECTS:swiftRuntime>
    $<TARGET_OBJECTS:swiftLLVMSupport>
    $<TARGET_OBJECTS:swiftDemangling>
    $<TARGET_OBJECTS:swiftStdlibStubs>
    $<TARGET_OBJECTS:swiftThreading>)
endif()

if(SwiftStdlib_ENABLE_COMMANDLINE_SUPPORT)
  target_link_libraries(swiftCore PRIVATE $<TARGET_OBJECTS:swiftCommandLineSupport>)
  target_compile_definitions(swiftCore PRIVATE -DSWIFT_STDLIB_HAS_COMMANDLINE)
endif()

if(WIN32)
  target_link_libraries(swiftCore PRIVATE shell32 DbgHelp Synchronization)
elseif(NOT APPLE AND NOT LINUX AND UNIX)
  find_library(EXECINFO_LIBRARY execinfo)
  target_link_libraries(swiftCore PRIVATE "${EXECINFO_LIBRARY}")
endif()

if(SwiftStdlib_ENABLE_LIBRARY_EVOLUTION)
  emit_swift_interface(swiftCore)
  install_swift_interface(swiftCore)
endif()

if(NOT "${CMAKE_BUILD_TYPE}" STREQUAL "MinSizeRel")
  target_compile_options(swiftCore PRIVATE
    "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xllvm -sil-inline-generics>"
    "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xllvm -sil-partial-specialization>")
endif()

if(SwiftStdlib_ENABLE_EXTRA_CHECKS)
  # Do we want to split up the condition to enable the checks? Is that
  # necessary, or nice-to-have?
  target_compile_options(swiftCore PRIVATE
    $<$<COMPILE_LANGUAGE:Swift>:-enforce-exclusivity=checked>)
  target_compile_definitions(swiftCore PRIVATE
    -DCOW_CHECKS_ENABLED
    -DSWIFT_STDLIB_ENABLE_DEBUG_PRECONDITIONS_IN_RELEASE)
endif()

# TODO: Figure out how to deal with macros...
# Not sure how all of this will work out...
#list(APPEND swift_stdlib_compile_flags "-plugin-path" "${swift_lib_dir}/swift/host/plugins")
# target_compile_options(swiftCore PRIVATE "SHELL:-enable-experimental-feature DebugDescriptionMacro")
# target_sources(swiftCore PRIVATE ObjectIdentifier+DebugDescription.swift)

# TODO: Figure out how the heck I'm supposed to build the embedded stdlib.
#       The challenge with Embedded is that it doesn't emit objects. The CMake
#       build graph is based primarily on the compiler emitting objects and
#       compiled outputs. This might need to stay a custom command.
