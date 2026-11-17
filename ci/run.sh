#!/usr/bin/env bash

# Implements CI steps for multiple CI services.
# This file is invoked from the DMD and Fate CI YAMLs.

set -uexo pipefail

# N: number of parallel build jobs
if [ -z ${N+x} ] ; then echo "Variable 'N' needs to be set."; exit 1; fi
# OS_NAME: linux|osx|freebsd|windows
if [ -z ${OS_NAME+x} ] ; then echo "Variable 'OS_NAME' needs to be set."; exit 1; fi
# FULL_BUILD: true|false (true on Linux: use full permutations for DMD tests)
if [ -z ${FULL_BUILD+x} ] ; then echo "Variable 'FULL_BUILD' needs to be set."; exit 1; fi
# MODEL: 32|64
if [ -z ${MODEL+x} ] ; then echo "Variable 'MODEL' needs to be set."; exit 1; fi
# HOST_DC: dmd[-<version>]|ldc[-<version>]|gdmd-<version>
if [ ! -z ${HOST_DC+x} ] ; then HOST_DC=${HOST_DC}; fi
if [ -z ${HOST_DC+x} ] ; then echo "Variable 'HOST_DC' needs to be set."; exit 1; fi
# CI_DFLAGS: Optional flags to pass to the build
if [ -z ${CI_DFLAGS+x} ] ; then CI_DFLAGS=""; fi

CURL_USER_AGENT="DMD-CI $(curl --version | head -n 1)"
build_path=generated/$OS_NAME/release/$MODEL

if [ "$OS_NAME" == "linux" ]; then
    # use faster ld.gold linker on x86_64-linux
    if [ "$MODEL" == "64" ]; then
        mkdir -p linker
        rm -f linker/ld
        ln -s /usr/bin/ld.gold linker/ld
        export PATH="$PWD/linker:$PATH"
    fi
    NM="nm --print-size"
else
    NM=nm

  if [ "$OS_NAME" == "osx" ]; then
    # As of macos-14 gmake won't be used purely based upon the symlink, must force override via PATH.
    export PATH="/opt/homebrew/opt/make/libexec/gnubin:/usr/local/opt/llvm/bin:$PATH"
  fi
fi

# clone a repo
clone() {
    local url="$1"
    local path="$2"
    local branch="$3"
    for i in {0..4}; do
        if git clone --depth=1 --branch "$branch" "$url" "$path" --quiet; then
            break
        elif [ $i -lt 4 ]; then
            sleep $((1 << $i))
        else
            echo "Failed to clone: ${url//${DESTINY_REPO_TOKEN:-<none>}/***}"
            exit 1
        fi
    done
}

