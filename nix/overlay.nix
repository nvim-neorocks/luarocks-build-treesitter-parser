{self}: final: prev: let
  luaPackage-override = luaself: luaprev: {
    luarocks-build-treesitter-parser = luaself.callPackage ({
      buildLuarocksPackage,
      luaOlder,
      luafilesystem,
    }:
      buildLuarocksPackage {
        pname = "luarocks-build-treesitter-parser";
        version = "scm-1";
        knownRockspec = "${self}/luarocks-build-treesitter-parser-scm-1.rockspec";
        src = self;
        disabled = luaOlder "5.1";
        propagatedBuildInputs = [
          luafilesystem
        ];
      }) {};

    tree-sitter-haskell =
      (luaself.callPackage ({
        buildLuarocksPackage,
        fetchFromGitHub,
        luaOlder,
        luarocks-build-treesitter-parser,
      }:
        buildLuarocksPackage {
          pname = "tree-sitter-haskell";
          version = "scm-1";
          knownRockspec = "${self}/fixtures/tree-sitter-haskell-scm-1.rockspec";
          src = fetchFromGitHub {
            owner = "tree-sitter";
            repo = "tree-sitter-haskell";
            rev = "95a4f0023741b3bee0cc500f3dab9c5bab2dc2be";
            hash = "sha256-bqcBjH4ar5OcxkhtFcYmBxDwHK0TYxkXEcg4NLudi08=";
          };
          preBuild = ''
            # tree-sitter CLI expects to be able to create log files, etc.
            export HOME=$(realpath .)
          '';
          buildInputs = with final; [
            gcc
            tree-sitter
          ];
          propagatedBuildInputs = [
            luarocks-build-treesitter-parser
          ];
          disabled = luaOlder "5.1";
        }) {})
      .overrideAttrs (oa: {
        fixupPhase = ''
          grep -q '(pat_wildcard)' $out/tree-sitter-haskell-scm-1-rocks/tree-sitter-haskell/scm-1/queries/haskell/highlights.scm
          if [ $? -ne 0 ]; then
            echo "Build did not create highlights.scm file with the expected content"
            exit 1
          fi
          if [ ! -f $out/lib/lua/5.1/parser/haskell.so ]; then
            echo "Build did not create parser/haskell.so in the expected location"
            exit 1
          fi
        '';
      });

    tree-sitter-rust =
      (luaself.callPackage ({
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
        }) {})
      .overrideAttrs (oa: {
        fixupPhase = ''
          grep -q ';;' $out/tree-sitter-rust-scm-1-rocks/tree-sitter-rust/scm-1/queries/rust/highlights.scm
          if [ $? -ne 0 ]; then
            echo "Build did not create highlights.scm file with the expected content"
            exit 1
          fi
        '';
      });

    tree-sitter-ocamllex = luaself.callPackage ({
      buildLuarocksPackage,
      fetchFromGitHub,
      luaOlder,
      luarocks-build-treesitter-parser,
      tree-sitter,
      nodejs_22,
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
          nodejs_22
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
      nodejs_22,
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
          nodejs_22
        ];
        propagatedBuildInputs = [
          luarocks-build-treesitter-parser
        ];
        disabled = luaOlder "5.1";
      }) {};

    tree-sitter-latex = luaself.callPackage ({
      buildLuarocksPackage,
      fetchFromGitHub,
      luaOlder,
      luarocks-build-treesitter-parser,
      tree-sitter,
      nodejs_22,
    }:
      buildLuarocksPackage {
        pname = "tree-sitter-latex";
        version = "scm-1";
        knownRockspec = "${self}/fixtures/tree-sitter-latex-scm-1.rockspec";
        src = fetchFromGitHub {
          owner = "latex-lsp";
          repo = "tree-sitter-latex";
          rev = "cd82eb40d31bdfe65f846f4e06292d6c804b5e0e";
          hash = "sha256-ptUIi8cMQ4CrnqZgnzJ0rnByd78y8l607+CSPKNrLEk=";
        };
        buildInputs = [
          tree-sitter
          nodejs_22
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

    tree-sitter-norg =
      (luaself.callPackage ({
        buildLuarocksPackage,
        fetchFromGitHub,
        luaOlder,
        luarocks-build-treesitter-parser,
      }:
        buildLuarocksPackage {
          pname = "tree-sitter-norg";
          version = "scm-1";
          knownRockspec = "${self}/fixtures/tree-sitter-norg-scm-1.rockspec";
          src = fetchFromGitHub {
            owner = "nvim-neorg";
            repo = "tree-sitter-norg";
            rev = "014073fe8016d1ac440c51d22c77e3765d8f6855";
            hash = "sha256-0wL3Pby7e4nbeVHCRfWwxZfEcAF9/s8e6Njva+lj+Rc=";
          };
          preBuild = ''
            # tree-sitter CLI expects to be able to create log files, etc.
            export HOME=$(realpath .)
          '';
          propagatedBuildInputs = [
            luarocks-build-treesitter-parser
          ];
          disabled = luaOlder "5.1";
          buildInputs = [
            final.tree-sitter
          ];
        }) {})
      .overrideAttrs (oa: {
        nativeBuildInputs =
          oa.nativeBuildInputs
          ++ (with final;
            lib.optionals stdenv.isDarwin [
              clang
            ]);
        fixupPhase = ''
          if [ ! -f $out/lib/lua/5.1/parser/norg.so ]; then
            echo "Build did not create parser/norg.so in the expected location"
            exit 1
          fi
        '';
      });

    tree-sitter-html_tags = luaself.callPackage ({
      buildLuarocksPackage,
      fetchFromGitHub,
      luaOlder,
      luarocks-build-treesitter-parser,
    }:
      buildLuarocksPackage {
        pname = "tree-sitter-html_tags";
        version = "scm-1";
        knownRockspec = "${self}/fixtures/tree-sitter-html_tags-scm-1.rockspec";
        src = fetchFromGitHub {
          owner = "nvim-neorocks";
          repo = "luarocks-stub";
          rev = "548853648d7cff7e0d959ff95209e8aa97a793bc";
          hash = "sha256-UmXOMUC6CsxHMgmrfehh9c5W/1A1MJThVx9GYD783fo=";
        };
        propagatedBuildInputs = [
          luarocks-build-treesitter-parser
        ];
        disabled = luaOlder "5.1";
        buildInputs = [
          final.tree-sitter
        ];
      }) {};
  };
  lua5_1_base =
    if prev.stdenv.isDarwin
    then
      prev.lua5_1.override {
        stdenv = final.clangStdenv;
      }
    else prev.lua5_1;
in {
  lua5_1 = lua5_1_base.override {
    packageOverrides = luaPackage-override;
  };
  lua51Packages = final.lua5_1.pkgs;
}
