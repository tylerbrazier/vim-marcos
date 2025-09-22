# vim-marcos

Easier file marks management so you don't have to fuss with the letters.

- `m<Tab>` marks the current file with an unused upper case mark
- `'<Tab>` prompt with completion to jump to a marked file
- `dm` for `:delmarks` with a list of file marks

That's it.

Under the hood, the mappings are running the command `:Marcos`
which, without an argument, marks the current file (`m<Tab>`);
if the argument is a file mark or file name, it jumps there (`'<Tab>`).
The plugin also defines `:Marks`
which is like a simple version of `:marks` for files (`dm` uses that).
