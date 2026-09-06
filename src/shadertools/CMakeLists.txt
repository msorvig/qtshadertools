# Copyright (C) 2022 The Qt Company Ltd.
# SPDX-License-Identifier: BSD-3-Clause

# Generated from shadertools.pro.

#####################################################################
## ShaderTools Module:
#####################################################################

set(_shadertools_optional_libraries "")
if(TARGET Qt::BundledTint)
    list(APPEND _shadertools_optional_libraries Qt::BundledTint)
endif()

qt_internal_add_module(ShaderTools
    EXCEPTIONS
    SOURCES
        qshaderbaker.cpp qshaderbaker.h
        qshaderrewriter.cpp qshaderrewriter_p.h
        qspirvcompiler.cpp qspirvcompiler_p.h
        qspirvshader.cpp qspirvshader_p.h
        qspirvshaderremap.cpp qspirvshaderremap_p.h
        qtshadertoolsglobal.h
        qtshadertoolsglobal_p.h
    DEFINES
        QT_BUILD_SHADERTOOLS_LIB
        TINT_BUILD_SPV_READER=1
        TINT_BUILD_WGSL_WRITER=1
    INCLUDE_DIRECTORIES
        ../3rdparty/SPIRV-Cross
        ../3rdparty/glslang
        ../3rdparty/tint
        ../3rdparty/tint/src
        ../3rdparty/tint/include
    LIBRARIES
        Qt::GuiPrivate
# special case begin
        Qt::BundledSpirv_Cross
        Qt::BundledGlslang_Glslang
        Qt::BundledGlslang_Spirv
        Qt::BundledGlslang_Osdependent
        ${_shadertools_optional_libraries}
# special case end
    PUBLIC_LIBRARIES
        Qt::Core
        Qt::Gui
    PRIVATE_MODULE_INTERFACE
        Qt::GuiPrivate
    RHI_HEADER_FILTERS
        "(^|/)qshaderbaker\\.h$"
)

## Scopes:
#####################################################################

#### Keys ignored in scope 2:.:.:shadertools.pro:NOT EXISTS _ss_[QT_HOST_DATA]/.qmake.cache:
# LIBLOC = "$$shadowed($$dirname _QMAKE_CONF_)" "/lib"

#### Keys ignored in scope 3:.:.:shadertools.pro:else:
# LIBLOC = "$$[QT_HOST_LIBS]"
qt_internal_add_docs(ShaderTools
    doc/qtshadertools.qdocconf
)

