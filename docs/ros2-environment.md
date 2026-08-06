# ROS 2 Development Environment Contract

This document defines the user-visible capabilities provided by an **althack ROS 2 development environment**.

The contract describes expected behavior rather than a specific implementation. An environment may satisfy this contract through a container image, Dev Container Feature, Dev Container Template, or a composition of those components.

The intent is to allow the underlying implementation to evolve while preserving a consistent ROS 2 development experience.

## 1. Scope

A conforming ROS 2 development environment MUST provide the tools and configuration required to develop ROS 2 packages interactively inside a container.

The environment is intended for:

* ROS 2 package development
* multi-package and multi-repository workspaces
* C++ and Python development
* building and testing with `colcon`
* dependency management with `rosdep`
* repository import with `vcstool`
* debugging
* ROS linting and static analysis
* use from VS Code Dev Containers or compatible container tooling

GUI forwarding, GPU acceleration, simulation-specific configuration, and editor extensions are complementary capabilities and are not required by this core contract unless explicitly stated by a higher-level template.

---

## 2. Supported ROS Distribution

A conforming environment MUST expose a supported ROS 2 distribution through:

```bash
ROS_DISTRO
```

The corresponding ROS installation MUST be available under:

```bash
/opt/ros/${ROS_DISTRO}
```

The set of supported ROS distributions MAY change as distributions reach upstream end-of-life.

Support for a ROS distribution SHOULD normally end when upstream ROS support for that distribution ends.

---

## 3. Non-Root Development

Interactive development MUST be possible as a non-root user.

The development user MUST:

* have a valid home directory
* have a usable interactive shell
* own or be able to write to the development workspace
* be able to install or modify development files without requiring the container to run as root

Passwordless `sudo` SHOULD be available where appropriate for the environment.

The contract does not require a particular username, UID, or GID.

Implementations SHOULD cooperate with Dev Container UID/GID mapping rather than requiring a fixed numeric identity.

Implementations MUST NOT assume that the development user is named `ros`, `ubuntu`, or `vscode`.

---

## 4. ROS Environment

An interactive shell for the development user MUST have access to the selected ROS 2 installation.

At minimum, the equivalent of the following environment MUST be available:

```bash
source /opt/ros/${ROS_DISTRO}/setup.bash
```

An implementation MAY provide this automatically through shell initialization, container initialization, or another mechanism.

A workspace overlay SHOULD also be sourced automatically when an appropriate workspace setup file exists.

For a workspace located at `$WORKSPACE`, the environment SHOULD recognize:

```bash
$WORKSPACE/install/setup.bash
```

or an equivalent shell-specific setup file.

The absence of a built workspace MUST NOT cause shell startup to fail.

---

## 5. ROS Workspace Tooling

The following commands MUST be available:

```bash
colcon
rosdep
vcs
```

The environment MUST support the normal ROS 2 workspace workflow:

```bash
vcs import
rosdep install
colcon build
colcon test
colcon test-result
```

Shell completion for `colcon` SHOULD be enabled when supported by the selected shell.

---

## 6. Build Toolchain

The environment MUST contain the tooling necessary to build normal ROS 2 C++ and Python packages.

At minimum, the environment MUST provide equivalent functionality to:

```text
C/C++ compiler toolchain
make or equivalent build tooling
CMake
Python 3
pip or equivalent Python package installation support
```

The following commands SHOULD be available directly:

```bash
cmake
gcc
g++
python3
pip3
```

The contract intentionally does not require specific Debian package names.

---

## 7. Debugging

A conforming development environment MUST support debugging native ROS 2 programs.

At minimum:

```bash
gdb
```

or an equivalent supported debugger MUST be available.

The environment SHOULD support debugging through VS Code when used with an appropriate editor configuration.

---

## 8. Source Control and Repository Access

The environment MUST provide Git.

```bash
git
```

MUST be available.

An SSH client SHOULD be available so repositories can be fetched using SSH-based Git remotes.

Typical development operations such as the following MUST be possible:

```bash
git clone
git fetch
git checkout
```

Multi-repository ROS workspaces SHOULD be usable with `vcstool`.

---

## 9. Dependency Management

`rosdep` MUST be installed and usable.

A conforming environment MUST be capable of resolving dependencies with commands such as:

```bash
rosdep install --from-paths src --ignore-src
```

The environment SHOULD ensure that rosdep has been initialized appropriately.

Initialization MUST be safe to perform repeatedly or otherwise handle an already-initialized rosdep configuration without making the environment unusable.

---

