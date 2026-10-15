# Copyright (C) 2024 The Qt Company Ltd.
# SPDX-License-Identifier: BSD-3-Clause

#####################################################################
## BundledTint Generic Library:
##
## Minimal Tint build for SPIR-V to WGSL translation only.
## This builds a subset of Google's Tint compiler sufficient for
## converting SPIR-V shaders to WGSL for WebGPU.
#####################################################################

if(NOT QT_FEATURE_shadertools_tint)
    return()
endif()

# Tint requires C++17
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(TINT_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/tint")

# Abseil (required by Tint) is bundled as a submodule. Tint only uses
# absl::from_chars, so the handful of sources behind it are compiled into
# BundledTint below instead of building Abseil's own targets.
set(ABSEIL_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/abseil")
if(NOT EXISTS "${ABSEIL_ROOT_DIR}/absl")
    message(STATUS "Abseil source not found at ${ABSEIL_ROOT_DIR}, skipping BundledTint. "
                   "Run: git submodule update --init --recursive src/3rdparty/abseil")
    return()
endif()

# SPIRV-Headers and SPIRV-Tools are bundled as submodules as well. Tint's own
# third_party/ copies of them are not used.
set(SPIRV_HEADERS_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/spirv-headers")
set(SPIRV_TOOLS_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/spirv-tools")
if(NOT EXISTS "${SPIRV_HEADERS_ROOT_DIR}/include" OR NOT EXISTS "${SPIRV_TOOLS_ROOT_DIR}/source")
    message(STATUS "SPIRV-Headers or SPIRV-Tools source not found, skipping BundledTint. "
                   "Run: git submodule update --init --recursive src/3rdparty")
    return()
endif()

# Check if Tint source is available
if(NOT EXISTS "${TINT_ROOT_DIR}/src/tint")
    message(STATUS "Tint source not found at ${TINT_ROOT_DIR}, skipping BundledTint")
    return()
endif()

# Collect Tint source files for minimal SPIR-V reader and WGSL writer build
# The file list is based on Tint's BUILD.gn structure

# Core utility files
file(GLOB TINT_UTILS_SOURCES
    "${TINT_ROOT_DIR}/src/tint/utils/containers/*.cc"
    "${TINT_ROOT_DIR}/src/tint/utils/debug/*.cc"
    "${TINT_ROOT_DIR}/src/tint/utils/diagnostic/*.cc"
    "${TINT_ROOT_DIR}/src/tint/utils/generator/*.cc"
    "${TINT_ROOT_DIR}/src/tint/utils/ice/*.cc"
    "${TINT_ROOT_DIR}/src/tint/utils/id/*.cc"
    "${TINT_ROOT_DIR}/src/tint/utils/macros/*.cc"
    "${TINT_ROOT_DIR}/src/tint/utils/math/*.cc"
    "${TINT_ROOT_DIR}/src/tint/utils/memory/*.cc"
    "${TINT_ROOT_DIR}/src/tint/utils/reflection/*.cc"
    "${TINT_ROOT_DIR}/src/tint/utils/result/*.cc"
    "${TINT_ROOT_DIR}/src/tint/utils/rtti/*.cc"
    "${TINT_ROOT_DIR}/src/tint/utils/strconv/*.cc"
    "${TINT_ROOT_DIR}/src/tint/utils/symbol/*.cc"
    "${TINT_ROOT_DIR}/src/tint/utils/text/*.cc"
)

# Core language/AST files
file(GLOB TINT_LANG_CORE_SOURCES
    "${TINT_ROOT_DIR}/src/tint/lang/core/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/core/constant/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/core/intrinsic/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/core/ir/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/core/ir/transform/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/core/ir/transform/common/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/core/type/*.cc"
)

# WGSL-specific files
file(GLOB TINT_LANG_WGSL_SOURCES
    "${TINT_ROOT_DIR}/src/tint/lang/wgsl/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/wgsl/ast/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/wgsl/ast/transform/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/wgsl/features/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/wgsl/helpers/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/wgsl/inspector/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/wgsl/intrinsic/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/wgsl/ir/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/wgsl/program/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/wgsl/reader/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/wgsl/reader/lower/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/wgsl/reader/parser/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/wgsl/reader/program_to_ir/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/wgsl/resolver/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/wgsl/sem/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/wgsl/writer/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/wgsl/writer/ast_printer/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/wgsl/writer/ir_to_program/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/wgsl/writer/raise/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/wgsl/writer/syntax_tree_printer/*.cc"
)

# SPIR-V reader files (including ast_parser which requires SPIRV-Tools)
file(GLOB TINT_LANG_SPIRV_SOURCES
    "${TINT_ROOT_DIR}/src/tint/lang/spirv/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/spirv/intrinsic/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/spirv/ir/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/spirv/reader/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/spirv/reader/ast_lower/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/spirv/reader/ast_parser/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/spirv/reader/common/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/spirv/reader/lower/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/spirv/reader/parser/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/spirv/validate/*.cc"
    "${TINT_ROOT_DIR}/src/tint/lang/spirv/type/*.cc"
)

# API files
file(GLOB TINT_API_SOURCES
    "${TINT_ROOT_DIR}/src/tint/api/*.cc"
    "${TINT_ROOT_DIR}/src/tint/api/common/*.cc"
)

# Combine all sources
set(TINT_ALL_SOURCES
    ${TINT_UTILS_SOURCES}
    ${TINT_LANG_CORE_SOURCES}
    ${TINT_LANG_WGSL_SOURCES}
    ${TINT_LANG_SPIRV_SOURCES}
    ${TINT_API_SOURCES}
)

# Filter out test files
list(FILTER TINT_ALL_SOURCES EXCLUDE REGEX "_test\\.cc$")
list(FILTER TINT_ALL_SOURCES EXCLUDE REGEX "_bench\\.cc$")
list(FILTER TINT_ALL_SOURCES EXCLUDE REGEX "test_helper\\.cc$")
list(FILTER TINT_ALL_SOURCES EXCLUDE REGEX "fuzz\\.cc$")

# Remove writer backends we don't need (HLSL, MSL, GLSL - we only want WGSL)
list(FILTER TINT_ALL_SOURCES EXCLUDE REGEX "/lang/hlsl/")
list(FILTER TINT_ALL_SOURCES EXCLUDE REGEX "/lang/msl/")
list(FILTER TINT_ALL_SOURCES EXCLUDE REGEX "/lang/glsl/")
# Remove SPIR-V writer (we only need reader)
list(FILTER TINT_ALL_SOURCES EXCLUDE REGEX "/lang/spirv/writer/")

# Remove platform-specific files for other platforms
if(NOT WIN32)
    list(FILTER TINT_ALL_SOURCES EXCLUDE REGEX "_windows\\.cc$")
else()
    list(FILTER TINT_ALL_SOURCES EXCLUDE REGEX "_posix\\.cc$")
    list(FILTER TINT_ALL_SOURCES EXCLUDE REGEX "_other\\.cc$")
endif()
if(NOT APPLE)
    list(FILTER TINT_ALL_SOURCES EXCLUDE REGEX "_mac\\.cc$")
    list(FILTER TINT_ALL_SOURCES EXCLUDE REGEX "_macos\\.cc$")
endif()
if(NOT UNIX OR APPLE)
    list(FILTER TINT_ALL_SOURCES EXCLUDE REGEX "_linux\\.cc$")
endif()

# The Abseil sources behind absl::from_chars.
set(TINT_ABSEIL_SOURCES
    "${ABSEIL_ROOT_DIR}/absl/strings/charconv.cc"
    "${ABSEIL_ROOT_DIR}/absl/strings/internal/charconv_bigint.cc"
    "${ABSEIL_ROOT_DIR}/absl/strings/internal/charconv_parse.cc"
    "${ABSEIL_ROOT_DIR}/absl/strings/internal/memutil.cc"
)

# SPIRV-Tools is built with its own CMake (it generates headers, and needs a
# Python 3 interpreter for that), always as static, position-independent
# libraries since their objects end up in BundledTint.
set(_qt_tint_saved_build_shared_libs "${BUILD_SHARED_LIBS}")
set(BUILD_SHARED_LIBS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(SPIRV-Headers_SOURCE_DIR "${SPIRV_HEADERS_ROOT_DIR}")
set(SPIRV_SKIP_EXECUTABLES ON)
set(SPIRV_SKIP_TESTS ON)
set(SPIRV_WERROR OFF)
set(SPIRV_BUILD_FUZZER OFF)
set(SKIP_SPIRV_TOOLS_INSTALL ON)
add_subdirectory("${SPIRV_TOOLS_ROOT_DIR}" "${CMAKE_CURRENT_BINARY_DIR}/spirv-tools" EXCLUDE_FROM_ALL)
set(BUILD_SHARED_LIBS "${_qt_tint_saved_build_shared_libs}")

qt_internal_add_3rdparty_library(BundledTint
    QMAKE_LIB_NAME tint
    SKIP_AUTOMOC
    STATIC
    EXCEPTIONS
    SOURCES
        ${TINT_ALL_SOURCES}
        ${TINT_ABSEIL_SOURCES}
    INCLUDE_DIRECTORIES
        "${TINT_ROOT_DIR}"
        "${TINT_ROOT_DIR}/src"
        "${TINT_ROOT_DIR}/include"
        "${SPIRV_HEADERS_ROOT_DIR}/include"
        "${SPIRV_TOOLS_ROOT_DIR}"
        "${SPIRV_TOOLS_ROOT_DIR}/include"
        "${CMAKE_CURRENT_BINARY_DIR}/spirv-tools"
        "${ABSEIL_ROOT_DIR}"
    DEFINES
        # Disable features we don't need
        TINT_BUILD_SPV_READER=1
        TINT_BUILD_WGSL_WRITER=1
        TINT_BUILD_SPV_WRITER=0
        TINT_BUILD_WGSL_READER=0
        TINT_BUILD_HLSL_WRITER=0
        TINT_BUILD_MSL_WRITER=0
        TINT_BUILD_GLSL_WRITER=0
        TINT_BUILD_GLSL_VALIDATOR=0
        TINT_BUILD_SYNTAX_TREE_WRITER=0
)

# Tint's own build selects its platform code with these.
if(WIN32)
    target_compile_definitions(BundledTint PRIVATE TINT_BUILD_IS_WIN=1)
endif()

qt_disable_warnings(BundledTint)
qt_set_symbol_visibility_hidden(BundledTint)

# Fold the SPIRV-Tools objects into BundledTint rather than linking the
# SPIRV-Tools targets. Those are not part of Qt's export set, so in a static Qt
# (every wasm build) they could not appear in BundledTint's link interface;
# this way BundledTint is self-contained and gets installed and exported like
# any other bundled library. QtShaderTools uses the SPIRV-Tools optimizer
# directly as well, and gets it from here.
target_sources(BundledTint PRIVATE
    $<TARGET_OBJECTS:SPIRV-Tools-opt>
    $<TARGET_OBJECTS:SPIRV-Tools-static>
)
add_dependencies(BundledTint SPIRV-Tools-opt SPIRV-Tools-static)

# Tint uses some complex templates that can cause unity build issues
set_target_properties(BundledTint PROPERTIES UNITY_BUILD OFF)
