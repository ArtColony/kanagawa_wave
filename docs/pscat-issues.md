# pscat issues

pscat bugs, feature requests and skill-doc problems found while working on
this repo. They are filed directly on
[PSCatLabs/pscat](https://github.com/PSCatLabs/pscat/issues), after searching
open and closed issues for duplicates. Record each one here with its link.

| # | Upstream | Kind | Summary | Found with |
|---|---|---|---|---|
| 1 | [#1035](https://github.com/PSCatLabs/pscat/issues/1035) | enhancement | `pscat file.ps` with no output flag opens a window and blocks silently in a non-interactive shell (agents time out) | 0.7.0-rc.4 |
| 2 | [#1036](https://github.com/PSCatLabs/pscat/issues/1036) | enhancement | a non-EPSF file's `%%BoundingBox` is ignored with no message; the piece lands on a Letter page (`scripts/render.sh` passes `--page` from the box) | 0.7.0-rc.4 |
| 3 | [#1037](https://github.com/PSCatLabs/pscat/issues/1037) | documentation | psart skill doesn't say `mix3` and `shade` return `r g b`, not an array | 0.7.0-rc.4 |
| 4 | [#1043](https://github.com/PSCatLabs/pscat/issues/1043) | enhancement | errors inside a `run` file report the top-level file's line and no file name (`scripts/render.sh` now runs a piece directly when there is no `-D`) | 0.7.0-rc.4 |
