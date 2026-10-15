# Copyright (C) 2022 The Qt Company Ltd.
# SPDX-License-Identifier: BSD-3-Clause

# Generated from src.pro.

# BundledTint is built before the ShaderTools module and depends on its features.
qt_feature_evaluate_features("${CMAKE_CURRENT_SOURCE_DIR}/shadertools/configure.cmake")

add_subdirectory(glslang)
add_subdirectory(SPIRV-Cross)
add_subdirectory(tint)
add_subdirectory(shadertools)
