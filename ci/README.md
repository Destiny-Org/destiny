# Continuous Integration

When a Pull Request (PR) is opened, GitHub Actions checks that the compiler
still builds and that the compiler, druntime and Fate tests pass.

## Troubleshooting failed checks
When your PR fails checks, click on the "Details" link next to it to see what the error is.

Most log files are the output of `make`, which prints the commands it invokes followed by the output of that command.
Execution stops after a failed command, so errors can usually be found near the end of the log.
Because of multi-threaded builds, they don't need to be at the very end however.

You can Ctrl+F search for a triple asterisk `***` to easily find failed commands.

Errors caused by the changes you made should be addressed by pushing new commits to your branch.

When it looks like the error is unrelated to your PR's changes, try rebasing your branch.
First, ensure that you have a remote pointing to both Destiny-Org/destiny and your own fork, for example:
```
git remote -v
origin  git@github.com:your-github-name/destiny.git (fetch)
origin  git@github.com:your-github-name/destiny.git (push)
upstream        git@github.com:Destiny-Org/destiny.git (fetch)
upstream        git@github.com:Destiny-Org/destiny.git (push)
```

If you don't have an `upstream` remote, you can add it with:
```
git remote add upstream git@github.com:Destiny-Org/destiny.git
```

Then pull the latest changes from `main` and rebase your branch:
```
git checkout main
git pull --ff-only upstream main
git checkout your-branch
git rebase main
git push --force origin your-branch
```

Or more directly, without pulling in the changes locally:
```
git checkout your-branch
git fetch upstream
git rebase upstream/main
git push --force origin your-branch
```

If you still want to re-run the checks, you can amend your last commit and force push:
```
git commit --amend
git push --force origin your-branch
```

When an unrelated failure persists, ask a maintainer for help.

## Overview of checks

### Main

**Config**: [main.yml](../.github/workflows/main.yml)

Builds destiny and tests the compiler, druntime and Fate on several
platforms, using various D host compilers to build the compiler.

### C++ interop tests

**Config**: [runnable_cxx.yml](../.github/workflows/runnable_cxx.yml)

Tests calling between Destiny and C++ with a range of clang and g++
versions on Linux and macOS. The toolchains are newer than the ones in
the main checks, so newer C++ standards (C++17, C++20, …) get covered.

### Bootstrap

**Config**: [bootstrap.yml](../.github/workflows/bootstrap.yml)

Builds the compiler with a range of older upstream D compilers as the host
compiler, to check that destiny still builds with the oldest supported one.

### Build with dub

**Config**: [build_with_dub.yml](../.github/workflows/build_with_dub.yml)

Checks that the compiler and the compiler-as-a-library package still build
with dub (`dub run dmd:compiler`, `dub build dmd:frontend`).

### pre-commit

**Config**: [.pre-commit-config.yaml](../.pre-commit-config.yaml), [pre_commit.yml](../.github/workflows/pre_commit.yml)

pre-commit checks for redundant white space, such as trailing whitespace and newlines.

To fix your changes automatically before committing, install `pre-commit`
with your package manager or `pip` (see https://pre-commit.com/), then run
`pre-commit install` in the root of the repository. That adds a hook to
`.git/hooks/pre-commit` which runs the checks on every commit.

To check all files at once, run `pre-commit run --all-files`.
