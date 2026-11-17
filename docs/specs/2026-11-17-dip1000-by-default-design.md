# Sub-project 1: DIP1000 scope checking by default — Design

Date: 2026-11-17
Status: Draft, awaiting review
Parent: [2026-11-12-destiny-memory-safety-design.md](2026-11-12-destiny-memory-safety-design.md)

## Goal

Lifetime ("scope") checking from DIP1000 is always on. `@safe` code can no
longer let a pointer or reference to stack memory outlive it, without any
`-preview` flag.

## Measured starting point

A throwaway build in the `destiny-lang` VM with `useDIP1000` and `useDIP25`
defaulting to *enabled* (no other change), run against the full suites:

| Suite | Result |
|---|---|
| druntime build + unittests | pass |
| Fate build + unittests | pass (except the known flaky `std.process` test, same as baseline) |
| compiler test suite | 17 of ~4,000 tests fail |

druntime and Fate already build with `-preview=dip1000`, so no library changes
are needed for this sub-project.

## Compiler change

In `compiler/src/dmd/`:

1. `globals.d`: `useDIP1000` and `useDIP25` become always enabled.
2. `cli.d`, `mars.d`: `-preview=dip1000`, `-preview=dip25` and `-dip1000` stay
   accepted but do nothing (deprecation message: "now always enabled").
   `-revert=dip1000` and `-revert=dip25` are removed: Destiny has no legacy mode.
3. The ~20 `useDIP1000 == FeatureState.enabled` checks stay as they are; they
   are always true now. Simplifying them is left to sub-project 4, so this change
   stays small and reviewable.
4. Deprecations that DIP1000 reports as "will become an error" in `@safe` code
   become errors (they already are with the preview on).

## The 17 failing tests

**A. Expected-message tests (7)** — `fail_compilation/` tests whose expected
output changes because DIP1000 reports more, or different, errors. Fix: update
`TEST_OUTPUT` to the new messages, after checking each new message is correct.

`fail_scope`, `fail6497`, `test13536`, `test16365`, `diag10319`, `fastdfa`,
`__fastdfa_escape_test`

**B. Tests that rely on the old rules (6)** — code that is now rejected or newly
accepted. Fix per test: add `scope` / `return scope` where the code is fine,
flip assertions that checked old behaviour, or mark the function `@system`
where the test is about something else.

- `runnable/testsafe` — asserts `&x` of a local is illegal in `@safe`; with
  DIP1000 it is legal if the pointer stays scoped. Assertion flipped.
- `runnable/foreach5`, `compilable/test23145`, `compilable/fastdfa` — scope
  parameters returned or passed to non-scope functions; add `return scope` /
  `scope`.
- `runnable/arrayop`, `compilable/nogc` — array literal now allocated on the
  stack / closure now required; adjust the test code.

**C. Needs investigation (4)** — failure output did not show a single error
line: `runnable/staticaa`, `runnable/nrvo`, `runnable/issue18919`,
`compilable/json2` (JSON output now includes inferred `scope` attributes —
likely just a new expected file).

Each test is fixed so it keeps testing what it was written for. Tests that only
checked the absence of DIP1000 are changed to test the new default instead.

## Tests added

- `fail_compilation/destiny_dip1000_default.d`: escaping a stack pointer from
  `@safe` code is an error **without any flags**.
- `compilable/destiny_dip1000_default.d`: correct scoped code compiles without
  flags.
- `fail_compilation/destiny_revert_dip1000.d`: `-revert=dip1000` is rejected.

## Documentation

- Changelog `changelog/destiny.dip1000-default.dd`.
- `spec/memory-safe-d.dd`: scope checking is no longer optional.
- `docs/memory-safety.md` (new): user guide, starting with this section.
- `docs/development.md`: status.

## Done when

In the `destiny-lang` VM: the compiler test suite, druntime unittests and Fate
unittests all pass (Fate apart from the known flaky `std.process`), with no
`-preview=dip1000` needed anywhere.
