package = "tree-sitter-latex"

version = "scm-1"

source = {
  url = "git://github.com/latex-lsp/tree-sitter-latex",
}

description = {
  summary = "tree-sitter parser for latex",
  homepage = "https://github.com/latex-lsp/tree-sitter-latex",
  license = "MIT"
}

dependencies = {
  "lua >= 5.1",
  "luarocks-build-treesitter-parser",
}

build = {
  type = "treesitter-parser",
  lang = "latex",
  sources = { "src/parser.c", "src/scanner.c" },
  generate = true,
}
