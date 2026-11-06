# kanagawa_wave

Images inspired by Katsushika Hokusai's *The Great Wave off Kanagawa*
(c. 1831), written in PostScript and rendered with
[pscat](https://github.com/PSCatLabs/pscat). An ArtColony project.

![fractal_wave](gallery/previews/fractal_wave.png)

**`gallery/fractal_wave.ps`** follows the print's own self-similarity and
pushes it toward the psychedelic. The composition is measured off the
Met's public-domain scan of the woodblock: the cream back with its thin ink
outline, the face as a fan of dark fingers flecked with white, Fuji small in
the trough under a grey band of sky, the long swells and the three boats.
The fractal is Hokusai's claw (`kw-talon` in `lib/kw_foam.ps`): a white
finger that hooks at the tip and sprouts smaller claws along its back, which
sprout their own. The crest is one giant claw drawn only through its
children, the foreground wave is the great wave again at half size, and the
cave holds a smaller great wave, which holds another.

`Kpsy` (0 to 1, default 1) moves every colour from the print's toward a
hue that turns with finger and recursion depth. `Kfore` (default 1 when
`Kpsy > 0.3`) makes the foreground the great wave at half size; at 0 it is the
print's own foreground, a plain cream mound echoing Fuji over a low fan of
dark fingers and sparse open claws. At `-D Kpsy=0` it is the print's palette
and foreground, with no waves in the cave:

![fractal_wave at Kpsy=0](gallery/previews/fractal_wave-print.png)

![great_wave](gallery/previews/great_wave.png)

**`gallery/great_wave.ps`** is the project's first sketch, drawn from memory
before the scan was measured (`fractal_wave` at `Kpsy=0` is now much closer to
the woodblock). The
wave bodies are Bezier shapes with concentric streaks, the foam rims are
laced with `alongpath` dots, and the crest's claws come from `kw-claw`: a
tapered, curling finger that sprouts smaller fingers of its own.

## Setup

This repo uses the **released** pscat at the version pinned in
`.pscat-version`. That is currently a 0.7 release candidate, the build the
project started on: 0.6.x lacks the native noise operators (`fbm2` and
friends) and the embedded standard-35 fonts that later pieces will want. Install it from the
[releases page](https://github.com/PSCatLabs/pscat/releases):

```sh
v=$(cat .pscat-version)
t=aarch64-apple-darwin          # or x86_64-apple-darwin, x86_64-unknown-linux-musl, ...
gh release download "v$v" -R PSCatLabs/pscat -p "pscat-$v-$t.tar.gz" -p SHA256SUMS
shasum -a 256 -c SHA256SUMS --ignore-missing
tar xzf "pscat-$v-$t.tar.gz"
# keep the bundle together and put pscat and pscat-mcp on your PATH
pscat --version
```

## Rendering

```sh
scripts/render.sh                                  # every gallery piece -> renders/
scripts/render.sh -D Seed=4 gallery/great_wave.ps  # another seed
scripts/render.sh -D Kpsy=0 gallery/fractal_wave.ps    # the print's palette
DPI=144 scripts/render.sh gallery/great_wave.ps    # 2x
scripts/render.sh --sweep-seed 1:9 gallery/great_wave.ps   # contact sheet
```

Renders go to `renders/` (git-ignored). If disk space is tight, set
`KW_RENDERS` (and `TMPDIR`) to a directory on roomier storage.

## Layout

| Path | What |
|---|---|
| `gallery/*.ps` | Pieces, one file each: `fractal_wave.ps`, `great_wave.ps` |
| `gallery/previews/` | Chosen renders, committed by hand |
| `lib/kw_foam.ps` | `kw-talon`: the recursive foam claw (options `kw-tturn`, `kw-tbend`, `kw-tthick`, `kw-tkids`, `kw-tbare`, colour procs); `kw-finger`: a dark, striped, flecked finger of the wave's face; `kw-bez` |
| `lib/kw_wave.ps` | Wave procedures: Bezier helpers, `kw-claw`, `kw-crest`, `kw-boat`; load with `(lib/kw_wave.ps) run` from the repo root |
| `scripts/render.sh` | Render with strict lint and timing; `-D Name=value`, `--sweep-seed` |
| `docs/pscat-issues.md` | pscat bugs and requests found here, each filed upstream |
| `.claude/skills/` | The `pscat`, `psart` and `psviz` agent skills, copied from the pinned pscat tag |
| `.github/workflows/ci.yml` | Renders every piece with the pinned pscat on each PR |

## License

CC0-1.0. Hokusai's print is in the public domain.
