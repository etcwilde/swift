# Swift Standard Library

**NOTE!:** This is an experiment. Various parts may or may not work.

## Build Instructions

### Normal Development

A normal development stdlib configuration might look like the following:

```sh
>  mkdir build && cd build
>  cmake -G 'Ninja' -DSwiftStdlib_ENABLE_INDEX_STORE=YES -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=YES ../
>  ninja swiftCore
```

This will result in a debug build that emits an index store database and
`compile_commands.json` (CMake 3.29+) in the build directory, which works with
SourceKit-LSP to provide advanced editor support.

### Preconfigured Builds

Building for a specific build configuration is also fairly easy.
Cross-compiling the stdlib for iOS looks like this:

```sh
>  mkdir build && cd build
>  cmake -G 'Ninja' -C ../cmake/caches/Platforms/Apple/arm64-apple-ios.cmake \
        --toolchain ../cmake/toolchains/Apple/ios.cmake ../
>  ninja
```

### Build Options

 - `SwiftStdlib_ENABLE_INDEX_STORE`: Enable emitting the index store for
   development on the standard library. SourceKit-LSP uses the index for
   improved awareness of the code.

 - `SwiftStdlib_ENABLE_CRASH_REPORTER_CLIENT`

 - `SwiftStdlib_ENABLE_OBJC_INTEROP`

 - `SwiftStdlib_ENABLE_TYPE_PRINTING`: Include runtime type printing
   capabilities.

 - `SwiftStdlib_ENABLE_LEAK_CHECKER`

 - `SwiftStdlib_CLOBBER_FREED_OBJECT`

 - `SwiftStdlib_ENABLE_ASYNC_FP`: Emit asynchronous frame pointer support in
   swiftConcurrency for improved debugging.

 - `SwiftStdlib_ENABLE_EXTRA_CHECKS`

 - `SwiftStdlib_ENABLE_VECTOR_TYPES`: Include SIMD support in the built standard
   library.

 - `SwiftStdlib_ENABLE_COMMANDLINE_SUPPORT`: Include the `CommandLine` support
   in the built standard library.

 - `SwiftStdlib_ENABLE_PRESPECIALIZATION`: Enable the generic metadata
   prespecialization optimization on the standard library.

 - `SwiftStdlib_ENABLE_LIBRARY_EVOLUTION`: Enable ABI resilience on the built
   standard library. This enables emitting swiftinterface files for each of the
   Swift modules.

 - `SwiftStdlib_ENABLE_EXTRA_SOURCES`

 - `SwiftStdlib_ENABLE_CXX_INTEROP`: Enable targets for the C++ interop
   libraries.

 - `SwiftStdlib_ENABLE_REFLECTION`: Enable mirror support in built `swiftCore`.

 - `SwiftStdlib_ENABLE_CONCURRENCY`: Enable build targets for swift concurrency
   support.

 - `SwiftStdlib_ENABLE_DIFFERENTIATION`: Enable swift Differentiation build
   targets.

 - `SwiftStdlib_ENABLE_DISTRIBUTED`: Enable distributed actor support in emitted
   Swift standard library.

 - `SwiftStdlib_ENABLE_OBSERVATION`: Enable observation build targets.

 - `SwiftStdlib_ENABLE_BACKTRACING`: Enable backtracing build targets.

 - `SwiftStdlib_ENABLE_SYNCHRONIZATION`: Enable synchronization build targets.
   **NOTE!:** This is still broken and will crash the compiler on contact.
