qtshadertools (msorvig fork)
============================

This is a patched fork of qtshadertools.

Branches named `<qt-branch>-<patch-set>` carry a single patch set on top of the
corresponding upstream branch. Combined patch sets are merged to the plain Qt
branch names (`6.11`, `6.12`, `dev`).

wasm-webgpu
-----------

WGSL shader generation for the WebGPU RHI backend, using Tint. Tint and its
dependencies - Abseil, SPIRV-Headers and SPIRV-Tools - are new third-party
submodules. Requires the companion qtbase patches on the branch of the same
name.

Branches: `dev-wasm-webgpu`

- Generate WGSL with Tint
- Split combined image-samplers in SPIR-V before Tint conversion
