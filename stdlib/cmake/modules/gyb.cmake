find_package(Python3 REQUIRED)

# FIXME: What do we do about gyb??? -- can we turn these into macros?
# Create a target to expand a gyb source
# target_name: Name of the target
# FLAGS  list of flags passed to gyb
# DEPENDS list of dependencies
# COMMENT Custom comment
function(gyb_expand source output)
  set(flags)
  set(arguments)
  set(multival_arguments FLAGS DEPENDS)
  cmake_parse_arguments(GYB "${flags}" "${arguments}" "${multival_arguments}" ${ARGN})

  get_filename_component(full_output_path ${output} ABSOLUTE BASE_DIR "${CMAKE_CURRENT_BINARY_DIR}")
  get_filename_component(dir "${full_output_path}" DIRECTORY)
  get_filename_component(fname "${full_output_path}" NAME)

  file(READ "${source}" gyb_src)
  string(REGEX MATCHALL "\\\$\{[\r\n\t ]*gyb.expand\\\([\r\n\t ]*[\'\"]([^\'\"]*)[\'\"]" gyb_expand_matches "${gyb_src}")
  foreach(match ${gyb_expand_matches})
    string(REGEX MATCH "[\'\"]\([^\'\"]*\)[\'\"]" gyb_dep "${match}")
    list(APPEND gyb_expand_deps "${CMAKE_MATCH_1}")
  endforeach()
  list(REMOVE_DUPLICATES gyb_expand_deps)

  # gyb tool location ${CMAKE_SOURCE_DIR}/../utils/gyb
  set(gyb_tool "${CMAKE_SOURCE_DIR}/../utils/gyb")

  # Extra tid-bits to track
  # FIXME: These sources need to migrate to the stdlib isolation chamber for
  #        repo splitting
  list(APPEND GYB_DEPENDS
    "${source}"
    "${CMAKE_SOURCE_DIR}/../utils/GYBUnicodeDataUtils.py"
    "${CMAKE_SOURCE_DIR}/../utils/SwiftIntTypes.py"
    "${CMAKE_SOURCE_DIR}/../utils/SwiftFloatingPointTypes.py"
    "${CMAKE_SOURCE_DIR}/../utils/UnicodeData/GraphemeBreakProperty.txt"
    "${CMAKE_SOURCE_DIR}/../utils/UnicodeData/GraphemeBreakTest.txt"
    "${CMAKE_SOURCE_DIR}/../utils/gyb_stdlib_support.py")
  add_custom_command(
    OUTPUT  "${full_output_path}"
    COMMAND "${CMAKE_COMMAND}" -E make_directory "${dir}"
    COMMAND "${CMAKE_COMMAND}" -E env "$<TARGET_FILE:Python3::Interpreter>" "${gyb_tool}" ${GYB_FLAGS} -o "${full_output_path}.tmp" "${source}"
    COMMAND "${CMAKE_COMMAND}" -E copy_if_different "${full_output_path}.tmp" "${full_output_path}"
    COMMAND "${CMAKE_COMMAND}" -E remove "${full_output_path}.tmp"
    DEPENDS ${gyb_tool} ${gyb_tool}.py ${GYB_DEPENDS} ${gyb_expand_deps}
    COMMENT "Generating GYB source ${fname} from ${source}"
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")
endfunction()