## 10. ROS Development Tools

The environment MUST provide the common ROS 2 development tooling expected for development against the selected distribution.

Where available for the distribution, the environment SHOULD provide the functionality supplied by the upstream ROS development tooling packages, including tools used for:

* building
* testing
* dependency inspection
* package development
* workspace development

Implementations SHOULD prefer upstream ROS development metapackages where they provide the required functionality rather than maintaining unnecessarily large independent package lists.

---

## 11. Linting and Static Analysis

The environment SHOULD provide the standard ament lint tools used by ROS 2 projects.

Where available for the selected distribution, this includes functionality equivalent to:

```text
ament_cpplint
ament_cppcheck
ament_lint_cmake
ament_flake8
ament_mypy
ament_pep257
ament_uncrustify
ament_xmllint
```

The corresponding command-line tools SHOULD be discoverable through the environment.

The environment SHOULD support the `vscode-ament-task-provider` problem matchers and tasks where that extension is installed.

Additional linters MAY be provided.

The exact set MAY differ between ROS distributions according to upstream availability.

---

## 12. Shell Experience

Interactive shells SHOULD provide a development-friendly environment.

The environment SHOULD include:

* shell completion
* ROS environment setup
* `colcon` completion where available
* standard command-line utilities commonly needed during development

Shell initialization MUST remain usable when:

* the workspace has not yet been built
* no workspace overlay exists
* optional ROS tooling is unavailable
* the user starts multiple shells

Shell setup SHOULD be idempotent.

---

## 13. Workspace Behavior

The environment MUST support a conventional ROS 2 workspace layout:

```text
workspace/
├── src/
├── build/
├── install/
└── log/
```

Only `src/` is expected to exist initially.

The environment MUST NOT require `build/`, `install/`, or `log/` to exist before first use.

The development user MUST be able to create and modify these directories.

The workspace path MUST NOT be hard-coded to a particular repository name.

---

## 14. Container Entrypoint Behavior

A conforming environment MAY use a ROS-aware entrypoint.

If an entrypoint is provided, it SHOULD make the base ROS environment available before executing the requested command.

The entrypoint MUST forward arbitrary commands correctly and MUST NOT require the container to be launched into an interactive shell.

For example, both of these styles SHOULD remain possible:

```bash
docker run IMAGE bash
```

and:

```bash
docker run IMAGE ros2 --help
```

where supported by the underlying container configuration.

---

## 15. Dev Container Compatibility

When used as a Dev Container Feature, the ROS 2 environment MUST cooperate with the Dev Container user selected by the surrounding configuration.

The Feature SHOULD use the effective development-user information supplied by the Dev Container runtime rather than assuming fixed values.

In particular, user-specific configuration SHOULD be applied to the effective remote user's home directory.

The Feature SHOULD work when applied to:

* a compatible Ubuntu base image without ROS installed
* an upstream `ros:*` image
* an upstream `osrf/ros:*` image
* an althack compatibility image

When ROS is already installed and compatible with the requested configuration, the implementation SHOULD reuse the existing ROS installation rather than unnecessarily reinstalling it.

---

## 16. Existing ROS Installations

A conforming implementation SHOULD detect an existing ROS installation.

When a compatible installation exists:

```bash
/opt/ros/${ROS_DISTRO}
```

the environment SHOULD augment it with the required development capabilities.

It SHOULD NOT replace or downgrade an existing ROS installation solely to reproduce a particular image layout.

If the requested ROS distribution conflicts with the existing installation, the implementation MUST either:

* fail with a clear error, or
* use a documented deterministic resolution policy.

It MUST NOT silently construct an ambiguous mixed-distribution environment.

---

## 17. Distribution Selection

When the ROS distribution is explicitly requested, the implementation MUST honor that selection when compatible with the base operating system.

When the distribution is set to automatic selection, the implementation SHOULD select the recommended supported ROS 2 distribution for the underlying Ubuntu release.

Unsupported ROS/Ubuntu combinations MUST fail clearly rather than proceeding with a partially configured environment.

---

## 18. ROS Installation Variants

When the implementation is responsible for installing ROS, it MAY support different ROS metapackage levels such as:

```text
ros-base
desktop
desktop-full
```

The selected variant determines the ROS payload, not the baseline development capabilities.

For example, choosing `ros-base` MUST NOT remove required development tooling such as `colcon`, `rosdep`, the compiler toolchain, or Git.

When the base image already contains a larger ROS installation than requested, the implementation SHOULD preserve that installation rather than attempting to remove packages.

---

