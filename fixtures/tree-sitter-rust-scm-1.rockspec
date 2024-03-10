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
  "luarocks-build-treesitter-parser",
}

build = {
  type = "tree-sitter",
  lang = "rust",
  sources = { "src/parser.c", "src/scanner.c" },
}
