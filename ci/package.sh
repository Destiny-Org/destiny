#!/usr/bin/env bash
# Packages a built compiler for download:
#
#   destiny64-<version>-<os>.tar.xz
#   └── destiny64/
#       ├── bin/destiny, bin/destiny.conf
#       ├── import/druntime/, import/fate/
#       ├── lib/    (64-bit druntime and Fate libraries)
#       └── lib32/  (32-bit libraries, when built with MODEL=32 too)
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

# 32-bit libraries, so the package can build 32-bit programs (-m32)
FATE_BUILD32=$FATE/generated/$OS_NAME/release/32
if [ "$MODEL" = 64 ] && [ -f "$FATE_BUILD32/libfate.a" ]; then
    mkdir -p "$root/lib32"
    cp -P "$FATE_BUILD32"/libfate.* "$root/lib32/"
    rm -f "$root"/lib32/*.o
fi

# paths are relative to the compiler (%@P%), so the folder works anywhere;
# -rpath lets programs linked with -defaultlib=libfate.so find it at run time
cat > "$root/bin/destiny.conf" <<EOF
[Environment$MODEL]
DFLAGS=-I%@P%/../import/druntime -I%@P%/../import/fate -L-L%@P%/../lib -L-rpath=%@P%/../lib -L--export-dynamic -fPIC
EOF
if [ -d "$root/lib32" ]; then
    cat >> "$root/bin/destiny.conf" <<EOF

[Environment32]
DFLAGS=-I%@P%/../import/druntime -I%@P%/../import/fate -L-L%@P%/../lib32 -L-rpath=%@P%/../lib32 -L--export-dynamic -fPIC
EOF
fi

# MPL-2.0 (LICENSE, NOTICE) and the Boost license of the original D files
for f in LICENSE NOTICE LICENSE.txt; do cp "$ENGINE/$f" "$root/"; done

tar -C "$stage" -cJf "$archive" "$name"
echo "$archive"
