#!/usr/bin/env bash
# Packages a built compiler for download:
#
#   destiny64-<version>-<os>.tar.xz
#   └── destiny64/
#       ├── bin/destiny, bin/destiny.conf
#       ├── import/druntime/, import/fate/
#       └── lib/  (druntime and Fate libraries)
#
# Usage: ci/package.sh [OUT_DIR]   (run from destiny_engine, after building
# the compiler, druntime and Fate with ENABLE_RELEASE=1)
# Env:   OS_NAME (default linux), MODEL (default 64)

set -euo pipefail

OS_NAME=${OS_NAME:-linux}
MODEL=${MODEL:-64}
mkdir -p "${1:-.}"
OUT_DIR=$(realpath "${1:-.}")

ENGINE=$(cd "$(dirname "$0")/.." && pwd)
FATE=$ENGINE/../fate
BUILD=$ENGINE/generated/$OS_NAME/release/$MODEL
FATE_BUILD=$FATE/generated/$OS_NAME/release/$MODEL

version=$(sed 's/^v//' "$ENGINE/VERSION")
name=destiny$MODEL
archive=$OUT_DIR/$name-$version-$OS_NAME.tar.xz

for f in "$BUILD/destiny" "$FATE_BUILD/libfate.a"; do
    [ -f "$f" ] || { echo "missing $f (build first)" >&2; exit 1; }
done

stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT
root=$stage/$name
mkdir -p "$root/bin" "$root/import" "$root/lib"

cp "$BUILD/destiny" "$root/bin/"
cp -r "$ENGINE/druntime/import" "$root/import/druntime"
mkdir -p "$root/import/fate"
cp -r "$FATE/std" "$FATE/etc" "$root/import/fate/"
mkdir -p "$root/import/fate/fate"
cp -r "$FATE/fate/sys" "$root/import/fate/fate/"
cp -P "$FATE_BUILD"/libfate.* "$root/lib/"
rm -f "$root"/lib/*.o

# paths are relative to the compiler (%@P%), so the folder works anywhere
cat > "$root/bin/destiny.conf" <<EOF
[Environment$MODEL]
DFLAGS=-I%@P%/../import/druntime -I%@P%/../import/fate -L-L%@P%/../lib -L--export-dynamic -fPIC
EOF

cp "$ENGINE/LICENSE.txt" "$root/" 2>/dev/null || true

tar -C "$stage" -cJf "$archive" "$name"
echo "$archive"
