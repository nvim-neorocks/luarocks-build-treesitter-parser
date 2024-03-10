---@diagnostic disable: inject-field
local fs = require("luarocks.fs")
local builtin = require("luarocks.build.builtin")

local tree_sitter = {}

---@class RockSpec
---@field package string
---@field build BuildSpec

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

---@param rockspec table
---@param no_install boolean
function tree_sitter.run(rockspec, no_install)
	assert(rockspec:type() == "rockspec")
	---@cast rockspec RockSpec
	assert(rockspec.build.type == "tree-sitter")
	---@cast rockspec TreeSitterRockSpec

	local build = rockspec.build

	if build.generate_requires_npm and not fs.is_tool_available("npm", "npm") then
		return nil, "'npm' is not installed.\n" .. rockspec.package .. " requires npm to build.\n"
	end
	if build.generate_from_grammar and not fs.is_tool_available("tree-sitter", "tree-sitter CLI") then
		return nil,
			"'tree-sitter CLI' is not installed.\n" .. rockspec.package .. " requires the tree-sitter CLI to build.\n"
	end
	if build.generate_from_grammar then
		local js_runtime = os.getenv("TREE_SITTER_JS_RUNTIME") or "node"
		local js_runtime_name = js_runtime == "node" and "Node JS" or js_runtime
		if not fs.is_tool_available(js_runtime, js_runtime_name) then
			return nil,
				("'%s' is not installed.\n%s requires %s to build."):format(
					js_runtime,
					rockspec.package,
					js_runtime_name
				)
		end
	end
	if build.location then
		fs.change_dir(rockspec.build)
	end
	if build.generate_from_grammar then
		local cmd
		if build.generate_requires_npm then
			cmd = { "npm", "install" }
			if not fs.execute(table.concat(cmd, " ")) then
				return nil, "Failed to install npm dependencies."
			end
		end
		cmd = { "tree-sitter", "generate" }
		local abi = os.getenv("TREE_SITTER_LANGUAGE_VERSION")
		-- TODO: Check for tree-sitter CLI version
		if abi then
			table.insert(cmd, "--abi")
			table.insert(cmd, abi)
		end
		if not fs.execute(table.concat(cmd, " ")) then
			return nil, "Failed to generate tree-sitter grammar."
		end
	end
	local incdirs = {}
	for _, source in ipairs(build.sources) do
		local dir = source:match("(.-)%/")
		if dir then
			table.insert(incdirs, dir)
		end
	end
	rockspec.build.modules = {
		["parser." .. build.lang] = {
			sources = build.sources,
			incdirs = incdirs,
		},
	}
	return builtin.run(rockspec, no_install)
end

return tree_sitter
