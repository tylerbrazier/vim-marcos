# vim-marcos

Easier file marks management.

- `m<Tab>` marks the current file with an unused upper case mark
- `'<Tab>` prompt with completion to jump to a marked file
- `dm` for `:delmarks` with a list of file marks

That's it.

Under the hood, the mappings are running the command `:Marcos`
which marks the current file if not given an argument,
or jumps to the file name argument if given one.
The plugin also defines `:Marks`
which is like a simple version of `:marks` for files
(`dm` uses that).

## TODO
- haven't actually tested when there's no marks available
- don't allow marking terminal buffers, help pages, etc.
