---@diagnostic disable: inject-field
local fs = require("luarocks.fs")
local dir = require("luarocks.dir")
local path = require("luarocks.path")
local builtin = require("luarocks.build.builtin")
local util = require("luarocks.util")
local cfg = require("luarocks.core.cfg")

local treesitter_parser = {}

---@class RockSpec
---@field name string
---@field version string
---@field build BuildSpec
---@field variables table

---@class BuildSpec
---@field type string

---@class TreeSitterRockSpec: RockSpec
---@field type fun():string
---@field build TreeSitterBuildSpec

---@class TreeSitterBuildSpec: BuildSpec
---@field lang string
---@field sources? string[]
---@field parser? boolean
---@field libflags? string[]
---@field generate? boolean
---@field generate_from_json? boolean
---@field location? string
---@field queries? table<string, string>

--- Run a command displaying its execution on standard output.
-- @return boolean: true if command succeeds (status code 0), false
-- otherwise.
local function execute(...)
	io.stdout:write(table.concat({ ... }, " ") .. "\n")
	return fs.execute(...)
end

---@param rockspec table
---@param no_install boolean
function treesitter_parser.run(rockspec, no_install)
	assert(rockspec:type() == "rockspec")
	---@cast rockspec RockSpec
	assert(rockspec.build.type == "treesitter-parser" or rockspec.build.type == "tree-sitter")
	---@cast rockspec TreeSitterRockSpec

	local build = rockspec.build

	local build_parser = build.parser == nil or build.parser
	local has_sources = type(build.sources) == "table" and #build.sources > 0

	if (build.generate or not has_sources) and not fs.is_tool_available("tree-sitter", "tree-sitter CLI") then
		return nil,
			"'tree-sitter CLI' is not installed.\n" .. rockspec.name .. " requires the tree-sitter CLI to build.\n"
	end
	if build.generate then
		local js_runtime = os.getenv("TREE_SITTER_JS_RUNTIME") or "node"
		local js_runtime_name = js_runtime == "node" and "Node JS" or js_runtime
		if not fs.is_tool_available(js_runtime, js_runtime_name) then
			return nil,
				("'%s' is not installed.\n%s requires %s to build."):format(js_runtime, rockspec.name, js_runtime_name)
		end
	end
	if build.location then
		util.printout("Changing to directory: " .. build.location)
		fs.change_dir(build.location)
	end
	if build.generate then
		local cmd
		cmd = { "tree-sitter", "generate", "--no-bindings" }
		local abi = os.getenv("TREE_SITTER_LANGUAGE_VERSION")
		-- TODO: Check for tree-sitter CLI version
		if abi then
			table.insert(cmd, "--abi")
			table.insert(cmd, abi)
		end
		if build.generate_from_json then
			table.insert(cmd, "src/grammar.json")
		end
		util.printout("Generating tree-sitter sources...")
		local cmd_str = table.concat(cmd, " ")
		util.printout(cmd_str)
		if not fs.execute(cmd_str) then
			return nil, "Failed to generate tree-sitter grammar."
		end
		util.printout("Done.")
	end
	local incdirs, is_cpp = {}, false
	for _, source in ipairs(build.sources or {}) do
		local source_dir = source:match("(.-)%/")
		is_cpp = is_cpp
			or source:match("%.cc$") ~= nil
			or source:match("%.cpp$") ~= nil
			or source:match("%.cxx$") ~= nil
		if dir then
			table.insert(incdirs, source_dir)
		end
	end
	if is_cpp and not rockspec.build.libflags then
		local prev = rockspec.variables.LIBFLAG
		rockspec.variables.LIBFLAG = prev .. (prev and #prev > 1 and " " or "") .. "-lstdc++"
	end
	if rockspec.build.libflags then
		rockspec.variables.LIBFLAG = table.concat(rockspec.build.libflags, " ")
	end
	if build.queries then
		if fs.is_dir("queries") then
			pcall(fs.delete, "queries")
		end
		fs.make_dir("queries")
		if not fs.exists("queries") then
			return nil, "Could not create directory: queries"
		end
		local queries_dir = dir.path("queries", build.lang)
		fs.make_dir(queries_dir)
		if not fs.exists(queries_dir) then
			return nil, "Could not create directory: " .. queries_dir
		end
		for name, content in pairs(build.queries) do
			local queries_file = fs.absolute_name(dir.path(queries_dir, name))
			local fd = io.open(queries_file, "w+")
			if not fd then
				return nil, "Could not open " .. queries_file .. " for writing"
			end
			fd:write(content)
			fd:close()
		end
		rockspec.build.copy_directories = rockspec.build.copy_directories or {}
		table.insert(rockspec.build.copy_directories, "queries")
	end
	if has_sources then
		rockspec.build.modules = {
			["parser." .. build.lang] = {
				sources = build.sources,
				incdirs = incdirs,
			},
		}
	end
	local lib_dir = path.lib_dir(rockspec.name, rockspec.version)
	local parser_dir = dir.path(lib_dir, "parser")
	local ok, err
	if build_parser then
		if fs.is_tool_available("tree-sitter", "tree-sitter CLI") then
			-- Try tree-sitter build first
			fs.make_dir(parser_dir)
			local parser_lib = dir.path(parser_dir, rockspec.build.lang .. "." .. cfg.lib_extension)
			ok = execute("tree-sitter", "build", "-o", parser_lib, ".") and fs.exists(parser_lib)
		end
		if not ok and has_sources then
			-- Fall back to builtin build
			ok, err = builtin.run(rockspec, no_install)
		elseif not ok then
			err = "'tree-sitter build' failed. Note: tree-sitter 0.22.2 or later is required to build this parser."
		end
	else
		ok = true
	end
	if ok and fs.exists(parser_dir) then
		-- For neovim plugin managers that do not symlink parser_dir to the rtp
		local dest = dir.path(path.install_dir(rockspec.name, rockspec.version), "parser")
		fs.make_dir(dest)
		ok, err = fs.copy_contents(parser_dir, dest)
	end
	return ok, err
end

return treesitter_parser
