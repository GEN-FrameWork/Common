#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# GEN Framework - Android SDK / NDK installer for Linux
#
# Installs the Android development environment expected by GEN into:
#   ThirdPartyLibraries/android-sdk
#   ThirdPartyLibraries/android-ndk
#
# The package/version set is shared with InstallAndroid.bat through
# AndroidPackages.cfg.
# -----------------------------------------------------------------------------

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
GEN_ROOT="$(cd -- "${SCRIPT_DIR}/../../.." && pwd)"
THIRDPARTY_DIR="${GEN_ROOT}/ThirdPartyLibraries"
CONFIG_FILE="${SCRIPT_DIR}/AndroidPackages.cfg"
SDK_ROOT="${THIRDPARTY_DIR}/android-sdk"
NDK_ROOT="${THIRDPARTY_DIR}/android-ndk"
TMP_ROOT="${TMPDIR:-/tmp}/gen-android-install-$$"

FORCE=0
CHECK_ONLY=0
INSTALL_SDK=1
INSTALL_NDK=1

info() { printf '[GEN Android] %s\n' "$*"; }
warn() { printf '[GEN Android] WARNING: %s\n' "$*" >&2; }
die()  { printf '[GEN Android] ERROR: %s\n' "$*" >&2; exit 1; }

usage() {
  cat <<'USAGE'
GEN Framework Android environment installer (Linux)

Usage:
  ./InstallAndroid.bash [options]

Options:
  --check       Validate the current SDK/NDK installation; do not download.
  --force       Replace an existing SDK bootstrap/NDK when required.
  --sdk-only    Install or validate only the Android SDK.
  --ndk-only    Install or validate only the Android NDK.
  -h, --help    Show this help.

Environment:
  GEN_ANDROID_ACCEPT_LICENSES=1
                Automatically answer 'yes' to Android SDK license prompts.
                Otherwise sdkmanager --licenses is interactive.
USAGE
}

while (($#)); do
  case "$1" in
    --check) CHECK_ONLY=1 ;;
    --force) FORCE=1 ;;
    --sdk-only) INSTALL_NDK=0 ;;
    --ndk-only) INSTALL_SDK=0 ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $1" ;;
  esac
  shift
done

[[ -f "$CONFIG_FILE" ]] || die "Configuration file not found: $CONFIG_FILE"

# shellcheck disable=SC1090
source "$CONFIG_FILE"

: "${SDK_PLATFORM_TOOLS_MIN:?Missing SDK_PLATFORM_TOOLS_MIN in AndroidPackages.cfg}"
: "${SDK_BUILD_TOOLS_1:?Missing SDK_BUILD_TOOLS_1 in AndroidPackages.cfg}"
: "${SDK_BUILD_TOOLS_2:?Missing SDK_BUILD_TOOLS_2 in AndroidPackages.cfg}"
: "${SDK_PLATFORM_1:?Missing SDK_PLATFORM_1 in AndroidPackages.cfg}"
: "${SDK_PLATFORM_2:?Missing SDK_PLATFORM_2 in AndroidPackages.cfg}"
: "${SDK_PLATFORM_3:?Missing SDK_PLATFORM_3 in AndroidPackages.cfg}"
: "${NDK_REVISION:?Missing NDK_REVISION in AndroidPackages.cfg}"
: "${NDK_RELEASE:?Missing NDK_RELEASE in AndroidPackages.cfg}"
: "${CMDLINE_TOOLS_LINUX_URL:?Missing CMDLINE_TOOLS_LINUX_URL in AndroidPackages.cfg}"
: "${CMDLINE_TOOLS_LINUX_SHA256:?Missing CMDLINE_TOOLS_LINUX_SHA256 in AndroidPackages.cfg}"
: "${NDK_LINUX_URL:?Missing NDK_LINUX_URL in AndroidPackages.cfg}"
: "${NDK_LINUX_SHA1:?Missing NDK_LINUX_SHA1 in AndroidPackages.cfg}"

cleanup() {
  rm -rf -- "$TMP_ROOT"
}
trap cleanup EXIT

need_command() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

read_property() {
  local file="$1" key="$2"
  [[ -f "$file" ]] || return 1
  awk -F= -v wanted="$key" '
    {
      name=$1
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", name)
      if (name == wanted) {
        value=$0
        sub(/^[^=]*=/, "", value)
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", value)
        print value
        exit
      }
    }' "$file"
}

version_ge() {
  local actual="$1" minimum="$2"
  [[ "$(printf '%s\n%s\n' "$minimum" "$actual" | sort -V | head -n1)" == "$minimum" ]]
}

download_file() {
  local url="$1" output="$2"
  mkdir -p -- "$(dirname -- "$output")"
  if command -v curl >/dev/null 2>&1; then
    curl --fail --location --retry 3 --retry-delay 2 --output "$output" "$url"
  elif command -v wget >/dev/null 2>&1; then
    wget --tries=3 --output-document="$output" "$url"
  else
    die "curl or wget is required to download Android packages."
  fi
}

