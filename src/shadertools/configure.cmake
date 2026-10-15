# Copyright (C) 2026 The Qt Company Ltd.
# SPDX-License-Identifier: BSD-3-Clause

#### Features

# WGSL is only needed where the WebGPU backend exists. That includes the host
# tools (qsb) and wasm, where shaders generated at runtime (Qt Quick 3D) need
# translating as well.
qt_feature("shadertools-tint" PRIVATE
    LABEL "Tint (SPIR-V to WGSL)"
    PURPOSE "Enables WGSL generation in QShaderBaker using the bundled Tint compiler."
    AUTODETECT QT_FEATURE_webgpu
)

qt_configure_add_summary_section(NAME "Qt Shader Tools")
qt_configure_add_summary_entry(ARGS "shadertools-tint")
qt_configure_end_summary_section()
