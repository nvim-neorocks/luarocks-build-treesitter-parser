rockspec_format = '3.0'

package = "tree-sitter-toml"

version = "scm-1"

source = {
  url = "git://github.com/tree-sitter/tree-sitter-toml",
}

description = {
  summary = "tree-sitter parser for toml",
  homepage = "https://github.com/tree-sitter/tree-sitter-toml",
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
  lang = "toml",
  generate = true,
  generate_from_json = true,
}