verify_sha256() {
  local file="$1" expected="$2" actual
  need_command sha256sum
  actual="$(sha256sum "$file" | awk '{print $1}')"
  [[ "${actual,,}" == "${expected,,}" ]] || die "SHA-256 mismatch for $file (expected $expected, got $actual)"
}

verify_sha1() {
  local file="$1" expected="$2" actual
  need_command sha1sum
  actual="$(sha1sum "$file" | awk '{print $1}')"
  [[ "${actual,,}" == "${expected,,}" ]] || die "SHA-1 mismatch for $file (expected $expected, got $actual)"
}

ensure_java() {
  command -v java >/dev/null 2>&1 || die "Java is required by Android sdkmanager. Install a JDK and ensure 'java' is in PATH."
}

sdkmanager_path() {
  printf '%s/cmdline-tools/latest/bin/sdkmanager' "$SDK_ROOT"
}

install_cmdline_tools() {
  local sdkmanager archive extract_dir
  sdkmanager="$(sdkmanager_path)"

  if [[ -x "$sdkmanager" && "$FORCE" -eq 0 ]]; then
    info "Android Command-line Tools already installed."
    return
  fi

  [[ "$CHECK_ONLY" -eq 0 ]] || die "Android Command-line Tools are not installed at $sdkmanager"

  need_command unzip
  mkdir -p "$TMP_ROOT" "$SDK_ROOT/cmdline-tools"
  archive="$TMP_ROOT/commandlinetools-linux.zip"
  extract_dir="$TMP_ROOT/cmdline-tools-extract"

  info "Downloading Android Command-line Tools..."
  download_file "$CMDLINE_TOOLS_LINUX_URL" "$archive"
  info "Verifying Android Command-line Tools SHA-256..."
  verify_sha256 "$archive" "$CMDLINE_TOOLS_LINUX_SHA256"

  rm -rf "$extract_dir"
  mkdir -p "$extract_dir"
  unzip -q "$archive" -d "$extract_dir"
  [[ -d "$extract_dir/cmdline-tools" ]] || die "Unexpected Command-line Tools archive layout."

  rm -rf "$SDK_ROOT/cmdline-tools/latest"
  mv "$extract_dir/cmdline-tools" "$SDK_ROOT/cmdline-tools/latest"
  chmod +x "$SDK_ROOT/cmdline-tools/latest/bin/"* 2>/dev/null || true

  [[ -x "$sdkmanager" ]] || die "sdkmanager was not installed correctly."
}

accept_sdk_licenses() {
  local sdkmanager rc
  sdkmanager="$(sdkmanager_path)"

  if [[ "${GEN_ANDROID_ACCEPT_LICENSES:-0}" == "1" ]]; then
    info "Accepting Android SDK licenses (GEN_ANDROID_ACCEPT_LICENSES=1)..."
    set +o pipefail
    yes | "$sdkmanager" --sdk_root="$SDK_ROOT" --licenses
    rc=${PIPESTATUS[1]}
    set -o pipefail
    [[ "$rc" -eq 0 ]] || die "sdkmanager --licenses failed with exit code $rc"
  else
    info "Android SDK licenses must be accepted to install packages."
    info "Review the licenses shown by sdkmanager and answer the prompts."
    "$sdkmanager" --sdk_root="$SDK_ROOT" --licenses
  fi
}

install_sdk_packages() {
  local sdkmanager
  sdkmanager="$(sdkmanager_path)"
  ensure_java

  [[ "$CHECK_ONLY" -eq 0 ]] || return

  accept_sdk_licenses

  info "Installing required Android SDK packages..."
  "$sdkmanager" --sdk_root="$SDK_ROOT" \
    "platform-tools" \
    "build-tools;${SDK_BUILD_TOOLS_1}" \
    "build-tools;${SDK_BUILD_TOOLS_2}" \
    "platforms;android-${SDK_PLATFORM_1}" \
    "platforms;android-${SDK_PLATFORM_2}" \
    "platforms;android-${SDK_PLATFORM_3}"
}

