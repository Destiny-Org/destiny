# Destiny

**Fast like C. Safe by default. Simple to write.**

Destiny is a compiled programming language that catches memory bugs before
your program runs, without making you fight the compiler.

## Why Destiny

- **Memory safe by default.** Every function is checked as `@safe` unless
  you say otherwise. Dangling pointers, buffer overruns and stack memory
  escaping a function are compile errors, not crashes in production.
- **The compiler tells you how to fix it.** Errors come with a `fix:` line
  that says what to change, not just what is wrong.
- **Fast programs, fast builds.** Destiny compiles to native machine code
  and the compiler itself is quick, so the edit-build-run loop stays short.
- **Easy to read and write.** Familiar C-style syntax, garbage collection
  when you want it, and manual memory control (`@nogc`) when you need it.
- **Unsafe code only where you mark it.** Low-level code goes in `@system`
  or `@trusted` functions, so the risky parts of a program are easy to find
  and review.
- **Powerful at compile time.** Templates, compile-time function execution
  and static checks, with no separate macro language.
- **Talks to C directly.** Call C libraries without wrappers or bindings
  generators.
- **Tests built in.** Write `unittest` blocks next to your code and run them
  with one flag.
- **Batteries included.** Fate, the standard library, plus ready-to-use
  packages (web servers, JSON, YAML, databases and more) and editor support
  with live errors and quick fixes.

## How it compares

| | Destiny | C / C++ | Rust | Go |
|---|---|---|---|---|
| Native, compiled | ✅ | ✅ | ✅ | ✅ |
| Memory safe by default | ✅ | ❌ | ✅ | ✅ |
| Low-level control when needed | ✅ | ✅ | ✅ | limited |
| Garbage collector optional | ✅ | no GC | no GC | always on |
| Compile-time code execution | ✅ | limited | macros | ❌ |
| Gentle learning curve | ✅ | ❌ | ❌ | ✅ |

## Download

Get the latest `destiny64-<version>-linux.tar.xz` from
[Releases](https://github.com/Destiny-Org/destiny/releases) (Linux x86_64).

```
tar xJf destiny64-*-linux.tar.xz
export PATH="$PWD/destiny64/bin:$PATH"
```

## Hello world

```d
import std.stdio;

void main()
{
    writeln("Hello, Destiny!");
}
```

```
destiny -run hello.d
```

## Packages

Download `des` (Destiny's package manager) from
[DES releases](https://github.com/Destiny-Org/des/releases) and put it on
your `PATH`. Then:

```
des init myapp
cd myapp
des add vibe-d
des run
```

Packages come from [Destiny-Org/packages](https://github.com/Destiny-Org/packages).

## Editor support

Download `serve-destiny` from
[serve-destiny releases](https://github.com/Destiny-Org/serve-destiny/releases)
for errors, completion and quick fixes in your editor.

## License

Boost Software License 1.0; see [LICENSE.txt](LICENSE.txt).
