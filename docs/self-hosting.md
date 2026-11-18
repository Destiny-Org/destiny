# Building the compiler with Destiny (self-hosting)

The Destiny compiler is normally built with an upstream D host compiler
(`HOST_DC`). Its own sources are written for upstream's `@system` default, so
when Destiny compiles them it is told to use that default:

```
-revert=safedefault   unannotated functions are @system (upstream's default)
```

- `compiler/src/build.d` adds the switch when the host compiler is Destiny
  (detected by `-revert=h` listing `safedefault`). An upstream host never sees it.
- The compiler unit tests (`compiler/test/unit/`) are built with Destiny and
  the switch.
- The libraries shipped with the compiler (`object`, `core`, `rt`, `std`,
  `etc`) keep the `@safe` default even with the switch: they are prebuilt
  with it, and their mangled names must match.
- Explicit annotations still apply: `@safe` code is checked, templates and
  literals still infer.

## Why not `@system:` in every module

That was tried first. Under an upstream host compiler a `@system:` label also
makes every field after it a `@system` variable, so `@safe` code reading those
fields fails the build (`-de`). The switch changes nothing for the host.

## Phases

1. **Destiny compiles the compiler** with `-revert=safedefault`, and the unit
   tests are built that way. Test: `compilable/destiny_revert_safedefault.d`.
2. **Bootstrap check:** build the compiler with the Destiny compiler from
   phase 1 ("stage 2") and run the full suite with it:

   ```
   mkdir -p generated/linux/stage1
   cp -r generated/linux/release/64 generated/linux/stage1/64   # same depth: destiny.conf uses relative paths
   make -k -j2 HOST_DC=$PWD/generated/linux/stage1/64/destiny destiny-test
   ```

   CI already does this: `ci/run.sh rebuild` builds the compiler with the
   one it just built (`bootstrap.yml`, `main.yml`), and `build.d` adds the
   switch automatically.
3. **Make modules really `@safe`, one at a time.** Add `@safe:` after the
   module line (both compilers then check the module) and fix what is
   reported. Start with leaf modules (`root/`, `common/`, small front-end
   files); leave `dinterpret.d`, `ctfeexpr.d` and `constfold.d` for last.
   Typical fixes:
   - accessors for `__gshared` state instead of direct access;
   - slices and indexes instead of pointer arithmetic;
   - `@trusted` wrappers with safe interfaces around C calls (each listed in
     [trusted-review.md](trusted-review.md));
   - `scope` / `return scope` on parameters.

   Each module is one reviewable change that keeps both builds green.

## Size of phase 3

Compiling `compiler/src/destiny` with Destiny's `@safe` default (2026-11-17):
at least 2,655 errors in the first 35 files (the run stops early; the front
end has ~150 files). Worst: `dinterpret.d` (688), `constfold.d` (304),
`doc.d` (292), `ctfeexpr.d` (207), `astbase.d` (171).

Converted modules (`@safe:`, checked by both compilers):

- `common/`: `bitfields`, `blake3`, `charactertables`, `identifiertables`,
  `int128`, `sha`;
- `root/`: `ctfloat`, `hash`, `longdouble`, `optional`, `strtold`, `utf`.

Next in `root/` and `common/` (errors when labelled, host / Destiny):
`complex` (1/1), `speller` (2/2), `region` (5/0), `man` (7/0),
`response` (7/0), `smallbuffer` (7/7), `env` (7/7), `outbuffer` (8/9),
`file` (11/12), `bitarray` (16/16), `string` (23/4), `port` (31/0),
`aav` (37/43), `filename` (52/39), `common/file` (53/56), `rmem` (99/2),
`array`, `stringtable`. Fix the errors first, then label the module.

The backend (`compiler/src/destiny/backend`) is C-style code and is out of scope
unless there is a specific reason to convert a file.
