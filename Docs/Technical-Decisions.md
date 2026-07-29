# Technical decisions

## Bootstrap scope

This setup deliberately stops at reliable source control, testing, packaging,
archival, dashboarding, and release delivery. It does not yet add online sessions,
replicated combat, boar gameplay, gathering, defense construction, or the day/night
loop.

The intended future modes are:

- single-player;
- two players on one desktop using a shared camera;
- two computers over LAN.

Hybrid local/network parties are not planned. Network architecture should be decided after the jam prototype proves the core loop.

The shared camera should show the complete active playing area. Distant neighbor
interactions are intentionally unresolved until the team chooses between visits,
deliveries/remote contact, or a separate travel transition. Neighbor interaction is
outside Phase 1.

## Blueprint baseline

Gameplay starts Blueprint-only so both developers can iterate in the Editor. Unreal itself and some template/plugin functionality still use C++ internally, and the build machine therefore retains the Visual Studio toolchain. A project `Source/` directory should only be introduced by an explicit team decision.

The Blueprint/content module boundaries, public interfaces, composition rules, and
test-driven delivery gates are documented in the
[Architecture index](../Architecture/README.md). In that documentation, “module”
means a logical Blueprint/content boundary rather than an Unreal C++ module.

## Rendering

The Windows desktop baseline keeps Maximum quality, DX12, Shader Model 6, Lumen, Nanite, virtual shadows, and mesh distance fields. Hardware ray tracing is disabled to reduce shader/build cost and avoid narrowing supported jam hardware.

## Delivery model

`master` is trunk. Every detected push produces a tested Development-configuration package for `windows-test`. A successful archived Test Build ID can be promoted unchanged to `windows-dev`; promotion never rebuilds the package. Immutable `vMAJOR.MINOR.PATCH` tags produce independent Shipping builds for `windows`.

Active work, cooking, Intermediate, and Derived Data Cache stay on the build server SSD. The slower `D:` HDD is only for completed immutable run archives, manifests, logs, reports, checksums, and the generated dashboard.
