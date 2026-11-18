#!/usr/bin/env bash
# Installs a host compiler: a released Destiny compiler, used to build this one.
#
# Usage: ci/host_compiler.sh <spec> [install-root]
#   spec: destiny, destiny-latest, destiny-<version>
#
# The installer and the list of released versions live in the public
# Destiny-Org/host-compilers repository, next to the destiny64 packages.
# This wrapper downloads that installer and runs it.

set -euo pipefail

url="${HOST_COMPILER_INSTALLER:-https://raw.githubusercontent.com/Destiny-Org/host-compilers/main/host_compiler.sh}"
curl -fsSL --retry 5 --retry-delay 5 --connect-timeout 10 "$url" | bash -s -- "$@"
