package = "tree-sitter-toml"

version = "scm-1"

source = {
  url = "git://github.com/tree-sitter/tree-sitter-toml",
}

description = {
  summary = "tree-sitter parser for toml",
  homepage = "https://github.com/ikatyang/tree-sitter-toml",
  license = "MIT"
}

dependencies = {
  "lua >= 5.1",
  "luarocks-build-treesitter-parser",
}

build = {
  type = "tree-sitter",
  lang = "toml",
  sources = { "src/parser.c", "src/scanner.c" },
  generate_from_grammar = true,
  generate_requires_npm = true,
}
