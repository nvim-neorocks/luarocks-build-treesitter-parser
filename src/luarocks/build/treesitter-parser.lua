---@diagnostic disable: inject-field
local fs = require("luarocks.fs")
local dir = require("luarocks.dir")
local path = require("luarocks.path")
local builtin = require("luarocks.build.builtin")
local util = require("luarocks.util")

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
---@field sources string[]
---@field generate_requires_npm? boolean
---@field generate_from_grammar? boolean
---@field location? string
---@field queries? table<string, string>

---@param rockspec table
---@param no_install boolean
function treesitter_parser.run(rockspec, no_install)
	assert(rockspec:type() == "rockspec")
	---@cast rockspec RockSpec
	assert(rockspec.build.type == "treesitter-parser" or rockspec.build.type == "tree-sitter")
	---@cast rockspec TreeSitterRockSpec

	local build = rockspec.build

	if build.generate_requires_npm and not fs.is_tool_available("npm", "npm") then
		return nil, "'npm' is not installed.\n" .. rockspec.name .. " requires npm to build.\n"
	end
	if build.generate_from_grammar and not fs.is_tool_available("tree-sitter", "tree-sitter CLI") then
		return nil,
			"'tree-sitter CLI' is not installed.\n" .. rockspec.name .. " requires the tree-sitter CLI to build.\n"
	end
	if build.generate_from_grammar then
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
	if build.generate_from_grammar then
		local cmd
		if build.generate_requires_npm then
			cmd = { "npm", "install" }
			util.printout("Installing npm dependencies...")
			if not fs.execute(table.concat(cmd, " ")) then
				return nil, "Failed to install npm dependencies."
			end
			util.printout("Done.")
		end
		cmd = { "tree-sitter", "generate" }
		local abi = os.getenv("TREE_SITTER_LANGUAGE_VERSION")
		-- TODO: Check for tree-sitter CLI version
		if abi then
			table.insert(cmd, "--abi")
			table.insert(cmd, abi)
		end
		util.printout("Generating tree-sitter sources...")
		if not fs.execute(table.concat(cmd, " ")) then
			return nil, "Failed to generate tree-sitter grammar."
		end
		util.printout("Done.")
	end
	local incdirs, is_cpp = {}, false
	for _, source in ipairs(build.sources) do
		local source_dir = source:match("(.-)%/")
		is_cpp = is_cpp
			or source:match("%.cc$") ~= nil
			or source:match("%.cpp$") ~= nil
			or source:match("%.cxx$") ~= nil
		if dir then
			table.insert(incdirs, source_dir)
		end
	end
	if is_cpp then
		local prev = rockspec.variables.LIBFLAG
		rockspec.variables.LIBFLAG = prev .. (prev and #prev > 1 and " " or "") .. "-lstdc++"
	end
	if build.queries then
		if fs.is_dir("queries") then
			pcall(fs.delete, "queries")
		end
		fs.make_dir("queries")
		local queries_dir = dir.path("queries", build.lang)
		fs.make_dir(queries_dir)
		for name, content in pairs(build.queries) do
			local queries_file = dir.path(queries_dir, name)
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
	if type(build.sources) == "table" and #build.sources > 0 then
		rockspec.build.modules = {
			["parser." .. build.lang] = {
				sources = build.sources,
				incdirs = incdirs,
			},
		}
	end
	local lib_dir = path.lib_dir(rockspec.name, rockspec.version)
	local parser_dir = dir.path(lib_dir, "parser")
	local ok, err = builtin.run(rockspec, no_install)
	if ok then
		-- For neovim plugin managers that do not symlink parser_dir to the rtp
		local dest = dir.path(path.install_dir(rockspec.name, rockspec.version), "parser")
		fs.make_dir(dest)
		ok, err = fs.copy_contents(parser_dir, dest)
	end
	return ok, err
end

return treesitter_parser
