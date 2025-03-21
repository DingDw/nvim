local M = {}
local MiniFiles = require("mini.files")
M.files = {}

M.files.fs_normalize_path = function(path)
	return (path:gsub("/+", "/"):gsub("(.)/$", "%1"))
end
if Utils.is_win() then
	M.files.fs_normalize_path = function(path)
		return (path:gsub("\\", "/"):gsub("/+", "/"):gsub("(.)[\\/]$", "%1"))
	end
end

M.files.fs_is_present_path = function(path)
	return vim.loop.fs_stat(path) ~= nil
end

M.files.fs_child_path = function(dir, name)
	return M.files.fs_normalize_path(string.format("%s/%s", dir, name))
end

M.files.fs_full_path = function(path)
	return M.files.fs_normalize_path(vim.fn.fnamemodify(path, ":p"))
end

M.files.fs_is_windows_top = function(path)
	return Utils.is_win() and path:find("^%w:[\\/]?$") ~= nil
end

M.files.fs_get_parent = function(path)
	path = M.files.fs_full_path(path)

	-- Deal with top root paths
	local is_top = M.files.fs_is_windows_top(path) or path == "/"
	if is_top then
		return nil
	end

	-- Compute parent
	local res = M.files.fs_normalize_path(path:match("^.*/"))
	-- - Deal with Windows top directory separately
	local suffix = M.files.fs_is_windows_top(res) and "/" or ""
	return res .. suffix
end

M.files.trans_branch = function(src)
    local temp = src
	if Utils.is_win() then
		temp = temp:sub(1, 1):lower() .. temp:sub(2)
	end
    return temp
end

M.files.reveal_cwd = function()
	local state = MiniFiles.get_explorer_state()
	if state == nil then
		return
	end
	local branch, depth_focus = state.branch, state.depth_focus
    local temp = M.files.trans_branch(branch[1])

	local cwd = M.files.trans_branch(M.files.fs_full_path(vim.fn.getcwd()))

	local cwd_ancestor_pattern = string.format("^%s/.", vim.pesc(cwd))
	while temp:find(cwd_ancestor_pattern) ~= nil do
		table.insert(branch, 1, M.files.fs_get_parent(branch[1]))
        temp = M.files.trans_branch(branch[1])
		depth_focus = depth_focus + 1
	end
	MiniFiles.set_branch(branch, { depth_focus = depth_focus })
end

return M
