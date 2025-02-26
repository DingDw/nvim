local M = {}

-- 优先取lazy.nvim中的工具方法,取不到的取utils.xxx中的方法
setmetatable(M, {
	__index = function(t, k)
		if require("lazy.core.util")[k] then
			return require("lazy.core.util")[k]
		end
		---@diagnostic disable-next-line: no-unknown
		t[k] = require("utils." .. k)
		return t[k]
	end,
})

--- Override the default title for notifications.
for _, level in ipairs({ "info", "warn", "error" }) do
	M[level] = function(msg, opts)
		opts = opts or {}
		opts.title = opts.title or level:upper()
		return require("lazy.core.util")[level](msg, opts)
	end
end

M.is_win = function()
	return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

-- 通过lazy.nvim获取插件相关信息
function M.get_plugin(name)
	return require("lazy.core.config").spec.plugins[name]
end

function M.get_plugin_path(name, path)
	local plugin = M.get_plugin(name)
	path = path and "/" .. path or ""
	return plugin and (plugin.dir .. path)
end

function M.has(plugin)
	return M.get_plugin(plugin) ~= nil
end

function M.opts(name)
	local plugin = M.get_plugin(name)
	if not plugin then
		return {}
	end
	local Plugin = require("lazy.core.plugin")
	return Plugin.values(plugin, "opts", false)
end

function M.is_loaded(name)
	local Config = require("lazy.core.config")
	return Config.plugins[name] and Config.plugins[name]._.loaded
end


return {
	setup = function()
		_G.Utils = M
	end
}