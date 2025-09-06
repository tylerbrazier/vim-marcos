# vim-marcos

Easier file marks management.

- `m<Tab>` marks the current file with the next unused upper case mark
- `'<Tab>` starts completion to jump to a file mark
- `dm` for `:delmarks` with a list of file marks

That's it.

Under the hood, the mappings are running the command `:Marcos`
which marks the current file if not given an argument,
or jumps to the file name argument if given one.
The plugin also defines `:Marks`
which is like a simple version of `:marks` for files
(`dm` uses that).

## TODO
- make completion filter by what's already been typed
- consider user's `wildmenu` and `wildcharm` for mappings
- don't set `wildcharm`
- haven't actually tested when there's no marks available
