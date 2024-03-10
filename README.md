# luarocks-build-treesitter-parser

> [!WARNING]
>
> This is early WIP!

A luarocks build backend for tree-sitter parsers that require npm
or that need to be generated using the tree-sitter CLI

## Example rockspec

```lua
package = "tree-sitter-LANG"

version = "scm-1"

source = {
  url = "git://github.com/tree-sitter/tree-sitter-LANG",
}

description = {
  summary = "tree-sitter parser for LANG",
  homepage = "https://github.com/tree-sitter/tree-sitter-LANG",
  license = "MIT"
}

dependencies = {
  "lua >= 5.1",
  "luarocks-build-treesitter-parser",
}

build = {

  type = "tree-sitter",

  sources = { "src/parser.c", "src/scanner.c" },

  ---@type boolean? (optional) Is npm required to generate the sources?
  generate_requires_npm = false,

  ---@type boolean? (optional) Must the sources be generated using the tree-sitter CLI?
  generate_from_grammar = true,

  ---@type boolean? (optional) Use a Makefile to build the grammar?
  use_makefile = false,

  ---@type string? (optional) tree-sitter grammar's location (relative to the source root).
  location = "libs/tree-sitter-LANG",

}
```
