add_library(swiftCommandLineSupport STATIC CommandLine.cpp)
target_link_libraries(swiftCommandLineSupport PRIVATE swiftShims)

if(NOT BUILD_SHARED_LIBS)
  # if swiftCore is built dynamically, this is linked into swiftCore. If
  # swiftCore is static, we need to install this so that folks can link against
  # it.
  # TODO: Once we move to CMake 3.29+, we can make swiftCommandLineSupport an
  #       object library and insert the object directly in libswiftCore.a
  install(TARGETS swiftCommandLineSupport)
endif()