validate_sdk() {
  local platform_tools_version

  [[ -d "$SDK_ROOT" ]] || die "Android SDK directory not found: $SDK_ROOT"
  [[ -x "$(sdkmanager_path)" ]] || die "sdkmanager not found: $(sdkmanager_path)"

  platform_tools_version="$(read_property "$SDK_ROOT/platform-tools/source.properties" "Pkg.Revision" || true)"
  [[ -n "$platform_tools_version" ]] || die "Could not read platform-tools version."
  version_ge "$platform_tools_version" "$SDK_PLATFORM_TOOLS_MIN" || \
    die "platform-tools $platform_tools_version is older than required minimum $SDK_PLATFORM_TOOLS_MIN"

  for version in "$SDK_BUILD_TOOLS_1" "$SDK_BUILD_TOOLS_2"; do
    [[ -d "$SDK_ROOT/build-tools/$version" ]] || die "Missing Android build-tools $version"
  done

  for api in "$SDK_PLATFORM_1" "$SDK_PLATFORM_2" "$SDK_PLATFORM_3"; do
    [[ -d "$SDK_ROOT/platforms/android-$api" ]] || die "Missing Android platform android-$api"
  done

  info "Android SDK validation OK (platform-tools $platform_tools_version)."
}

ensure_linux_cmake_compatibility() {
  # GEN historically checks build/CMake/android.toolchain.cmake. Android NDK uses
  # build/cmake on case-sensitive Linux filesystems, so provide a compatibility
  # symlink without altering the NDK contents.
  if [[ -d "$NDK_ROOT/build/cmake" && ! -e "$NDK_ROOT/build/CMake" ]]; then
    ln -s cmake "$NDK_ROOT/build/CMake"
  fi
}

install_ndk() {
  local current archive extract_dir source_dir

  if [[ -f "$NDK_ROOT/source.properties" ]]; then
    current="$(read_property "$NDK_ROOT/source.properties" "Pkg.Revision" || true)"
    if [[ "$current" == "$NDK_REVISION" && "$FORCE" -eq 0 ]]; then
      ensure_linux_cmake_compatibility
      info "Android NDK $NDK_REVISION ($NDK_RELEASE) already installed."
      return
    fi

    if [[ "$CHECK_ONLY" -eq 1 ]]; then
      die "Android NDK revision is '$current'; expected '$NDK_REVISION'."
    fi

    [[ "$FORCE" -eq 1 ]] || die "Android NDK already exists with revision '$current'. Re-run with --force to replace it."
  elif [[ -e "$NDK_ROOT" && "$FORCE" -eq 0 ]]; then
    [[ "$CHECK_ONLY" -eq 0 ]] || die "Android NDK is incomplete: $NDK_ROOT"
    die "Android NDK directory already exists but source.properties is missing. Re-run with --force to replace it."
  fi

  [[ "$CHECK_ONLY" -eq 0 ]] || die "Android NDK is not installed: $NDK_ROOT"

  need_command unzip
  mkdir -p "$TMP_ROOT"
  archive="$TMP_ROOT/android-ndk-${NDK_RELEASE}-linux.zip"
  extract_dir="$TMP_ROOT/ndk-extract"

  info "Downloading Android NDK $NDK_RELEASE ($NDK_REVISION)..."
  download_file "$NDK_LINUX_URL" "$archive"
  info "Verifying Android NDK SHA-1..."
  verify_sha1 "$archive" "$NDK_LINUX_SHA1"

  rm -rf "$extract_dir"
  mkdir -p "$extract_dir"
  unzip -q "$archive" -d "$extract_dir"
  source_dir="$extract_dir/android-ndk-${NDK_RELEASE}"
  [[ -d "$source_dir" ]] || die "Unexpected Android NDK archive layout."

  rm -rf "$NDK_ROOT"
  mv "$source_dir" "$NDK_ROOT"
  ensure_linux_cmake_compatibility
}

validate_ndk() {
  local current
  [[ -f "$NDK_ROOT/source.properties" ]] || die "Android NDK source.properties not found: $NDK_ROOT"
  current="$(read_property "$NDK_ROOT/source.properties" "Pkg.Revision" || true)"
  [[ "$current" == "$NDK_REVISION" ]] || die "Android NDK revision is '$current'; expected '$NDK_REVISION'."
  [[ -f "$NDK_ROOT/build/cmake/android.toolchain.cmake" ]] || die "Android NDK CMake toolchain file is missing."
  [[ -d "$NDK_ROOT/toolchains/llvm/prebuilt" ]] || die "Android NDK LLVM prebuilt toolchain is missing."
  ensure_linux_cmake_compatibility
  info "Android NDK validation OK ($current / $NDK_RELEASE)."
}

main() {
  info "ThirdPartyLibraries root: $THIRDPARTY_DIR"
  info "Android SDK target    : $SDK_ROOT"
  info "Android NDK target    : $NDK_ROOT"

  if [[ "$INSTALL_SDK" -eq 1 ]]; then
    if [[ "$CHECK_ONLY" -eq 0 ]]; then
      ensure_java
      install_cmdline_tools
      install_sdk_packages
    fi
    validate_sdk
  fi

  if [[ "$INSTALL_NDK" -eq 1 ]]; then
    if [[ "$CHECK_ONLY" -eq 0 ]]; then
      install_ndk
    fi
    validate_ndk
  fi

  info "Android environment is ready for GEN Framework."
}

main
