# Developing Destiny

How the Destiny repositories fit together, how to build and test them, and how
CI is set up. For the language and compiler changes being planned, see
[specs/2026-11-12-destiny-memory-safety-design.md](specs/2026-11-12-destiny-memory-safety-design.md).

## Repositories

All repositories live side by side in one folder:

```
Destiny/
├── destiny_engine/   Destiny-Org/destiny     compiler, druntime, spec, tests
├── fate/             Destiny-Org/fate        standard library (from Phobos)
├── tools/            Destiny-Org/tools       test extractor, whitespace check, rdmd, DustMite
└── d-scanner/        Destiny-Org/d-scanner   style checker; provides libdparse
```

`Destiny-Org/host-compilers` (public) holds the host compiler; it is not
checked out.

The builds find each other through these relative paths (`../fate`,
`../tools`, `../d-scanner`, `../destiny_engine`). `tools` and `d-scanner` are
cloned automatically by the targets that need them.

## Host compiler

The compiler is written in D, so building it needs an existing D compiler, the
*host compiler*, passed as `HOST_DC`. Destiny uses one: **upstream dmd 2.113.1**, mirrored as a
release of `Destiny-Org/host-compilers`, so builds never download from upstream
servers.

```bash
cd destiny_engine
ci/host_compiler.sh dmd-2.113.1          # installs into ~/host-compilers
source ~/host-compilers/dmd-2.113.1/activate
```

Later, once Destiny publishes releases, the host compiler will be the previous
`destiny` release instead (Destiny building itself); `HOST_DC` keeps working
for either.

`ci/host_compiler.sh` downloads the installer from the public host-compilers
repository and runs it. The version list lives in that installer
(`DMD_VERSIONS`). To change the version, edit it there and push: the **Mirror
host compilers** workflow uploads the new release. Then update the version in
the workflows of all repositories (search for `2.113.1`), `compiler/src/bootstrap.sh`
and `compiler/src/build.d` (`HOST_DC_VER`).

## Building

```bash
cd destiny_engine
make -j$(nproc) HOST_DC=dmd     # compiler + druntime
make -j$(nproc) fate             # Fate, in ../fate
```

Results:

| Output | Path |
|---|---|
| compiler | `destiny_engine/generated/linux/release/64/destiny` (+ `destiny.conf`) |
| druntime | `destiny_engine/generated/linux/release/64/libdruntime.a` |
| Fate | `fate/generated/linux/release/64/libphobos2.a`, `libphobos2.so.0.115.0` |

## Testing

