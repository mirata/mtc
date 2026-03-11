This codebase is for Marathon - a mod I am making for zdoom (more specifically lzdoom supported on the meta quest)
Although some of this code may look like C++ it is ZScript, a syntactically similar but different language.
Some documentation can be found at:
- https://zdoom.org/wiki/ZScript
- https://zdoom-docs.github.io/staging/ZScript.html
- https://github.com/jekyllgrim/ZScript_Basics

Often if I want to be sure something is supported, i deep dive the .zs files in the lzdoom source
- https://github.com/christianhaitian/lzdoom

Please be sure all commands written are supported. It is recommended that you search these sites for suitable commands if ever unsure.

Additionally, I sometimes write UDBScript, a language that automates commands in the Ultimate Doom Builder editor. UDBScript files are JS files but they have a UDBScript set of objects and classes.
Documentation can be found at:
- - UDBScript Docs: https://biwa.github.io/udbscript-docs/

## Verification policy (allowed sources)

When uncertain about whether a UDBScript or ZScript API / flag / property / type exists (or behaves the same in LZDoom), you are allowed and encouraged to verify before answering by consulting:

- ZDoom wiki ZScript pages: https://zdoom.org/wiki/ZScript
- Staging ZScript docs: https://zdoom-docs.github.io/staging/ZScript.html
- ZScript Basics examples: https://github.com/jekyllgrim/ZScript_Basics
- LZDoom source (authoritative for "does LZDoom support this?"): https://github.com/christianhaitian/lzdoom

If you did not verify against these sources in the current session, say so plainly (e.g., "Answering from general knowledge; not verified against LZDoom source yet").

## LZDoom/ZScript compatibility notes (learned from this repo)

These are common pitfalls in this codebase/toolchain; avoid repeating them:

- Avoid returning dynamic arrays from functions (e.g., `static Array<int> Foo()`); prefer an output parameter pattern like `static void Foo(Array<int> out)`.
- Avoid `Array<Sector>` (and similar arrays of engine object types). Prefer `Array<int>` of sector indices and resolve via `level.sectors[idx]`.
- Some builds may not resolve `Sector` as a local variable type in scripts; prefer `let s = level.sectors[idx];` instead of `Sector s = ...`.

## Debugging / feedback loop

When implementing or changing gameplay logic:

1. Add temporary `Console.Printf` debug that prints a single concise line.
2. Throttle spam (e.g., print every N tics) and remove/disable once the behavior is confirmed.
3. If a compile/runtime issue happens because of an engine limitation, record the limitation in this file under "compatibility notes".
4. Prefer minimal-scope changes: keep existing gates/behavior checks, and only replace the computation that is wrong.

If you encounter a new repeating class of issue, add a bullet here describing:
- Symptom (compiler error text or runtime behavior)
- Root cause (what ZScript/LZDoom feature was missing/different)
- Preferred pattern to use instead