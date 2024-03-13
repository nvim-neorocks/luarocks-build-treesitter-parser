{self}: final: prev: let
  luaPackage-override = luaself: luaprev: {
    tree-sitter-rust = luaself.callPackage ({
      buildLuarocksPackage,
      fetchFromGitHub,
      luaOlder,
      luarocks-build-treesitter-parser,
    }:
      buildLuarocksPackage {
        pname = "tree-sitter-rust";
        version = "scm-1";
        knownRockspec = "${self}/fixtures/tree-sitter-rust-scm-1.rockspec";
        src = fetchFromGitHub {
          owner = "tree-sitter";
          repo = "tree-sitter-rust";
          rev = "3a56481f8d13b6874a28752502a58520b9139dc7";
          hash = "sha256-6ROXeKuPehtIOtaI1OJuTtyPfQmZyLzCxv3ZS04yAIk=";
        };
        propagatedBuildInputs = [
          luarocks-build-treesitter-parser
        ];
        disabled = luaOlder "5.1";
      }) {};

    tree-sitter-ocamllex = luaself.callPackage ({
      buildLuarocksPackage,
      fetchFromGitHub,
      luaOlder,
      luarocks-build-treesitter-parser,
      tree-sitter,
      nodejs_21,
    }:
      buildLuarocksPackage {
        pname = "tree-sitter-ocamllex";
        version = "scm-1";
        knownRockspec = "${self}/fixtures/tree-sitter-ocamllex-scm-1.rockspec";
        src = fetchFromGitHub {
          owner = "atom-ocaml";
          repo = "tree-sitter-ocamllex";
          rev = "4b9898ccbf198602bb0dec9cd67cc1d2c0a4fad2";
          hash = "sha256-YhmEE7I7UF83qMuldHqc/fD/no/7YuZd6CaAIaZ1now=";
        };
        buildInputs = [
          tree-sitter
          nodejs_21
        ];
        propagatedBuildInputs = [
          luarocks-build-treesitter-parser
        ];
        disabled = luaOlder "5.1";
      }) {};

    tree-sitter-toml = luaself.callPackage ({
      buildLuarocksPackage,
      fetchFromGitHub,
      luaOlder,
      luarocks-build-treesitter-parser,
      tree-sitter,
      nodejs_21,
    }:
      buildLuarocksPackage {
        pname = "tree-sitter-toml";
        version = "scm-1";
        knownRockspec = "${self}/fixtures/tree-sitter-toml-scm-1.rockspec";
        src = fetchFromGitHub {
          owner = "ikatyang";
          repo = "tree-sitter-toml";
          rev = "8bd2056818b21860e3d756b5a58c4f6e05fb744e";
          hash = "sha256-z9MWNOBxLHBd/pVs5/QiSSGtaW+DUd7y3wZXcl3hWnk=";
        };
        buildInputs = [
          tree-sitter
          nodejs_21
        ];
        propagatedBuildInputs = [
          luarocks-build-treesitter-parser
        ];
        disabled = luaOlder "5.1";
      }) {};

    tree-sitter-xml = luaself.callPackage ({
      buildLuarocksPackage,
      fetchFromGitHub,
      luaOlder,
      luarocks-build-treesitter-parser,
    }:
      buildLuarocksPackage {
        pname = "tree-sitter-xml";
        version = "scm-1";
        knownRockspec = "${self}/fixtures/tree-sitter-xml-scm-1.rockspec";
        src = fetchFromGitHub {
          owner = "ObserverOfTime";
          repo = "tree-sitter-xml";
          rev = "c23bd31d0aa72bfc01238b2546d5e823d8006709";
          hash = "sha256-oPjO7y2xSVxvP0bpCFo/oGP4hPs3kWJ728d/R5PUdK4=";
        };
        propagatedBuildInputs = [
          luarocks-build-treesitter-parser
        ];
        disabled = luaOlder "5.1";
      }) {};
  };
in {
  lua5_1 = prev.lua5_1.override {
    packageOverrides = luaPackage-override;
  };
  lua51Packages = final.lua5_1.pkgs;
}
