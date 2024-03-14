-- Sometimes, luarocks will automatically search for a rock called "luarocks-build-<build.type>",
-- so the build type had to be changed to treesitter-parser.
-- This module ensures that working rockspecs that use "tree-sitter" as a build type still work.
return require("luarocks.build.treesitter-parser")
