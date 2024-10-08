rockspec_format = '3.0'

package = "tree-sitter-ocamllex"

version = "scm-1"

source = {
  url = "git://github.com/tree-sitter/tree-sitter-ocamllex",
}

description = {
  summary = "tree-sitter parser for ocamllex",
  homepage = "https://github.com/atom-ocaml/tree-sitter-ocamllex",
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
  lang = "ocamllex",
  generate = true,
}
