#!/usr/bin/env bash
# Bootstraps a Destiny compiler for another platform, without any upstream
# D compiler. Two steps:
#
#   ci/cross_bootstrap.sh compile <os>   on Linux, with a Linux destiny host:
#       compiles the compiler, druntime and Fate (their D code) for <os>
#       into object files under cross/<os>/
#   ci/cross_bootstrap.sh link <os>      on <os>, given cross/<os>/:
#       compiles druntime's C/assembly parts with the platform's C compiler,
#       links the compiler, and lays out a minimal destiny64 in
#       cross/<os>/destiny64 (bin/, lib/, import/) that can serve as the
#       host compiler for the normal native build (ci/run.sh build).
#
# <os>: freebsd | osx | windows. 64-bit only.
# Run from destiny_engine, with ../fate next to it.
# Env: DESTINY (host compiler, default: destiny), FREEBSD_VERSION (default 14)

set -euo pipefail

step="${1:?usage: cross_bootstrap.sh compile|link <os>}"
os="${2:?usage: cross_bootstrap.sh compile|link <os>}"
ENGINE=$(cd "$(dirname "$0")/.." && pwd)
FATE=${FATE:-$ENGINE/../fate}
OUT=$ENGINE/cross/$os
obj=o; [ "$os" = windows ] && obj=obj

case "$os" in
    freebsd) target=(-os=freebsd "-version=FreeBSD_${FREEBSD_VERSION:-14}") ;;
    osx)     target=(-os=osx) ;;
    windows) target=(-os=windows) ;;
    *) echo "unknown os: $os (freebsd, osx, windows)" >&2; exit 1 ;;
esac
pic=(); [ "$os" = windows ] || pic=(-fPIC)

compile() {
    local dc="${DESTINY:-destiny}"
    mkdir -p "$OUT/J"
    # string imports the compiler embeds (see compiler/src/build.d)
    sed 's/^v//' "$ENGINE/VERSION" | tr -d '\n' > "$OUT/J/VERSION"
    if [ "$os" = windows ]; then printf '' > "$OUT/J/SYSCONFDIR.imp"; else printf '/etc' > "$OUT/J/SYSCONFDIR.imp"; fi

    local common=(-conf= -m64 "${target[@]}" "${pic[@]}" -O -release -verrors=0 -lowmem)

    echo "== compiler" >&2
    local src
    src=$(cd "$ENGINE/compiler" && find src/destiny -name '*.d' | grep -vE '/frontend\.d$|/(scanmach|scanomf|scanmscoff)\.d$' | sort)
    (cd "$ENGINE/compiler" && "$dc" "${common[@]}" -revert=safedefault -version=MARS \
        -I"$ENGINE/druntime/import" -I"$FATE" -Isrc -J"$OUT/J" -Jsrc/destiny/res \
        -c -of"$OUT/destiny.$obj" $src)

    echo "== druntime" >&2
    local drt
    drt=$(grep -oE 'src\\[^ ]+\.d' "$ENGINE/druntime/mak/SRCS" | tr '\\' '/')
    (cd "$ENGINE/druntime" && "$dc" "${common[@]}" -Isrc -Iimport \
        -preview=nosharedaccess -preview=fieldwise -preview=dtorfields \
        -c -of"$OUT/druntime.$obj" $drt)

    echo "== fate" >&2
    local fate
    fate=$(cd "$FATE" && find std etc -name '*.d' | sort)
    (cd "$FATE" && "$dc" "${common[@]}" -I"$ENGINE/druntime/import" -I. \
        -preview=dtorfields -preview=fieldwise \
        -c -of"$OUT/fate.$obj" $fate)

    ls -la "$OUT"/*."$obj" >&2
}

link() {
    local root=$OUT/destiny64
    rm -rf "$root"; mkdir -p "$root/bin" "$root/lib" "$root/import"
    cp -r "$ENGINE/druntime/import" "$root/import/druntime"
    mkdir -p "$root/import/fate"; cp -r "$FATE/std" "$FATE/etc" "$root/import/fate/"

    local zlib=("$FATE"/etc/c/zlib/*.c)
    if [ "$os" = windows ]; then
        # needs the MSVC tools (cl, lib, link) on PATH
        cl -nologo -c -O2 -Fo"$OUT/errno_c.obj" "$ENGINE/druntime/src/core/stdc/errno.c"
        mkdir -p "$OUT/zlib"
        (cd "$OUT/zlib" && cl -nologo -c -O2 "${zlib[@]}")
        lib -nologo -OUT:"$root/lib/fate64.lib" "$OUT/fate.obj" "$OUT/druntime.obj" "$OUT/errno_c.obj" "$OUT"/zlib/*.obj
        link -nologo -OUT:"$root/bin/destiny.exe" "$OUT/destiny.obj" "$root/lib/fate64.lib" \
            -LIBPATH:"$root/lib" -DEBUG:NONE -STACK:8388608
        cat > "$root/bin/sc.ini" <<'EOF'
[Environment]
DFLAGS="-I%@P%\..\import\druntime" "-I%@P%\..\import\fate"
LIB="%@P%\..\lib"
EOF
    else
        local cc=${CC:-cc}
        "$cc" -c -O2 -fPIC -o "$OUT/errno_c.o" "$ENGINE/druntime/src/core/stdc/errno.c"
        "$cc" -c -O2 -fPIC -o "$OUT/threadasm.o" "$ENGINE/druntime/src/core/thread/fiber/switch_context_asm.S"
        mkdir -p "$OUT/zlib"
        (cd "$OUT/zlib" && "$cc" -c -O2 -fPIC "${zlib[@]}")
        ar rcs "$root/lib/libfate.a" "$OUT/fate.o" "$OUT/druntime.o" "$OUT/errno_c.o" "$OUT/threadasm.o" "$OUT"/zlib/*.o
        local libs=(-lpthread -lm)
        [ "$os" = freebsd ] && libs+=(-lexecinfo)
        "$cc" -o "$root/bin/destiny" "$OUT/destiny.o" -L"$root/lib" -lfate "${libs[@]}"
        cat > "$root/bin/destiny.conf" <<'EOF'
[Environment64]
DFLAGS=-I%@P%/../import/druntime -I%@P%/../import/fate -L-L%@P%/../lib -fPIC
EOF
    fi
    "$root/bin/destiny" --version | head -1
    # a minimal check that it compiles and runs a program
    printf 'import std.stdio; void main() { writeln("hello from the bootstrapped destiny"); }\n' > "$OUT/hello.d"
    (cd "$OUT" && "$root/bin/destiny" -of"$OUT/hello" hello.d && "$OUT/hello")
    # an activate script, as ci/host_compiler.sh writes, for ci/run.sh
    mkdir -p ~/host-compilers/destiny-bootstrap
    cat > ~/host-compilers/destiny-bootstrap/activate <<EOF
export PATH="$root/bin:\$PATH"
export DMD=destiny
export DC=destiny
deactivate() { :; }
EOF
    echo "$root"
}

"$step"
