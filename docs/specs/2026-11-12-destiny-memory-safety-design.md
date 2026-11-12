# Destiny Memory Safety by Default — Design

Date: 2026-11-12
Status: Draft, awaiting review

## Goal

Make Destiny memory safe by default. Code written without any safety
annotations must be checked for spatial safety (bounds, pointer
arithmetic), escape safety (no dangling references to the stack), and
ownership/borrow safety (no mutating or outliving a borrowed-from
object). Unsafe operations stay possible, but only in code explicitly
marked `@system` or `@trusted`.

Along the way, improve compiler speed, generated-code speed and
security wherever measurements show a real gain.

## Decisions

| Decision | Choice | Reason |
|---|---|---|
| Opt-in or default | **Default for all code.** No edition gate, no legacy mode. | Destiny does not need to stay compatible with pre-2026 D code. |
| Existing code | **Updated** to compile and pass under the new rules: druntime, Phobos and the compiler test suite. | A default that the standard library cannot meet is not usable. |
| Phobos | **Forked and renamed Fate** as `Destiny-Org/fate`, kept in the sibling directory `../fate` that the build already uses. | Keeps the existing build layout; only the clone URL changes. |
| Compiler source | **Not affected.** The compiler is built by a host D compiler (upstream dmd/ldc/gdc), so Destiny's defaults do not apply to it. | Avoids a bootstrap problem. |
| Order | Four sub-projects, done one at a time, each leaving a passing build. | Each one depends on the one before it. |

## What exists today

These are opt-in features in the compiler. The design turns them on and
finishes them; it does not invent new ones from scratch.

| Feature | Flag | Where | State |
|---|---|---|---|
| Scoped pointers (escape analysis) | `-preview=dip1000` | `escape.d`, `FeatureState useDIP1000` in `globals.d` | Mature, used widely in upstream Phobos |
| Mutable function arguments | `-preview=dip1021` | `useDIP1021`; implies dip1000 (`mars.d`) | Works, narrow scope |
| Extra checks in unannotated code | `-preview=safer` | `FuncDeclaration.saferD`, `safe.d:339` | Works; does not make functions `@safe` |
| `@live` ownership/borrowing | `@live` attribute | `ob.d`, `spec/ob.dd` | Per-function opt-in, limited |
| Fast DFA engine + borrow checker | `-preview=fastdfa` | `compiler/src/dmd/dfa/`, plan in `plans/fastdfa_borrowchecker/` | Experimental, in progress |

## Sub-project 1: Scope and escape checking by default

**Change:** `useDIP1000` and `useDIP1021` default to enabled. The
`-revert=dip1000` switch is removed, since there is no legacy mode.

**Updating existing code:**
- druntime: add `scope` / `return scope` / `return ref` where references
  are not stored, fix real escapes, and mark genuinely unsafe low-level
  code `@system`.
- Phobos: same treatment. Upstream Phobos already builds with
  `-preview=dip1000` in many modules, so this is the smallest step.
- Tests: tests that check the old, non-DIP1000 behaviour are updated to
  expect the new diagnostics or are removed when they only test removed
  behaviour. `fail_compilation` tests with `REQUIRED_ARGS: -preview=dip1000`
  drop the now-redundant flag.

**Done when:** the full test suite (compiler, druntime, Phobos) passes on
the VM with no `-preview=dip1000` anywhere.

## Sub-project 2: `@safe` by default

**Change:** a function with no safety attribute is `@safe` instead of
`@system`. This replaces `TRUST.default_` meaning `@system` (see
`astenums.d:310`). The `safer` checks become redundant, because
unannotated code gets the full `@safe` checks, and the feature is
removed.

**Rules that need a precise answer in this sub-project's own spec:**
- `extern(C)` / `extern(C++)` declarations without a body: these cannot
  be checked, so they default to `@system`. This matches what other
  languages with safe defaults do and keeps calling C an explicit act.
- Templates and lambdas keep attribute inference.
- `main` and module constructors follow the normal rule.
- ImportC (`.c` files) stays `@system`.

**Updating existing code:** every druntime and Phobos function that does
pointer arithmetic, casts, unions with pointers, inline asm and so on is
marked `@system`, or `@trusted` with a safe interface. Each `@trusted`
added is reviewed, and the reason it is safe is written next to it in a
comment. Tests that rely on unannotated code being `@system` get explicit
`@system` annotations.

**Done when:** the full suite passes, and a count of `@trusted` blocks in
druntime and Phobos is recorded (used as a baseline by sub-project 4).

## Sub-project 3: Ownership and borrow checking by default

**Change:** finish the fast DFA borrow checker to the plan in
`plans/fastdfa_borrowchecker/` and run it on all `@safe` code. The engine
moves out of `-preview=fastdfa` and becomes part of normal semantic
analysis.

**Open design questions, settled in this sub-project's own spec:**
- whether the attribute keeps the name `__fastdfa_returnborrow` or gets a
  public name (for example `@borrow`);
- how `@live` relates to the new checker: merge it into the checker, or
  remove it;
- how much borrow inference happens without annotations.

**Done when:** the full suite passes with the checker on by default, and
the new checker's own tests cover all three rules from the plan: no
owner mutation during a borrow, the owner outlives the borrow, and
borrow variables are not reassigned.

## Sub-project 4: Security and speed

Driven by measurement only. No change goes in without a before/after
number.

**Baselines** (taken before sub-project 1 and after each sub-project):
- compile time and peak memory for building druntime, Phobos, and a
  fixed set of test programs;
- run time of a fixed benchmark set (compiler test `runnable` programs
  plus a few CPU-bound programs);
- number of `@trusted` and `@system` functions in druntime and Phobos.

**Work:**
- Profile the compiler on the compile-time baselines and fix the top
  hotspots, including any slowdown that sub-projects 1–3 add.
- Review every `@trusted` in druntime and Phobos; shrink or remove those
  that do not need it.
- Turn on hardening that costs little at run time, if measurements show
  that. Candidates: bounds checks kept in release builds for `@safe`
  code, stack protection.

## Testing

- Every test run happens on a Multipass VM (`sbx-YYYYMMDD-XXXX`), never on
  the local machine.
- Each sub-project adds `fail_compilation` tests for what it must reject
  and `compilable` / `runnable` tests for what it must still accept.
- The full suite runs at the end of each sub-project, and its output is
  read, not just its exit code.

## Documentation

For each sub-project:
- its own design spec in `docs/specs/`;
- updates to the language spec (`spec/memory-safe-d.dd`,
  `spec/function.dd`, `spec/attribute.dd`, `spec/ob.dd`);
- a changelog entry in `changelog/`;
- an updated section in the user guide `docs/memory-safety.md`, which
  explains the whole model in one place.

## Risks

- **Size.** druntime is about 264k lines and Phobos about 300k. Updating
  them is the bulk of the work. Each sub-project is broken into
  per-package steps so progress stays reviewable.
- **Upstream drift.** After the fork, upstream fixes to dmd, druntime and
  Phobos no longer arrive automatically.
- **Third-party D libraries** will not compile without changes. Accepted
  as a consequence of dropping pre-2026 compatibility.

## Not in scope

- Renaming the `.d` file extension or the `dmd.*` module names.
- Compatibility with D code written for upstream compilers.
