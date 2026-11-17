# destiny

**destiny** is the reference compiler for the Destiny programming language.

Destiny started as a fork of the D reference compiler (dmd) and its
runtime. It is heading towards being memory safe by default; see the
[memory safety design](docs/specs/2026-11-12-destiny-memory-safety-design.md).

For building, testing in the VM, CI and the host compiler, see
[docs/development.md](docs/development.md).

## Repositories

Destiny is made of repositories that live side by side in one folder:

| Repository | Folder | Contents |
|---|---|---|
| [Destiny-Org/destiny](https://github.com/Destiny-Org/destiny) | `destiny_engine/` | compiler, druntime, language spec, tests |
| [Destiny-Org/fate](https://github.com/Destiny-Org/fate) | `fate/` | Fate, the standard library (forked from Phobos) |
| [Destiny-Org/tools](https://github.com/Destiny-Org/tools) | `tools/` | build and test helpers (whitespace check, test extractor, rdmd, DustMite) |
| [Destiny-Org/d-scanner](https://github.com/Destiny-Org/d-scanner) | `d-scanner/` | style checker used by `make style`, and libdparse for the test extractor |
| [Destiny-Org/host-compilers](https://github.com/Destiny-Org/host-compilers) | — | mirrored upstream D compilers used to build destiny (releases only) |

The build expects exactly this layout: Fate must sit next to the
compiler folder, as `../fate`. `tools` and `d-scanner` are cloned
automatically when a target needs them.

```
git clone https://github.com/Destiny-Org/destiny.git destiny_engine
git clone https://github.com/Destiny-Org/fate.git fate
```

### Host compiler

Building destiny needs an upstream D compiler. To install one of the
versions mirrored in Destiny-Org/host-compilers:

```
ci/host_compiler.sh dmd
source ~/host-compilers/dmd/activate
```

## Building

Building needs an existing D compiler to compile Destiny itself, the *host
compiler*, passed as `HOST_DC`. Destiny uses upstream dmd 2.113.1, mirrored in
Destiny-Org/host-compilers (see "Host compiler" above).

```
cd destiny_engine
make -j$(nproc) HOST_DC=dmd    # compiler + druntime
make -j$(nproc) fate            # standard library (in ../fate)
```

The compiler ends up at `generated/<os>/release/<model>/destiny`, for
example `generated/linux/release/64/destiny`, with its configuration file
`destiny.conf` next to it.

Main targets: `make destiny` (compiler), `make druntime`, `make fate`,
`make destiny-test` (compiler tests). More targets and build variables are described in [compiler/src/README.md](compiler/src/README.md).

## Testing

```
make -j$(nproc) test            # compiler, druntime and Fate tests
```

See [compiler/test/README.md](compiler/test/README.md) for running single
tests.

## Layout

| Directory | Description |
|---|---|
| [changelog](changelog) | changelog entries for the upcoming release |
| [ci](ci) | CI scripts used by GitHub Actions |
| [compiler/src](compiler/src) | compiler source code and build system |
| [compiler/test](compiler/test) | compiler tests and test tools |
| [compiler/docs](compiler/docs) | man pages and internal documentation |
| [compiler/ini](compiler/ini) | predefined `destiny.conf` files per OS |
| [druntime](druntime) | the runtime library |
| [docs](docs) | Destiny design specs and guides |
| [spec](spec) | the language specification |

## Names inherited from D

Some names still come from D, on purpose:

- Source files keep the `.d` extension.
- The compiler's own modules are named `dmd.*` and live in
  `compiler/src/dmd/`.
- The standard library modules are `std.*`, and the compiled library is
  still `libphobos2`.
- `HOST_DC` and `version (DigitalMars)` refer to the upstream D
  toolchain.

## License

Boost Software License 1.0; see [LICENSE.txt](LICENSE.txt).
