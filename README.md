# vim-marcos

Easier file marks management so you don't have to fuss with the letters.

- `m<Tab>` marks the current file with an unused upper case mark
- `'<Tab>` prompt with completion to jump to a marked file
- `dm` for `:delmarks` with a list of file marks

That's it. Under the hood, the script defines commands `:Marcos` and `:Marks`
which the mappings make use of. Read the code if you care to know they work.
