gyb_expand(SwiftNativeNSXXXBase.mm.gyb
    "${SwiftStdlib_SIZEOF_POINTER}/SwiftNativeNSXXXBase.mm"
    FLAGS "-DCMAKE_SIZEOF_VOID_P=${SwiftStdlib_SIZEOF_POINTER}")

add_library(swiftStdlibStubs STATIC
  Assert.cpp
  GlobalObjects.cpp
  LibcShims.cpp
  Random.cpp
  Stubs.cpp
  ThreadLocalStorage.cpp
  MathStubs.cpp
  Unicode/UnicodeData.cpp
  Unicode/UnicodeGrapheme.cpp
  Unicode/UnicodeNormalization.cpp
  Unicode/UnicodeScalarProps.cpp
  Unicode/UnicodeWord.cpp
  Availability.mm
  FoundationHelpers.mm
  OptionalBridgingHelper.mm
  Reflection.mm
  SwiftNativeNSObject.mm
  SwiftNativeNSXXXBaseARC.m
  "${CMAKE_CURRENT_BINARY_DIR}/${SwiftStdlib_SIZEOF_POINTER}/SwiftNativeNSXXXBase.mm")
target_include_directories(swiftStdlibStubs PRIVATE
  "${CMAKE_SOURCE_DIR}/public")
target_compile_definitions(swiftStdlibStubs PRIVATE
  -DswiftCore_EXPORTS)
target_link_libraries(swiftStdlibStubs PRIVATE swiftShims)

if(APPLE)
  set_property(SOURCE SwiftNativeNSXXXBaseARC.m
               APPEND_STRING
               PROPERTY COMPILE_FLAGS "-fobjc-arc")
endif()

add_subdirectory(Unicode)