There are three test suites. Run all three before committing a compiler or
library change; build first (see [Building](#building)).

| Suite | Command (from `destiny_engine/`) | Time on 2 CPUs |
|---|---|---|
| Compiler | `make -j2 HOST_DC=dmd destiny-test` | ~2–3 h |
| druntime | `make -k -j2 HOST_DC=dmd druntime-test` | ~20 min |
| Fate | `make -k -C ../fate -j2 unittest` | ~1 h |

**Use `-k` for druntime and Fate.** Without it, `make` stops at the first
failing module and the other modules are never tested, so the log looks like
only one thing is broken. (This hid most of Fate's tests for a while.)

**Read the log, not just the exit code.** A run that stops early can look
almost clean.

### Compiler tests

The compiler tests live in `compiler/test/`, one file per test:

| Folder | A test passes when |
|---|---|
| `compilable/` | the file compiles |
| `fail_compilation/` | compiling fails with exactly the messages in its `TEST_OUTPUT` block |
| `runnable/` | the program compiles, runs and exits with 0 |
| `runnable_cxx/`, `dshell/` | C++ interop and shell-driven tests |
| `unit/` | unittests of the compiler as a library |

Run single tests with the test runner (built by `make ... destiny-test`, or by
`make generated/run`):

```bash
cd compiler/test
../../generated/run -j2 HOST_DC=dmd runnable/nrvo.d fail_compilation/fail_scope.d
../../generated/run -j2 HOST_DC=dmd fail_compilation    # a whole folder
```

The test's header comment sets its options, for example:

```d
/*
REQUIRED_ARGS: -de
PERMUTE_ARGS: -O -inline -release
TEST_OUTPUT:
---
fail_compilation/foo.d(12): Error: ...
---
*/
```

When a compiler change correctly changes error messages, regenerate the
expected output and then **review the diff** before keeping it:

```bash
AUTO_UPDATE=1 ../../generated/run -j1 HOST_DC=dmd fail_compilation/foo.d
git diff fail_compilation/foo.d
```

Failure details are in the runner's output after `Test '...' failed`; build
products are in `compiler/test/test_results/`. A test that crashes can be
debugged with `gdb -batch -ex run -ex bt test_results/runnable/d/<name>_0`.

The `runnable/gdb*` tests need `gdb` installed.

### druntime and Fate tests

These run each module's `unittest` blocks. Output lines look like
`1.6s PASS debug64 std.process` or `****** FAIL debug64 std.process`
followed by the assertion.

Test one module:

```bash
make -C ../fate -j2 unittest/std/array.run BUILD=debug
make -C druntime -j2 ../generated/linux/debug/64/unittest/core/internal/newaa BUILD=debug
```

To list everything that failed in a full run:

```bash
grep '^\*\*\*\*\*\* FAIL' fate.log | sort -u
grep -E '^(std|etc|phobos)/.*\.d\([0-9]+\): Error' fate.log | sort -u   # compile errors
```

Known flaky: Fate's `std.process` spawns child processes (`sleep 10000`) and
sometimes fails when the debug and release runs go in parallel. A failed run can
leave those processes behind, after which it fails every time; kill them
(`pkill -x sleep`) and rerun.

### After changing the compiler

The compiler embeds some files (for example the ddoc theme) at build time, and
the build does not always notice when they change. If a change seems to have no
effect, `touch` the source that imports it (for the ddoc theme:
`compiler/src/dmd/doc.d`) and rebuild.

After a compiler change, rebuild druntime and Fate too (`make -j2
HOST_DC=dmd && make -C ../fate -j2`): a change can break building them even
when single compiler tests pass.

### Building and testing in the Multipass VM

Builds and tests run in the Multipass VM `destiny-lang`, not on the host. The
source goes to `/home/ubuntu/destiny-src` in the VM:

```bash
# on the host, from Destiny/
tar -czf ~/destiny-src.tgz --exclude=generated destiny_engine fate tools d-scanner
multipass transfer ~/destiny-src.tgz destiny-lang:/home/ubuntu/destiny-src.tgz
multipass exec destiny-lang -- bash -c 'rm -rf ~/destiny-src && mkdir ~/destiny-src && tar -xzf ~/destiny-src.tgz -C ~/destiny-src'
```

Things to know about the snap-packaged Multipass:

- **Pipe its output.** When stdout is a file under `/tmp` (as in some tools and
  scripts), Multipass prints nothing and `multipass exec` hangs. Use
  `multipass exec destiny-lang -- … | cat`.
- **`multipass transfer` cannot read `/tmp`.** Stage files in your home folder.
- **Run long jobs detached** inside the VM and read the log afterwards:

  ```bash
  multipass exec destiny-lang -- bash -c 'cd ~/destiny-src/destiny_engine &&
    source ~/host-compilers/dmd-2.113.1/activate &&
    setsid nohup bash -c "make -j2 HOST_DC=dmd destiny-test > ~/test-destiny.log 2>&1" &' | cat
  multipass exec destiny-lang -- tail -50 ~/test-destiny.log | cat
  ```

- The VM has 2 CPUs and 2 GB RAM; a 4 GB swap file (`/swapfile`) keeps the
  compiler build from running out of memory. Re-enable it after a VM restart
  with `sudo swapon /swapfile`.

## CI

GitHub Actions, in each repository's `.github/workflows/`:

| Repository | Workflows |
|---|---|
| destiny | `main.yml` (build + test on Ubuntu x64/x86, macOS, Windows x64/x86, FreeBSD; pre-commit), `bootstrap.yml`, `runnable_cxx.yml`, `pre_commit.yml` |
| fate | `main.yml` |
| tools | `main.yml` |
| d-scanner | `default.yml` |
| host-compilers | `mirror.yml` |

Every job uses dmd 2.113.1 as the host compiler.

### Private repositories: `DESTINY_REPO_TOKEN`

destiny, fate, tools and d-scanner are private, and their CI clones each other
(destiny clones fate; fate clones destiny; builds clone tools and d-scanner).
The built-in workflow token only covers its own repository, so the clones use a
token with read access:

1. Create a fine-grained personal access token: resource owner **Destiny-Org**,
   all repositories, **Contents: Read-only**.
2. Add it as a **repository secret** named `DESTINY_REPO_TOKEN` in each of
   destiny, fate, tools and d-scanner (Settings → Secrets and variables →
   Actions → Repository secrets).

On GitHub Free, **organisation** secrets are not passed to private
repositories: the job sees an empty value, and clones fail with
`could not read Username for 'https://github.com'`. Use repository secrets.

Every CI job has the token in its environment; `ci/run.sh`, `build.d` and the
Makefiles use it in clone URLs when it is set and fall back to public URLs when
it is not. GitHub masks it in logs.

### pre-commit

destiny's CI runs pre-commit (`.pre-commit-config.yaml`): no trailing
whitespace, files end with one newline, valid workflow files, and changelog
entries in `changelog/` named `destiny.*`, `dmd.*` or `druntime.*`.

## Status (2026-11-17)

Verified in the `destiny-lang` VM with dmd 2.113.1 as host compiler, after
sub-project 1 (scope checking always on):

- the compiler test suite passes;
- druntime unittests pass;
- Fate unittests pass for every module (debug and release), with `-k`;
- `make destiny-test HOST_DC=dmd` (renamed targets and variable) works.

The suite needs `gdb` installed. Generated API docs link to `FATE_PATH`,
`https://destiny-org.github.io/fate/`, a placeholder until docs are published.

Not yet verified: CI on GitHub (needs the `DESTINY_REPO_TOKEN` repository
secrets).
