local _MODREV, _SPECREV = "scm", "-1"
rockspec_format = "3.0"
package = "lua-build-treesitter-parser"
version = _MODREV .. _SPECREV

dependencies = {
    "lua >= 5.1",
}

test_dependencies = {
    "lua >= 5.1",
}

source = {
    url = "git://github.com/nvim-neorocks/" .. package,
}
