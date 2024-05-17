package = "tree-sitter-norg"

version = "scm-1"

source = {
  url = "git://github.com/tree-sitter/tree-sitter-norg",
}

description = {
  summary = "tree-sitter parser for norg",
  homepage = "https://github.com/tree-sitter/tree-sitter-norg",
  license = "MIT"
}

dependencies = {
  "lua >= 5.1",
  "luarocks-build-treesitter-parser",
}

build = {
  type = "treesitter-parser",
  lang = "norg",
  platforms = {
    macosx = {
      libflags = {
        "-bundle",
        "-undefined",
        "dynamic_lookup",
        "-all_load",
        "-std=c++11",
      },
    },
  },
}
