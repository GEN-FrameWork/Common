# GEN Framework installer

Cross-platform installer under `Common/Scripts/install`. Use it to clone or update the GEN tree, install the Android SDK/NDK, and compile Examples, Tests, or Utilities.

| Host | Launcher |
|------|----------|
| Windows | `install.bat` |
| Linux / WSL | `install.bash` |

Both launchers call `install.py`. Commands are **uppercase**; the framework path must be an **absolute** path.

```text
install.bat  <COMMAND> <TARGET> <absolute_path>     (Windows)
install.bash <COMMAND> <TARGET> <absolute_path>     (Linux / WSL)
```

Run with no arguments to print the built-in help.

---

## Prerequisites

### Common (Windows and Linux)

- **Git** (HTTPS clone/pull from GitLab)
- **Python 3** available as `python` (Windows) or `python3` / `python` (Linux)

Source repositories: `https://gitlab.genframework.com/gen_framework` (branch `develop`).

### Windows (native compile)

Native `COMPILE` uses the Microsoft toolchain:

- **Visual Studio 2022** with C++ desktop workload (MSVC, Windows SDK)
- **CMake** (used by the GEN compile scripts)
- Optional for Android on Windows: **JDK** (required by Android `sdkmanager`) plus the Android SDK/NDK installed via this installer (see below)

`DOCKER` is **not** used on Windows; `compile.bat` drives local MSVC builds.

### Linux / WSL (Docker compile)

`COMPILE` on Linux is invoked with **`DOCKER`**. You need:

- **Docker** installed and working for your user (`docker build` / `docker run`)
- On **WSL2**, a working Docker setup (Docker Desktop with WSL integration, or Docker Engine inside the distro)
- Enough disk space for compiler images (`gen_compiler_image_*`)

The framework tree is mounted into the container at the **same absolute host path**. Any folder name is fine (for example `/home/user/genframework`); it no longer has to be called `GEN_FrameWork`.

---

## 1. Download GEN (`INSTALL GEN`)

Creates the target directory if needed and clones all framework repositories on `develop` over HTTPS:

`Common`, `GEN`, `ThirdPartyLibraries`, `Examples`, `Resources`, `Tests`, `Utilities`, `Documents`

Before cloning, the installer prints the latest GEN version from remote tags.

### Windows

```bat
install.bat INSTALL GEN C:\GENFrameWork
```

### Linux / WSL

```bash
./install.bash INSTALL GEN /home/user/genframework
```

Notes:

- The path must not already contain those repo folders (or the command fails).
- Use an absolute path.
- After install, further commands must use the **same** path.

---

## 2. Update GEN (`UPDATE GEN`)

Requires that the target directory already exists. Runs `git fetch` / `checkout develop` / `pull` on each repository and shows the latest GEN tag first.

### Windows

```bat
install.bat UPDATE GEN C:\GENFrameWork
```

### Linux / WSL

```bash
./install.bash UPDATE GEN /home/user/genframework
```

---

## 3. Android SDK / NDK (`INSTALL ANDROID_NDK-SDK`)

Only needed if you will build **Android** targets (`ANDROID32` / `ANDROID64`). The GEN compile scripts enable Android automatically when a matching host SDK/NDK is present under `ThirdPartyLibraries`.

Requires:

- `<absolute_path>/ThirdPartyLibraries` already present (typically after `INSTALL GEN`)
- Scripts at `<absolute_path>/Common/Scripts/android_ndk-sdk`
- **Java (JDK)** on `PATH` for `sdkmanager`

The installer runs the host-specific script:

| Host | Script used | Installs into |
|------|-------------|-----------------|
| Windows | `InstallAndroidNDK-SDK.bat` | `ThirdPartyLibraries\android-sdk` and `android-ndk` (Windows flavor) |
| Linux / WSL | `InstallAndroidNDK-SDK.bash` | same folders (Linux flavor) |

Only **one** host flavor can live in those folders at a time. Install on the OS where you compile.

### Windows

```bat
install.bat INSTALL ANDROID_NDK-SDK C:\GENFrameWork
```

### Linux / WSL

```bash
./install.bash INSTALL ANDROID_NDK-SDK /home/user/genframework
```

---

## 4. Compile Examples, Tests, Utilities, or all (`COMPILE`)

Uses `<absolute_path>/Common/Scripts/compile` (`compile.bat` / `compile.bash`).

On each run the installer:

1. Reads the current `listapp.txt` from that tree (the list can change over time)
2. Filters applications by folder (`Examples`, `Tests`, `Utilities`, or all)
3. Calls compile with only those app names

| Target | What gets compiled |
|--------|--------------------|
| `EXAMPLES` | Entries under `Examples/` in `listapp.txt` |
| `TESTS` | Entries under `Tests/` |
| `UTILITIES` | Entries under `Utilities/` |
| `ALL` | Every entry in `listapp.txt` |

### Windows

Native MSVC compile (no `DOCKER`):

```bat
install.bat COMPILE EXAMPLES   C:\GENFrameWork
install.bat COMPILE TESTS      C:\GENFrameWork
install.bat COMPILE UTILITIES  C:\GENFrameWork
install.bat COMPILE ALL        C:\GENFrameWork
```

Typical platforms include `INTEL32` / `INTEL64`. Android platforms are added when the Windows Android SDK/NDK is installed.

### Linux / WSL

Compile is called with **`DOCKER`** (images per platform, container build):

```bash
./install.bash COMPILE EXAMPLES   /home/user/genframework
./install.bash COMPILE TESTS      /home/user/genframework
./install.bash COMPILE UTILITIES  /home/user/genframework
./install.bash COMPILE ALL        /home/user/genframework
```

Typical platforms include `INTEL64`, `ARM64`, `RPI64`, and Android when the Linux SDK/NDK is installed. The first run builds Docker images and can take a long time.

---

## Suggested flow

1. Install prerequisites for your host (Git, Python; plus VS 2022 on Windows, or Docker on Linux/WSL).
2. `INSTALL GEN` into an absolute path.
3. Optional: `INSTALL ANDROID_NDK-SDK` if you need Android builds on that same host.
4. `COMPILE EXAMPLES` (or `TESTS` / `UTILITIES` / `ALL`).
5. Later: `UPDATE GEN` then compile again as needed.

---

## Quick reference

```bat
REM Windows
install.bat INSTALL GEN C:\GENFrameWork
install.bat UPDATE GEN C:\GENFrameWork
install.bat INSTALL ANDROID_NDK-SDK C:\GENFrameWork
install.bat COMPILE EXAMPLES C:\GENFrameWork
```

```bash
# Linux / WSL
./install.bash INSTALL GEN /home/user/genframework
./install.bash UPDATE GEN /home/user/genframework
./install.bash INSTALL ANDROID_NDK-SDK /home/user/genframework
./install.bash COMPILE EXAMPLES /home/user/genframework
```
