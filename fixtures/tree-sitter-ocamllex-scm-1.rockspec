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
  "luarocks-build-treesitter-parser",
}

build = {
  type = "tree-sitter", -- Make sure old version still works
  lang = "ocamllex",
  sources = { "src/parser.c", "src/scanner.c" },
  generate_from_grammar = true,
}
