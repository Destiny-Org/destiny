# destiny

**destiny** is the reference compiler for the Destiny programming language.

Destiny started as a fork of the D reference compiler and its runtime. It
is memory safe by default: functions are `@safe` unless marked otherwise,
and scope checking is always on.

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
ci/host_compiler.sh destiny
source ~/host-compilers/dmd/activate
```

## Building

Building needs an existing D compiler to compile Destiny itself, the *host
compiler*, passed as `HOST_DC`. Destiny uses upstream dmd 2.113.1, mirrored in
Destiny-Org/host-compilers (see "Host compiler" above).

```
cd destiny_engine
make -j$(nproc) HOST_DC=destiny    # compiler + druntime
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

## Using D packages

Destiny does not fetch packages from code.dlang.org. Code written for D
does not build in Destiny without changes:

- Destiny is `@safe` by default; D is `@system` by default.
- Scope checking is always on, so code that lets references to stack
  memory escape is rejected.
- `in` parameters always mean `scope const`.

Packages come from `Destiny-Org/packages` instead, where each one has been
ported and tested with Destiny. Add one with DES (`des`, Destiny's package
manager) as usual:

```
des add vibe-d
des build
```

To use a D package that is not there yet, port it:

1. Copy its source at a release tag, with its license file.
2. Build it with Destiny and fix the errors. While porting, build with
   `-revert=safedefault` first to see only the scope and `in` errors:

   ```
   DFLAGS="-revert=safedefault" des build
   ```

   (`-revert=safedefault` makes functions without `@safe`, `@trusted` or
   `@system` `@system` again, as in D). Then fix the `@safe` errors and
   build without it.
3. Add it to `Destiny-Org/packages`.

Each package keeps its own license and copyright notices.

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

## Names

The compiler, its sources and the standard library use Destiny names:

| What | Name |
|---|---|
| compiler program | `destiny` (`destiny.exe` on Windows), config `destiny.conf` |
| compiler sources | `compiler/src/destiny/`, modules `destiny.*`, C++ headers in `compiler/include/destiny/` (`namespace destiny`) |
| standard library | Fate: library `libfate.a` / `libfate.so`, modules `std.*`, v3 preview `fate.sys` |
| downloads | `destiny64-<version>-<os>.tar.xz` |
| test-suite variable | `$DESTINY` (the compiler under test) |

Some names still come from D, on purpose:

- Source files keep the `.d` extension, and Fate's modules keep `std.*` and
  `etc.*`, so D code still imports the same modules.
- `HOST_DC`, `dmd-2.113.1` and `version (DigitalMars)` refer to the upstream
  D toolchain that builds Destiny.
- Citations such as "upstream dmd issue 1234" point at the original projects.
- Internal build identifiers (`dmdDefault`, `-version=DMDLIB`) and the
  `-Xi=compilerInfo` interface value `dmd`, which tools rely on.

## License

Boost Software License 1.0; see [LICENSE.txt](LICENSE.txt).