# build dmd (incl. building and running the unittests), druntime, phobos
build() {
    local unittest=${1:-1}
    if [ "$OS_NAME" != "windows" ]; then
        source ~/host-compilers/*/activate # activate host compiler, incl. setting `DMD`
    fi
    if [ $unittest -eq 1 ]; then
        make -j$N MODEL=$MODEL HOST_DC=$DMD HOST_DFLAGS="$CI_DFLAGS" BUILD=debug destiny-unittest
    fi
    make -j$N MODEL=$MODEL HOST_DC=$DMD HOST_DFLAGS="$CI_DFLAGS" ENABLE_RELEASE=${ENABLE_RELEASE:-1}
    make -j$N -C ../fate MODEL=$MODEL
    if [ "$OS_NAME" != "windows" ]; then
        deactivate # deactivate host compiler
    fi
}

# self-compile dmd
rebuild() {
    local compare=${1:-0}

    local dotexe=""
    local conf="destiny.conf"
    if [ "$OS_NAME" == "windows" ]; then
        dotexe=".exe"
        conf="sc.ini"
    fi

    # `generated` gets cleaned in the next step, so we create another _generated
    # The nested folder hierarchy is needed to conform to those specified in
    # the generated destiny.conf
    mkdir -p _${build_path}
    cp $build_path/destiny$dotexe _${build_path}/host_dmd$dotexe
    cp $build_path/$conf _${build_path}/
    rm -rf $build_path
    make -j$N MODEL=$MODEL HOST_DC=_${build_path}/host_dmd$dotexe HOST_DFLAGS="$CI_DFLAGS" ENABLE_RELEASE=${ENABLE_RELEASE:-1} dmd

    # compare binaries to test reproducible build
    if [ $compare -eq 1 ]; then
        if ! diff _${build_path}/host_dmd $build_path/destiny; then
            $NM _${build_path}/host_dmd > a
            $NM $build_path/destiny > b
            diff -u a b
            echo "Self-compilation failed: generated dmd created a different binary than host dmd!"
            exit 1
        fi
    fi
}

# test druntime, phobos, dmd
test() {
    test_druntime
    test_fate
    test_destiny
}

# test dmd
test_destiny() {
    # default to testing fewer compiler argument permutations to reduce CI load
    if [ "$FULL_BUILD" == "true" ] && [ "$OS_NAME" == "linux" ]; then
        local args=() # use all default ARGS
    else
        local args=(ARGS="-inline '-O -release'")
    fi

    if type -P apk &>/dev/null; then
        # Alpine: no TLS variables support with gdb, https://gitlab.alpinelinux.org/alpine/aports/-/issues/11154
        rm compiler/test/runnable/gdb4181.d
    fi

    $build_path/destiny -g -i -Icompiler/test -release compiler/test/run.d -ofgenerated/run
    generated/run -j$N --environment MODEL=$MODEL HOST_DC=$build_path/destiny "${args[@]}"
}

# build and run druntime unit tests
test_druntime() {
    make -j$N -C druntime MODEL=$MODEL unittest
}

# build and run Fate unit tests
test_fate() {
    make -j$N -C ../fate MODEL=$MODEL unittest

    if [ "$OS_NAME" == "windows" ]; then
        echo "FIXME: Skipping publictests on Windows (test failures)"
    else
        make -j$N -C ../fate MODEL=$MODEL publictests
        make -j$N -C ../fate MODEL=$MODEL publictests NO_BOUNDSCHECKS=1

        if [ "$OS_NAME" == "osx" ]; then
            echo "FIXME: Skipping betterc on macOS (Apple linker assertions)"
        else
            make -j$N -C ../fate MODEL=$MODEL betterc
        fi
    fi
}


# Destiny-Org repository URL; uses DESTINY_REPO_TOKEN (read access) when set, for private repos
destiny_repo_url() {
    if [ -n "${DESTINY_REPO_TOKEN:-}" ]; then
        echo "https://x-access-token:${DESTINY_REPO_TOKEN}@github.com/Destiny-Org/$1.git"
    else
        echo "https://github.com/Destiny-Org/$1.git"
    fi
}

# clone Fate next to the compiler if not already available, on the branch with
# the same name, falling back to main
setup_repos() {
    local branch="$1" url
    url="$(destiny_repo_url fate)"
    if [ ! -d ../fate ]; then
        if [ "$branch" != main ] && ! git ls-remote --exit-code --heads "$url" "$branch" > /dev/null; then
            clone "$url" ../fate main
        else
            clone "$url" ../fate "$branch"
        fi
    fi
}

testsuite() {
    date
    for step in build test rebuild "rebuild 1" test_destiny; do
        $step
        date
    done
}


# install D host compiler
install_host_compiler() {
  if [ "${HOST_DC:0:5}" == "gdmd-" ] ; then
    local gdc_version="${HOST_DC:5}"
    if [ ! -e ~/host-compilers/gdc-$gdc_version/activate ] ; then
        sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
        sudo apt-get update
        sudo apt-get install -y gdc-$gdc_version
        # fetch the gdmd wrapper for CLI compatibility with dmd
        sudo curl -fsSL -A "$CURL_USER_AGENT" --connect-timeout 5 --speed-time 30 --speed-limit 1024 --retry 5 --retry-delay 5 https://raw.githubusercontent.com/D-Programming-GDC/GDMD/master/dmd-script -o /usr/bin/gdmd-$gdc_version
        sudo chmod +x /usr/bin/gdmd-$gdc_version
        # fake install script and create a fake 'activate' script
        mkdir -p ~/host-compilers/gdc-$gdc_version
        echo "export DMD=gdmd-$gdc_version" > ~/host-compilers/gdc-$gdc_version/activate
        echo "deactivate(){ echo;}" >> ~/host-compilers/gdc-$gdc_version/activate
    fi
  elif type -P apk &>/dev/null; then
    # fake install script and create a fake 'activate' script
    mkdir -p ~/host-compilers/$HOST_DC
    echo "export DMD=$HOST_DC" > ~/host-compilers/$HOST_DC/activate
    echo "deactivate(){ echo;}" >> ~/host-compilers/$HOST_DC/activate
  else
    # upstream D compiler from the Destiny-Org mirror
    bash ci/host_compiler.sh "$HOST_DC" ~/host-compilers > /dev/null
  fi
}

# Define commands

if [ "$#" -gt 0 ]; then
  case $1 in
    install_host_compiler) install_host_compiler ;;
    setup_repos) setup_repos "$2" ;; # ci/run.sh setup_repos <git branch>
    build) build "${2:-}" ;; # ci/run.sh build [0]  (use `0` to skip running compiler unittests)
    rebuild) rebuild "${2:-}" ;; # ci/run.sh rebuild [1] (use `1` to compare binaries to test reproducible build)
    test) test ;;
    test_destiny) test_destiny ;;
    test_druntime) test_druntime ;;
    test_fate) test_fate ;;
    testsuite) testsuite ;;
    *) echo "Unknown command: $1" >&2; exit 1 ;;
  esac
fi
