include(CheckSourceCompiles)
include(CheckCompilerFlag)

# Use C++17.
set(SwiftStdlib_MIN_CXX_STANDARD 17)

# Unset CMAKE_CXX_STANDARD if it's too low and in the CMakeCache.txt
if($CACHE{CMAKE_CXX_STANDARD} AND $CACHE{CMAKE_CXX_STANDARD} LESS ${SwiftStdlib_MIN_CXX_STANDARD})
  message(WARNING "Resetting cache value for CMAKE_CXX_STANDARD to ${SwiftStdlib_MIN_CXX_STANDARD}")
  unset(CMAKE_CXX_STANDARD CACHE)
endif()

# Allow manually specified CMAKE_CXX_STANDARD if it's greater than the minimum
# required C++ version
if(DEFINED CMAKE_CXX_STANDARD AND CMAKE_CXX_STANDARD LESS ${SwiftStdlib_MIN_CXX_STANDARD})
  message(FATAL_ERROR "Requested CMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD} which is less than the minimum C++ standard ${SwiftStdlib_MIN_CXX_STANDARD}")
endif()

set(CMAKE_CXX_STANDARD ${SwiftStdlib_MIN_CXX_STANDARD} CACHE STRING "C++ standard to conform to")
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS NO)

check_source_compiles(CXX
"#if !__has_attribute(swiftcall)
#error CXX compiler must support Swift calling conventions
#endif
int main(void) { return 0; }"
HAVE_SWIFTCALL)

if(NOT HAVE_SWIFTCALL)
  message(SEND_ERROR "CXX compiler must support Swift calling conventions")
endif()

check_compiler_flag(CXX "-Wformat-nonliteral -Werror=format-nonliteral" HAVE_WFORMAT_NONLITERAL)
if(HAVE_WFORMAT_NONLITERAL)
  add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:-Wformat-nonliteral$<SEMICOLON>-Werror=format-nonliteral>)
endif()

check_compiler_flag(CXX  "-Wglobal-constructors -Werror=global-constructors" HAVE_WGLOBAL_CONSTRUCTORS)
if(HAVE_WGLOBAL_CONSTRUCTORS)
  add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:-Wglobal-constructors$<SEMICOLON>-Werror=global-constructors>)
endif()

check_compiler_flag(Swift "-diagnostic-style swift" HAVE_SWIFT_DIAGNOSTIC_STYLE)
if(HAVE_SWIFT_DIAGNOSTIC_STYLE)
  add_compile_options($<$<COMPILE_LANGUAGE:Swift>:-diagnostic-style$<SEMICOLON>swift>)
endif()

check_compiler_flag(Swift "-color-diagnostics" HAVE_SWIFT_COLOR_DIAGNOSTICS)
if(HAVE_SWIFT_COLOR_DIAGNOSTICS)
  add_compile_options($<$<COMPILE_LANGUAGE:Swift>:-color-diagnostics>)
endif()

check_compiler_flag(Swift "-Xfrontend -enable-ossa-modules" HAVE_SWIFT_OSSA_MODULES)
if(HAVE_SWIFT_OSSA_MODULES)
  add_compile_options("$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xfrontend -enable-ossa-modules>")
endif()

add_compile_options($<$<COMPILE_LANGUAGE:Swift>:-module-cache-path$<SEMICOLON>${CMAKE_BINARY_DIR}/module-cache>)

check_compiler_flag(Swift "-runtime-compatibility-version none" HAVE_SWIFT_COMPATIBILITY_VERSION)
if(HAVE_SWIFT_COMPATIBILITY_VERSION)
  add_compile_options($<$<COMPILE_LANGUAGE:Swift>:-runtime-compatibility-version$<SEMICOLON>none>)
endif()

check_compiler_flag(Swift "-package-name my-package -Xfrontend
-experimental-package-cmo -Xfrontend -experimental-allow-non-resilient-access
-Xfrontend -experimental-package-bypass-resilience" HAVE_SWIFT_PACKAGE_CMO)
# FIXME: Hook up HAVE_SWIFT_PACKAGE_CMO

if(SwiftCore_ENABLE_INDEX_STORE)
  add_compile_options(-index-store-path "${CMAKE_BINARY_DIR}/IndexStore/index")
endif()