## 19. GUI and Display Support

GUI forwarding is outside the core ROS 2 development contract.

ROS applications that require X11, XWayland, Wayland, or other host display integration MAY require a separate Dev Container Feature or template configuration.

For the althack ecosystem, display-forwarding behavior SHOULD be owned by dedicated display Features rather than duplicated inside the ROS 2 Feature.

The ROS 2 Feature MUST NOT require a graphical host.

A headless ROS 2 development workflow MUST remain supported.

---

## 20. GPU Acceleration

GPU acceleration is outside the core ROS 2 development contract.

NVIDIA, Intel, AMD, WSL GPU passthrough, CUDA, and graphics-runtime configuration MAY be provided by:

* specialized base images
* additional Dev Container Features
* higher-level Dev Container Templates

The ROS 2 Feature SHOULD remain usable without GPU access.

---

## 21. Simulation

Gazebo or other simulation environments are not required by the core ROS 2 contract.

Simulation support MAY be composed with the ROS 2 development environment through:

* upstream ROS simulation images
* Gazebo images
* Dev Container Features
* Dev Container Templates

ROS/Gazebo compatibility SHOULD be validated at the composition or template level.

---

## 22. VS Code Integration

VS Code is a supported development environment but is not required for the underlying ROS tooling to function.

A higher-level althack Dev Container Template or workspace MAY install and configure extensions such as:

* C/C++ tooling
* Python tooling
* ROS tooling
* `vscode-ament-task-provider`
* formatting extensions
* container tooling

The ROS 2 Feature SHOULD avoid owning editor-specific configuration unless that configuration is necessary for the Feature itself.

Command-line workflows MUST remain functional without VS Code.

---

## 23. Backward Compatibility

Changes to the implementation SHOULD preserve the capabilities defined by this document.

The following changes are not inherently breaking:

* replacing a custom ROS image with an upstream OSRF image
* changing Debian package composition
* changing how ROS is installed
* changing the development username
* changing shell initialization implementation
* moving functionality from an image into a Feature

provided that the externally visible capabilities defined here continue to work.

A change that removes a REQUIRED capability from this document is considered a breaking change to the development environment.

---

## 24. Conformance Testing

Implementations claiming conformance SHOULD be tested behaviorally rather than by inspecting installed package lists.

A basic conformance suite SHOULD verify at least:

```bash
test "$(id -u)" -ne 0

test -n "${ROS_DISTRO}"
test -d "/opt/ros/${ROS_DISTRO}"

command -v ros2
command -v colcon
command -v rosdep
command -v vcs

command -v cmake
command -v gcc
command -v g++
command -v gdb

command -v git
command -v ssh

command -v python3
```

Where supported by the distribution, tests SHOULD also verify representative ament tools:

```bash
command -v ament_cpplint
command -v ament_cppcheck
command -v ament_flake8
command -v ament_pep257
command -v ament_uncrustify
command -v ament_xmllint
```

A stronger integration test SHOULD create or provide a small ROS 2 workspace and verify:

```bash
rosdep install --from-paths src --ignore-src -y

colcon build

source install/setup.bash

colcon test

colcon test-result
```

The same behavioral tests SHOULD, where practical, be run against:

* the `ros2` Dev Container Feature
* maintained `althack/ros2` images
* higher-level ROS 2 Dev Container Templates

This allows implementations to change independently while preserving a consistent user experience.

---

## 25. Current Implementation Strategy

During the transition from custom ROS images toward greater use of upstream ROS images, the following implementations MAY coexist:

```text
althack/ros2 images
    legacy-compatible implementation

althack ros2 Dev Container Feature
    composable implementation

althack Dev Container Templates
    recommended compositions
```

The custom images may continue to provide compatibility for ROS distributions or host environments where the upstream images do not yet provide a suitable foundation.

New functionality that represents general ROS 2 development behavior SHOULD preferentially be implemented in the ROS 2 Dev Container Feature rather than added only to the custom images.

Image-specific functionality SHOULD be limited to behavior that materially benefits from being baked into an image.

---

## 26. Design Principle

The long-term architecture SHOULD follow this division of responsibility:

```text
Base image
    Provides the operating system and ROS payload.

ROS 2 Feature
    Provides the ROS development experience.

Display/GPU Features
    Provide host integration where required.

Dev Container Template
    Provides a tested, opinionated composition.

Workspace
    Provides project-specific build, test, debug, CI,
    and editor configuration.
```

This contract exists so that those implementation boundaries can evolve without changing what developers expect from an althack ROS 2 development environment.
