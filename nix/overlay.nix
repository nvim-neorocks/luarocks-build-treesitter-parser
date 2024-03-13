{self}: final: prev: let
  luaPackage-override = luaself: luaprev: {
    luarocks-build-treesitter-parser = luaself.callPackage ({
      buildLuarocksPackage,
      luaOlder,
    }:
      buildLuarocksPackage {
        pname = "luarocks-build-treesitter-parser";
        version = "scm-1";
        knownRockspec = "${self}/luarocks-build-treesitter-parser-scm-1.rockspec";
        src = self;
        disabled = luaOlder "5.1";
      }) {};
  };
in {
  lua5_1 = prev.lua5_1.override {
    packageOverrides = luaPackage-override;
  };
  lua51Packages = final.lua5_1.pkgs;
}
