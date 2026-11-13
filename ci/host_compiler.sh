#!/usr/bin/env bash
# Installs a host compiler (an upstream D compiler used to build destiny).
#
# Usage: ci/host_compiler.sh <spec> [install-root]
#   spec: dmd, dmd-latest, dmd-<version>, ldc, ldc-latest, ldmd2, ldc-<version>
#
# The installer and the list of available versions live in the public
# Destiny-Org/host-compilers repository, next to the mirrored compilers.
# This wrapper downloads that installer and runs it.

set -euo pipefail

url="${HOST_COMPILER_INSTALLER:-https://raw.githubusercontent.com/Destiny-Org/host-compilers/main/host_compiler.sh}"
curl -fsSL --retry 5 --retry-delay 5 --connect-timeout 10 "$url" | bash -s -- "$@"
