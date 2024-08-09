rockspec_format = '3.0'

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
}

build_dependencies = {
  "luarocks-build-treesitter-parser",
}

build = {
  type = "treesitter-parser",
  lang = "latex",
  generate = true,
}
