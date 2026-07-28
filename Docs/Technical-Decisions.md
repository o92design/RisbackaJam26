# Technical decisions

## Bootstrap scope

This setup deliberately stops at reliable source control, testing, packaging, archival, dashboarding, and release delivery. It does not add EOS, Steam, online sessions, host/join UI, replicated combat, zombie AI, or base building.

The intended future modes are:

- single-player;
- two players on one desktop using split-screen;
- two computers over LAN.

Hybrid local/network parties are not planned. Network architecture should be decided after the jam prototype proves the core loop.

## Blueprint baseline

Gameplay starts Blueprint-only so both developers can iterate in the Editor. Unreal itself and some template/plugin functionality still use C++ internally, and the build machine therefore retains the Visual Studio toolchain. A project `Source/` directory should only be introduced by an explicit team decision.

## Rendering

The Windows desktop baseline keeps Maximum quality, DX12, Shader Model 6, Lumen, Nanite, virtual shadows, and mesh distance fields. Hardware ray tracing is disabled to reduce shader/build cost and avoid narrowing supported jam hardware.

## Delivery model

`master` is trunk. Every detected push produces a tested Development-configuration package for `windows-test`. A successful archived Test Build ID can be promoted unchanged to `windows-dev`; promotion never rebuilds the package. Immutable `vMAJOR.MINOR.PATCH` tags produce independent Shipping builds for `windows`.

Active work, cooking, Intermediate, and Derived Data Cache stay on the build server SSD. The slower `D:` HDD is only for completed immutable run archives, manifests, logs, reports, checksums, and the generated dashboard.
