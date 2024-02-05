# FIXME: These files should be split for the stdlib and compiler so that we can
#        separate the stdlib from the compiler repo
add_library(swiftThreading STATIC
  "${CMAKE_SOURCE_DIR}/../lib/Threading/C11.cpp"
  "${CMAKE_SOURCE_DIR}/../lib/Threading/C11.cpp"
  "${CMAKE_SOURCE_DIR}/../lib/Threading/Linux.cpp"
  "${CMAKE_SOURCE_DIR}/../lib/Threading/Pthreads.cpp"
  "${CMAKE_SOURCE_DIR}/../lib/Threading/Win32.cpp")
target_link_libraries(swiftThreading PRIVATE swiftShims)

if(NOT BUILD_SHARED_LIBS)
  # if swiftConcurrency is built dynamically, this is linked into
  # swiftConcurrency. If
  # swiftConcurrency is static, we need to install this so that folks can link
  # against it.
  # TODO: Once we move to CMake 3.29+, we can make swiftThreading an
  #       object library and insert the object directly in libswiftConcurrency.a
  install(TARGETS swiftThreading)
endif()
