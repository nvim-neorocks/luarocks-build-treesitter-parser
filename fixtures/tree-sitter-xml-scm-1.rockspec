rockspec_format = '3.0'

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
}

build_dependencies = {
  "luarocks-build-treesitter-parser",
}

build = {
  type = "treesitter-parser",
  lang = "xml",
  location = "xml",
}
