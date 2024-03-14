package = "tree-sitter-xml"

version = "scm-1"

source = {
  url = "git://github.com/tree-sitter/tree-sitter-xml",
}

description = {
  summary = "tree-sitter parser for xml",
  homepage = "https://github.com/ObserverOfTime/tree-sitter-xml",
  license = "MIT"
}

dependencies = {
  "lua >= 5.1",
  "luarocks-build-treesitter-parser",
}

build = {
  type = "treesitter-parser",
  lang = "xml",
  sources = { "src/parser.c", "src/scanner.c" },
  location = "xml",
}
