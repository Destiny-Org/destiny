# Destiny packages

Destiny packages are hosted on GitHub in one repository,
`Destiny-Org/packages`, one folder per package. They are not fetched from
code.dlang.org.

## The `packages/` folder

`Destiny/packages/` holds the first set: every package Destiny's own tools
depend on (DES, serve-destiny, d-scanner), plus the 50 most-downloaded
packages from the D registry, without `dub` and `dmd`, which Destiny
replaces, and without `openssl-static` (prebuilt OpenSSL libraries that
Destiny cannot build; TLS uses the system's OpenSSL). That is 66 packages.

- Each one is the source of the version the tools select, or the latest
  release for the others, taken from that release's source archive.
- `packages/index.json` lists, for each package: its folder, the upstream
  version, its tag, its license, its license files and its state with
  Destiny (`untested`, `builds`, `fixed`, `fails`).
- `packages/LICENSE.md` says that each folder keeps its own license.

## Where DES gets packages

- Only from `Destiny-Org/packages`. These are the packages that are known
  to build with Destiny.
- Never from code.dlang.org, not even as a fallback. A package written for
  D does not work in Destiny without changes (Destiny is `@safe` by
  default, scope checking is always on and `in` means `scope const`), so
  fetching it unchanged would only produce build errors.
- To use a D package that is not there yet, port it into
  `Destiny-Org/packages` (see "Porting a D package" below).

## Licenses

Every package keeps its own license. Nothing is relicensed.

- License files and copyright notices stay as they are.
- A package without a license file states its license in `dub.json` or
  `dub.sdl` (`"license"`). That grant is kept; the package is not given a
  new license file of a different kind.
- Copyleft packages (`dcd` is GPL-3.0; `inifiled`, `gtk-d` and `bindbc-sdl`
  are LGPL) stay under those licenses, and so do Destiny's changes to them.
- `ae` is MPL-2.0: changes to its files stay MPL-2.0.

## Porting a D package

1. Copy the package's source at a release tag into its own folder in
   `Destiny-Org/packages`, keeping its license file and copyright notices.
   Add it to `index.json`.
2. Build it with Destiny (below) and fix every error and warning in the
   package's code. Note the changes in its `docs/destiny.md`.
3. Tag it `<package>/<version>-destiny.1` and set its state in
   `index.json` to `fixed` (or `builds` if it needed no changes).

## Making a package work with Destiny

Packages are built with Destiny's compiler and dub, never with upstream D:

```
des add-path ~/packages
DFLAGS="-revert=safedefault -lowmem" \
    des build --compiler=destiny --skip-registry=all --build-mode=singleFile
```

- `--skip-registry=all` and `des add-path` make des resolve dependencies
  from `packages/` only.
- `-revert=safedefault` builds code written for upstream D's `@system`
  default. A package is fully converted when it builds without it.
- A build must print no warnings or deprecations (see
  [development.md](development.md), "No warnings").
- Fixes go into the package itself, with a short note in its
  `docs/destiny.md`.

## Hosting

All packages are in `Destiny-Org/packages`:

- A version is a tag named `<package>/<version>`, e.g. `vibe-d/0.10.5`.
  Destiny's fixes add `-destiny.N` (`vibe-d/0.10.5-destiny.1`).
- `index.json` at the top of the repository is the package list. DES
  reads it to find a package's folder and versions, and downloads only
  that folder at the tag.
- Each folder keeps its own license; there is no license for the whole
  repository.
- No file may be over GitHub's 100 MB limit.
