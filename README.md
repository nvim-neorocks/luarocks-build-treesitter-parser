# luarocks-build-treesitter-parser

> [!WARNING]
>
> This is early WIP!

A luarocks build backend for tree-sitter parsers. 

Used by the [Neovim User Rock Repository (NURR)](https://github.com/nvim-neorocks/nurr).

The resulting parser libraries are installed to
`<luarocks-install-tree>/lib/lua/<lua-version>/parser`.

> [!IMPORTANT]
>
> The installed parsers are *not* lua modules, but they
> can be added to the `package.cpath`.

## Example rockspec

```lua
package = "tree-sitter-LANG"

version = "scm-1"

source = {
  url = "https://github.com/tree-sitter/tree-sitter-LANG/archive/<REF>.zip",
  dir = 'tree-sitter-LANG-<REF>',
}
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

  type = "treesitter-parser",
 
  ---@type string (required) Name of the language, e.g. "haskell".
  lang = "LANG",

  ---@type string[] (required) parser source files.
  sources = { "src/parser.c", "src/scanner.c" },

  ---@type boolean? (optional) Must the sources be generated using the tree-sitter CLI?
  generate_from_grammar = true,

  --- Ignored if generate_from_grammar is false.
  ---@type boolean? (optional) Is npm required to generate the sources?
  generate_requires_npm = false,

  ---@type string? (optional) tree-sitter grammar's location (relative to the source root).
  location = "libs/tree-sitter-LANG",

  --- Overwrites any existing queries with the embedded queries.
  --- Will add 'queries' to the rockspec's 'copy_directories' if set.
  ---@type table<string, string>
  queries = {
        -- Will create a `queries/<lang>/highlights.scm`
        -- Note that the content should not be indented.
        ["highlights.scm"] = [==[
(signature
  name: (variable) @function)

(function
  name: (variable) @function)
]==],
  },

}
```

> [!TIP]
>
> You can find more examples in the [fixtures](./fixtures) directory.

## Usage with Neovim

Neovim searches for tree-sitter parsers in a `parser` directory
on the runtimepath (`:h rtp`).

Parsers installed with luarocks-build-treesitter-parser can be found
by creating a symlink to the `parser` directory in the install location
on the Neovim runtimepath.

