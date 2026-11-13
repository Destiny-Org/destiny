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
*host compiler*. Destiny uses one: **upstream dmd 2.113.1**, mirrored as a
release of `Destiny-Org/host-compilers`, so builds never download from upstream
servers.

```bash
cd destiny_engine
ci/host_compiler.sh dmd-2.113.1          # installs into ~/host-compilers
source ~/host-compilers/dmd-2.113.1/activate
```

`ci/host_compiler.sh` downloads the installer from the public host-compilers
repository and runs it. The version list lives in that installer
(`DMD_VERSIONS`). To change the version, edit it there and push: the **Mirror
host compilers** workflow uploads the new release. Then update the version in
the workflows of all repositories (search for `2.113.1`), `compiler/src/bootstrap.sh`
and `compiler/src/build.d` (`HOST_DMD_VER`).

## Building

```bash
cd destiny_engine
make -j$(nproc) HOST_DMD=dmd     # compiler + druntime
make -j$(nproc) fate             # Fate, in ../fate
```

Results:

| Output | Path |
|---|---|
| compiler | `destiny_engine/generated/linux/release/64/destiny` (+ `destiny.conf`) |
| druntime | `destiny_engine/generated/linux/release/64/libdruntime.a` |
| Fate | `fate/generated/linux/release/64/libphobos2.a`, `libphobos2.so.0.115.0` |

## Testing

```bash
cd destiny_engine
make -j$(nproc) HOST_DMD=dmd dmd-test       # compiler test suite
make -j$(nproc) druntime-test               # druntime unittests
make -C ../fate -j$(nproc) unittest         # Fate unittests
```

`dmd-test` takes hours on a small machine. Read the whole log, not just the
exit code.

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
    setsid nohup bash -c "make -j2 HOST_DMD=dmd dmd-test > ~/test-dmd.log 2>&1" &' | cat
  multipass exec destiny-lang -- tail -50 ~/test-dmd.log | cat
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

## Status (2026-11-13)

Verified in the VM with dmd 2.113.1:

- `destiny` builds; `destiny --version` prints `Destiny64 Compiler v2.115.0-master`.
- druntime builds with `destiny`, no errors.
- Fate builds with `destiny` (`libphobos2.a` and `.so`), no errors.
- First full compiler test run: 24 failures. 15 were `gdb*` tests (gdb was not
  installed in the VM); 9 came from the renames and were fixed: import paths
  now end in `fate`, two ddoc autolink tests have real URLs again, and the
  generated-docs base macro is `FATE_PATH`. All 24 pass when rerun.
- A second full run (compiler, druntime and Fate tests) is in progress.

The test suite needs `gdb` installed (`sudo apt-get install gdb`).

Generated API docs link to `FATE_PATH`, currently
`https://destiny-org.github.io/fate/`, which is a placeholder until the docs
are published there.

Not yet verified: CI on GitHub (waiting for the `DESTINY_REPO_TOKEN`
repository secrets).
