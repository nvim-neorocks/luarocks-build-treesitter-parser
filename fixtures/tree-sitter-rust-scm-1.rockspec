rockspec_format = '3.0'

package = "tree-sitter-rust"

version = "scm-1"

source = {
  url = "git://github.com/tree-sitter/tree-sitter-rust",
}

description = {
  summary = "tree-sitter parser for rust",
  homepage = "https://github.com/tree-sitter/tree-sitter-rust",
  license = "MIT"
}

dependencies = {
  "lua >= 5.1",
}

build_dependencies = {
  "luarocks-build-treesitter-parser",
}

build = {
  type = "treesitter-parser",
  lang = "rust",
  queries = {
    ["highlights.scm"] = [[
;;
]],
  },
}
