# Changelog

## [4.1.2](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/compare/v4.1.1...v4.1.2) (2024-07-11)


### Bug Fixes

* **darwin:** remove debug symbols (`&lt;lang&gt;.so.dSYM`) ([#29](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/issues/29)) ([f57b899](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/f57b899d39156138c14fd95536624509ae8c20fe))

## [4.1.1](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/compare/v4.1.0...v4.1.1) (2024-06-30)


### Bug Fixes

* **queries:** better error messages ([7ed9925](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/7ed99254397063d4cb72390ff5f4d881d1e23191))
* **queries:** use absolute path ([9825ac1](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/9825ac1f63b289cae6b2111684614daf121d535e))

## [4.1.0](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/compare/v4.0.0...v4.1.0) (2024-05-27)


### Features

* add minimum tree-sitter cli requirement to error output ([#24](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/issues/24)) ([221e4c5](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/221e4c5c1d07c1bbc7896c11221c5be02a2d2b42))

## [4.0.0](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/compare/v3.0.0...v4.0.0) (2024-05-17)


### ⚠ BREAKING CHANGES

* default to using `tree-sitter build`

### Features

* default to using `tree-sitter build` ([d8bc6e0](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/d8bc6e0d79b1e97b1882a91f2a7e00f1434866db))

## [3.0.0](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/compare/v2.0.0...v3.0.0) (2024-05-10)


### ⚠ BREAKING CHANGES

* update parser source generation logic ([#18](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/issues/18))

### Bug Fixes

* update parser source generation logic ([#18](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/issues/18)) ([7e2b71a](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/7e2b71a7c801fcadd36e12a22a6026aba5feb695))

## [2.0.0](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/compare/v1.5.0...v2.0.0) (2024-04-28)


### ⚠ BREAKING CHANGES

* remove tree-sitter build script backward compatibility adapter

### Features

* remove tree-sitter build script backward compatibility adapter ([f5d475f](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/f5d475f5fdb16593ad06f4b827efb330017dc80d))
* try tree-sitter build before falling back to builtin build ([2fefd61](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/2fefd61f9584c83d1811d02863e0954fce50c049))

## [1.5.0](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/compare/v1.4.0...v1.5.0) (2024-04-15)


### Features

* add `build.libflags` option ([#11](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/issues/11)) ([af4fd61](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/af4fd618a7a42977a31c32a64d7649dbcd6c38cc))


### Bug Fixes

* only copy parser_dir if it exists ([b6d37f2](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/b6d37f2293e3effdc11807080d6093ca04ae0bba))

## [1.4.0](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/compare/v1.3.3...v1.4.0) (2024-04-13)


### Features

* copy parser to the lib_dir ([3240eec](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/3240eec5fc6ec7189dca03ed37565648207176a3))

## [1.3.3](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/compare/v1.3.2...v1.3.3) (2024-03-28)


### Bug Fixes

* **windows:** create queries directory before queries/&lt;lang&gt; ([bb2dd48](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/bb2dd488004afb66c4ac8b5f51ca90aa690a6481))


### Reverts

* **windows:** use 'w' instead of 'w+' to write queries files ([d609c53](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/d609c53fa158d817f2796c99e1cf0db8239e8a19))

## [1.3.2](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/compare/v1.3.1...v1.3.2) (2024-03-28)


### Bug Fixes

* **windows:** use 'w' instead of 'w+' to write queries files ([eb8bebf](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/eb8bebf3109fe61ebb30e7e1716b0f7081098823))

## [1.3.1](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/compare/v1.3.0...v1.3.1) (2024-03-28)


### Bug Fixes

* prevent installation of luafilesystem scm as dependency ([712e653](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/712e653f61de7cfaa77d19c13f7966c3ae01561b))

## [1.3.0](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/compare/v1.2.0...v1.3.0) (2024-03-27)


### Features

* support query packages without parser sources ([48d334f](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/48d334fce9a92c2b50c946fc32d23ad5d6800f3c))

## [1.2.0](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/compare/v1.1.1...v1.2.0) (2024-03-24)


### Features

* **build:** basic cpp support (add -lstdc++ if cpp sources set) ([7470cf7](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/7470cf767069aa38246cc5fa9030815986924470))

## [1.1.1](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/compare/v1.1.0...v1.1.1) (2024-03-17)


### Bug Fixes

* add luafilestem dependency to luarocks-tag-release ([b93b3d5](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/b93b3d51f2acefe6f12853c4c321df6f93a6699b))

## [1.1.0](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/compare/v1.0.1...v1.1.0) (2024-03-17)


### Features

* `build.queries` for passing in embedded query files ([39b7998](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/39b7998d51c2bc9356a21bd078ded16ac330483c))

## [1.0.1](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/compare/v1.0.0...v1.0.1) (2024-03-14)


### Bug Fixes

* name build type `treesitter-parser` by default ([28777b6](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/28777b60c1eb7782b6b2869037778abd81c27d9d))


### Reverts

* add luarocks-build-treesitter-parser to flake packages outputs ([9eeb147](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/9eeb147303089a42e1d9174f3ecfe7d39dffcbf0))
* provide package as overlay ([42bd0bc](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/42bd0bcd904452755294745312dcdf95650e79f3))

## 1.0.0 (2024-03-11)


### Features

* draft implementation ([20ba478](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/commit/20ba47851715e679079296e211a816b30ec0de89))
