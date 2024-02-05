#===--- CMakeLists.txt - Backtracing support library -----------------------===#
#
# This source file is part of the Swift.org open source project
#
# Copyright (c) 2023 - 2024 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See https://swift.org/LICENSE.txt for license information
# See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
#
#===------------------------------------------------------------------------===#

add_library(swift_Backtracing
  ArrayImageSource.swift
  Backtrace.swift
  BacktraceFormatter.swift
  ByteSwapping.swift
  CachingMemoryReader.swift
  Context.swift
  Compression.swift
  CoreSymbolication.swift
  Dwarf.swift
  Elf.swift
  FileImageSource.swift
  FramePointerUnwinder.swift
  Image.swift
  ImageSource.swift
  MemoryImageSource.swift
  MemoryReader.swift
  ProcMapsScanner.swift
  Registers.swift
  SymbolicatedBacktrace.swift
  Utils.swift
  Win32Extras.cpp
  # TODO Swift ASM extension
  get-cpu-context.${SWIFT_ASM_EXT})

target_link_libraries(swift_Backtracing PRIVATE swiftCore)
target_compile_options(swift_Backtracing PRIVATE
  $<$<COMPILE_LANGUAGE:Swift>:-parse-stdlib>
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -experimental-spi-only-imports>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xcc -fno-implicit-module-maps>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xcc -fbuiltin-module-map>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xcc -fmodule-map-file=${SwiftStdblib_SOURCE_DIR}/public/SwiftShims/swift/shims/module.modulemap>"
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xcc -fmodule-map-file=${SwiftStdblib_SOURCE_DIR}/public/Backtracing/modules/module.modulemap>")

# TODO: handle statically linked backtracing support
#       (Note that this was not hooked up before either)
