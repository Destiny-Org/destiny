#!/usr/bin/env bash
# Runs the druntime and Fate unittest programs under valgrind and fails on
# memory errors (invalid reads/writes, use after free, uninitialised values)
# and on definite memory leaks.
#
# Usage: ci/memcheck.sh [druntime|fate|all]   (default: all)
# Run after `ci/run.sh build` (or the same make commands); MODEL and N as in
# ci/run.sh. Known valgrind false positives are in ci/valgrind.supp.
#
# Memory managed by the GC is not a leak for valgrind (the GC allocates whole
# pages with mmap), so what this finds are leaks of malloc'd memory: manual
# memory, @nogc containers and C libraries.

set -uo pipefail

MODEL=${MODEL:-64}
N=${N:-2}
what=${1:-all}
ENGINE=$(cd "$(dirname "$0")/.." && pwd)
FATE=$ENGINE/../fate
SUPP=$ENGINE/ci/valgrind.supp
# the compiler built by `ci/run.sh build` (release)
DESTINY=$ENGINE/generated/linux/release/$MODEL/destiny

VALGRIND=(valgrind --quiet --tool=memcheck --error-exitcode=8
    --leak-check=full --errors-for-leak-kinds=definite --show-leak-kinds=definite
    --track-origins=yes --suppressions="$SUPP" --num-callers=30)

command -v valgrind > /dev/null || { echo "valgrind is not installed" >&2; exit 1; }

failed=0
check() { # check <label> <program> [args...]
    local label=$1; shift
    echo "=== memcheck: $label"
    if "${VALGRIND[@]}" "$@"; then
        echo "=== memcheck: $label: OK"
    else
        echo "=== memcheck: $label: FAILED (exit $?)"
        failed=1; return 1
    fi
}

if [ "$what" = all ] || [ "$what" = druntime ]; then
    runner=generated/linux/debug/$MODEL/unittest/test_runner
    # BUILD=debug for the runner, but compiled with the release compiler
    make -j"$N" -C "$ENGINE/druntime" MODEL="$MODEL" BUILD=debug DMD="$DESTINY" "../$runner" > /dev/null || exit 1
    # the runner names its library by a relative path; run it from where it was built
    # valgrind emulates x87 80-bit `real` with 64 bits, so tests that check
    # exact `real` bit patterns cannot pass under it
    (cd "$ENGINE/druntime" && TEST_RUNNER_SKIP=core.internal.convert \
        check "druntime unittests ($MODEL-bit)" "$ENGINE/$runner") || failed=1
fi

if [ "$what" = all ] || [ "$what" = fate ]; then
    runner=generated/linux/debug/$MODEL/unittest/test_runner
    make -j"$N" -C "$FATE" MODEL="$MODEL" DMD_DIR="$ENGINE" BUILD=debug DMD="$DESTINY" "$runner" > /dev/null || exit 1
    # all Fate modules in one run (the runner tests every module it is linked with)
    # Modules skipped only under valgrind (the normal test jobs run them):
    # - 80-bit `real`: valgrind computes x87 arithmetic with 64 bits, so
    #   tests of exact `real` results fail: the math modules, float
    #   formatting and parsing, bigint/json/conv/numeric/complex checks that
    #   use `real` limits or round-trips
    # - fork: std.process and std.stdio check a forked child's exit status,
    #   and valgrind runs and checks the child too, changing that status
    skip=std.bigint,std.complex,std.conv,std.json,std.mathspecial,std.numeric
    skip=$skip,std.format.internal.floats,std.format.internal.write
    skip=$skip,std.math.algebraic,std.math.exponential,std.math.hardware
    skip=$skip,std.math.operations,std.math.rounding,std.math.traits
    skip=$skip,std.internal.math.errorfunction,std.internal.math.gammafunction
    skip=$skip,std.process,std.stdio
    (cd "$FATE" && TEST_RUNNER_SKIP=$skip \
        check "Fate unittests ($MODEL-bit)" "$FATE/$runner") || failed=1
fi

exit $failed
