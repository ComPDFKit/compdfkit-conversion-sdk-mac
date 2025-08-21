#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

BUILD_DIR="${SCRIPT_DIR}/build"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

arch=$(uname -m)
# arch="x86_64" 
echo "arch: $arch"
if [ "$arch" = "x86_64" ]; then
    cmake .. -DCMAKE_SYSTEM_PROCESSOR="x86_64" -DCMAKE_OSX_DEPLOYMENT_TARGET="10.15" -DCMAKE_OSX_ARCHITECTURES="x86_64"
elif [ "$arch" = "arm64" ]; then
    cmake .. -DCMAKE_SYSTEM_PROCESSOR="arm" -DCMAKE_OSX_DEPLOYMENT_TARGET="10.15" -DCMAKE_OSX_ARCHITECTURES="arm64"
else
    exit 1
fi

cpu_count=10
if command -v sysctl >/dev/null 2>&1; then
    cpu_count=$(sysctl -n hw.ncpu || echo 10)
fi

make -j${cpu_count}

if [ -f "${SCRIPT_DIR}/copy_resources.sh" ]; then
    bash "${SCRIPT_DIR}/copy_resources.sh" "${PWD}" "${arch}"
else
    echo "Warning: copy_resources.sh not found in ${SCRIPT_DIR}, skipping resource copy"
fi
