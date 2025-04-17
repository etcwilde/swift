#[=======================================================================[.rst:
Findmath
------------

Find the Swift `_math` module interface, deferring to mathConfig.cmake when
requested.

This module locates the Swift `_math` module, which provides standard math 
functions to Swift code. The module looks for the `_math.swiftinterface` file 
in the SDK and sets up an imported target for use in CMake.

Imported Targets
^^^^^^^^^^^^^^^^

The following :prop_tgt:`IMPORTED` TARGETS may be defined:

 ``math``

Hint Variables
^^^^^^^^^^^^^^

 ``swift_SDKROOT``
   Set the path to the Swift SDK installation.
   This only affects Linux and Windows builds.
   Apple builds always use the library provided by the SDK.

 ``math_STATIC``
   Look for the libdispatch static archive instead of the dynamic library.

Result Variables
^^^^^^^^^^^^^^^^

The module may set the following variables if `math_DIR` is not set.

 ``math_FOUND``
   true if the `_math` module interface (and required library) were found.

 ``math_INCLUDE_DIR``
   The directory containing the `_math.swiftinterface` file

 ``dispatch_LIBRARIES`` OR ``dispatch_IMPLIB``
   the libraries to be linked

#]=======================================================================]

# If the math_DIR is specified, look there instead. The cmake-generated
# config file is more accurate, but requires that the SDK has one available.
if(math_DIR)
  if(math_FIND_REQUIRED)
    list(APPEND args REQUIRED)
  endif()
  if(math_FIND_QUIETLY)
    list(APPEND args QUIET)
  endif()
  find_package(math NO_MODULE ${args})
  return()
endif()

include(FindPackageHandleStandardArgs)

if(APPLE)
  # Find the SDK with which we are building.
  execute_process(
    COMMAND xcrun --sdk macosx --show-sdk-path
    OUTPUT_VARIABLE _MATH_SDK
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_QUIET)
  find_path(math_INCLUDE_DIR
    NAMES "_math.swiftmodule"
    PATHS "${_MATH_SDK}/usr/lib/swift")
  find_path(math_IMPLIB
    NAMES "libm.tbd"
    PATHS "${_MATH_SDK}/usr/lib")
  add_library(math SHARED IMPORTED GLOBAL)
  set_target_properties(math PROPERTIES
    IMPORTED_IMPLIB "${math_IMPLIB}"
    INTERFACE_INCLUDE_DIRECTORIES "${math_INCLUDE_DIR}")
  find_package_handle_standard_args(math DEFAULT_MSG
    math_IMPLIB math_INCLUDE_DIR)
elseif(LINUX)
  if(math_STATIC)
    find_path(math_INCLUDE_DIR
      "_math.swiftinterface"
      HINTS "${Swift_SDKROOT}/usr/lib/swift_static")
    find_library(math_LIBRARY
      NAMES "libm.a"
      HINTS "${Swift_SDKROOT}/usr/lib/swift_static/linux")
    add_library(math STATIC IMPORTED GLOBAL)
  else()
    find_path(math_INCLUDE_DIR
      "_math.swiftinterface"
      HINTS "${Swift_SDKROOT}/usr/lib/swift")
    find_library(math_LIBRARY
      NAMES "libm.so"
      HINTS "${Swift_SDKROOT}/usr/lib/swift/linux")
    add_library(math SHARED IMPORTED GLOBAL)
  endif()
  set_target_properties(math PROPERTIES
    IMPORTED_LOCATION "${math_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${math_INCLUDE_DIR}")
  find_package_handle_standard_args(math DEFAULT_MSG
    math_LIBRARY math_INCLUDE_DIR)
else()
  # TODO: Windows
  message(FATAL_ERROR "Findmath.cmake module search not implemented for targeted platform\n")
endif()
