# kanagawa_wave

PostScript generative art after Hokusai's *Great Wave*, rendered with pscat. See `README.md` for setup and layout.

- Use the released pscat at the version in `.pscat-version`, never a source checkout. The `pscat`, `psart` and `psviz` skills in `.claude/skills/` come from that same release tag; refresh them when the pin moves.
- Render with `scripts/render.sh`, not bare `pscat`, so every run is strictly linted and timed. Look at the PNG after every render, and at a zoomed crop (`DPI=216`) when judging detail such as the claws.
- Never run `pscat file.ps` without `--png`/`--headless`/`-e`: it opens a window and blocks.
- Disk space on the dev machine is tight: put renders, downloads and temp files on external storage (`KW_RENDERS`, `TMPDIR`), not in the repo or the home disk.
- Load repo procedures with `(lib/kw_*.ps) run` from the repo root. Every repo library and every name it defines uses the `kw` prefix, so nothing shadows pscat's built-in `lib/` (`render.sh` refuses other names).
- Seed every piece (`Seed srand`, with `/Seed where { pop } { /Seed N def } ifelse`) so renders reproduce, and derive any other seed (scatter's `/Seed`) from `rand` so `--sweep-seed` varies it.
- A piece sets its options *before* its `(lib/...) run` lines: libraries use `kw-default`, which keeps whatever is already defined. Options read at call time (`kw-lean`, `kw-grow`) may be re-def'd between calls.
- artkit colour helpers (`mix3`, `shade`, `palpick`) leave `r g b` on the stack; follow them with `setrgbcolor`, not `kw-rgb`.
- PostScript has no locals: procedures keep temporaries in their own `N dict begin ... end`.
- When a pscat bug, a missing feature or a skill-doc mistake turns up, search PSCatLabs/pscat issues (open and closed), file it there with the version and a minimal repro, and add a row to `docs/pscat-issues.md`.
- Work happens on a branch per change, merged by PR into `main` once CI (which renders every piece with the pinned pscat) is green.
