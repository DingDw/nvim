local M = {}
-- 实现按位与操作的函数
M.band = function(a, b)
	local result = 0
	local bitval = 1
	while a > 0 and b > 0 do
		local abit = a % 2
		local bbit = b % 2
		if abit == 1 and bbit == 1 then
			result = result + bitval
		end
		bitval = bitval * 2
		a = math.floor(a / 2)
		b = math.floor(b / 2)
	end
	return result
end

-- 字符串拆分
M.strsplit = function(str, sep)
	local result = {}
	local pattern = "(.-)" .. sep
	local last_end = 1
	local s, e, cap = str:find(pattern, 1)
	while s do
		table.insert(result, cap)
		last_end = e + 1
		s, e, cap = str:find(pattern, last_end)
	end
	table.insert(result, str:sub(last_end))
	return result
end

-- 判断是否为中文
M.is_chinese = function(char, encode)
	if encode == "utf-8" then
		return M.band(char:byte(), 0xF0) == 0xE0
	else
		return char:byte() >= 0x81 and char:byte() <= 0xFE
	end
end

-- 获取字符串字符数
M.strlength = function(str, ch_char_num)
	local len = 0
	local i = 1
	while i <= #str do
		local char = str:sub(i, i)
		if M.is_chinese(char, "utf-8") then
			i = i + 3
			len = len + ch_char_num
		else
			i = i + 1
			len = len + 1
		end
	end
	return len
end

M.check_buffer_is_terminal = function()
	return string.sub(vim.api.nvim_buf_get_name(0), 1, 7) == "term://"
end

-- 关闭buffer
M.close_buffer = function()
	if M.check_buffer_is_terminal() then
		vim.cmd("close")
		return
	else
		vim.cmd("bd")
	end
end

function M.autowrap()
	if vim.o.wrap then
		vim.cmd("set nowrap")
	else
		vim.cmd("set wrap")
	end
end

-- 保存到默认位置
M.save = function(opts)
	local filename = opts.args
	if Utils.is_win() then
		vim.cmd("w " .. vim.fn.glob("~") .. "\\Desktop\\TEMP\\" .. filename)
	else
		vim.cmd("w " .. vim.fn.glob("~") .. "/temp/" .. filename)
	end
end

-- 打开默认位置的文件
M.open = function(opts)
	local filename = opts.args
	if Utils.is_win() then
		vim.cmd("e " .. vim.fn.glob("~") .. "\\Desktop\\TEMP\\" .. filename)
	else
		vim.cmd("e " .. vim.fn.glob("~") .. "/temp/" .. filename)
	end
end

-- 退出
M.quit = function()
	local changed_buffer = {}
	for _, buffer in ipairs(vim.fn.getbufinfo()) do
		if buffer["changed"] == 1 then
			table.insert(changed_buffer, buffer)
		end
	end
	-- 都保存直接退出
	if #changed_buffer == 0 then
		vim.cmd("q")
	end

	while #changed_buffer > 0 do
		local buffer = changed_buffer[1]
		local name = vim.fn.bufname(buffer["bufnr"])
		local untitled = false

		if name == "" then
			name = "Untitled"
			untitled = true
		end
		local message = "\nSave changes to " .. name .. "?\n"
		if #changed_buffer > 1 then
			message = message .. "[Y]es, [N]o, [A]ll, [D]iscardAll, [C]ancel:"
		else
			message = message .. "[Y]es, [N]o, [C]ancel:"
		end
		local action = string.upper(vim.fn.input(message))
		-- 保存
		if action == "Y" then
			vim.cmd("b" .. buffer["bufnr"])
			if untitled then
				break
			else
				vim.cmd("w")
				vim.cmd("bd")
				table.remove(changed_buffer, 1)
			end
			-- 不保存
		elseif action == "N" then
			vim.cmd("b" .. buffer["bufnr"])
			vim.cmd("bd!")
			table.remove(changed_buffer, 1)
			-- 全部保存
		elseif action == "A" then
			local first_untitled = nil
			for _, tmp in ipairs(changed_buffer) do
				if tmp["name"] == "" then
					first_untitled = tmp
					break
				end
			end
			if first_untitled == nil then
				vim.cmd("wa")
				vim.cmd("q")
			else
				vim.cmd("b" .. first_untitled["bufnr"])
				break
			end
			-- 全部不保存
		elseif action == "D" then
			vim.cmd("qa!")
			-- 其他
		else
			break
		end
	end
	if #changed_buffer == 0 then
		vim.cmd("q")
	end
end

-- 判断文件是否存在
-- M.file_exists = function(file)
--     local f = io.open(file, "r")
--     if f then
--         io.close(f)
--         return true
--     else
--         return false
--     end
-- end

-- M.is_empty = function(s)
--     return s == nil or s == ""
-- end

-- M.get_buf_option = function(opt)
--     local status_ok, buf_option = pcall(vim.api.nvim_get_option_value, opt)
--     if not status_ok then
--         return nil
--     else
--         return buf_option
--     end
-- end

-- M.join_paths = function(...)
--     local result = table.concat({ ... }, Utils.is_win() and '\\' or '/')
--     return result
-- end
--
-- local uv = vim.loop
-- --- Checks whether a given path exists and is a file.
-- --@param path (string) path to check
-- --@returns (bool)
-- M.is_file = function(path)
--     local stat = uv.fs_stat(path)
--     return stat and stat.type == "file" or false
-- end
--
-- --- Checks whether a given path exists and is a directory
-- --@param path (string) path to check
-- --@returns (bool)
-- M.is_directory = function(path)
--     local stat = uv.fs_stat(path)
--     return stat and stat.type == "directory" or false
-- end
--
-- ---Write data to a file
-- ---@param path string can be full or relative to `cwd`
-- ---@param txt string|table text to be written, uses `vim.inspect` internally for tables
-- ---@param flag string used to determine access mode, common flags: "w" for `overwrite` or "a" for `append`
-- M.write_file = function(path, txt, flag)
--     local data = type(txt) == "string" and txt or vim.inspect(txt)
--     uv.fs_open(path, flag, 438, function(open_err, fd)
--         assert(not open_err, open_err)
--         uv.fs_write(fd, data, -1, function(write_err)
--             assert(not write_err, write_err)
--             uv.fs_close(fd, function(close_err)
--                 assert(not close_err, close_err)
--             end)
--         end)
--     end)
-- end
--
-- ---Copies a file or directory recursively
-- ---@param source string
-- ---@param destination string
-- M.fs_copy = function(source, destination)
--     local source_stats = assert(vim.loop.fs_stat(source))
--
--     if source_stats.type == "file" then
--         assert(vim.loop.fs_copyfile(source, destination))
--         return
--     elseif source_stats.type == "directory" then
--         local handle = assert(vim.loop.fs_scandir(source))
--
--         assert(vim.loop.fs_mkdir(destination, source_stats.mode))
--
--         while true do
--             local name = vim.loop.fs_scandir_next(handle)
--             if not name then
--                 break
--             end
--
--             M.fs_copy(M.join_paths(source, name), M.join_paths(destination, name))
--         end
--     end
-- end
--
M.default_on_exit = function(obj)
	Utils.info(
		string.format(
			"exited:code:[%d],signal:[%d],stdout:[%s],stderr:[%s]",
			obj.code,
			obj.signal,
			obj.stdout,
			obj.stderr
		)
	)
end

M.open_wezterm = function()
	-- Runs asynchronously:
	vim.system({ "wezterm", "start", "--cwd", vim.fn.getcwd() }, { text = true }, M.default_on_exit)

	-- Runs synchronously:
	-- local obj = vim.system({'echo', 'hello'}, { text = true }):wait()
end

M.open_lazygit = function()
	vim.system({ "wezterm", "start", "--cwd", vim.fn.getcwd(), "--", "lazygit" }, { text = true }, M.default_on_exit)
end

-- csv对齐
M.csv_align = function(sep)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
	if #lines == 0 then
		print("csv file is empty!!!")
		return
	end
	local new_lines = {}
	local col_len = {}
	for _, line in ipairs(lines) do
		for col, value in ipairs(M.strsplit(line, sep)) do
			local len = M.strlength(value, 2)
			if col_len[col] == nil or col_len[col] < len then
				col_len[col] = len
			end
		end
	end
	for _, line in ipairs(lines) do
		local new_line = ""
		for col, value in ipairs(M.strsplit(line, sep)) do
			local len = M.strlength(value, 2)
			if len < col_len[col] then
				for _ = len + 1, col_len[col] do
					value = value .. " "
				end
			end
			if col == 1 then
				new_line = value
			else
				new_line = new_line .. "|" .. value
			end
		end
		table.insert(new_lines, new_line)
	end
	vim.api.nvim_buf_set_lines(0, 0, -1, true, new_lines)
	vim.api.nvim_set_option_value("wrap", false, {})
end

-- TEMPORARY FUNCTION
M.macbs_search = function()
	require("telescope.builtin").live_grep({
		search_dirs = { "./" },
		glob_pattern = {
			"!tables/**",
			"!tables_memdb_mgr/**",
			"!macbs_shared/**",
			"!out/**",
			"!compile*",
			"!*factory.h",
			"!jstp_database_manager.h",
		},
		additional_args = function()
			return {
				"--no-ignore",
			}
		end,
	})
end

M.macbs_trans_doc_to_if_column = function(intfid, fileid)
	-- 获取当前选中的start和end line
	local start_line = vim.api.nvim_buf_get_mark(0, "<")[1] - 1
	local end_line = vim.api.nvim_buf_get_mark(0, ">")[1] - 1
	local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line + 1, false)
	print(vim.inspect(lines))
	local new_lines = {}
	for num, line in ipairs(lines) do
		line = line:gsub("%s+", "\t")
		local split = line:find("\t")
		if split == nil then
			break
		end
		local fieldname = line:sub(0, split - 1)
		local fieldtype = line:sub(split + 1)
		local size = 0
		local declen = 0
		if fieldtype == "int" then
			fieldtype = "I"
			size = 10
		elseif fieldtype == "int64" then
			fieldtype = "L"
			size = 64
		elseif fieldtype:find("numeric") ~= nil then
			size = tonumber(fieldtype:sub(9, fieldtype:find(",") - 1), 10)
			declen = tonumber(fieldtype:sub(fieldtype:find(",") + 1, #fieldtype - 1), 10)
			fieldtype = "F"
		else
			size = tonumber(fieldtype:sub(fieldtype:find("(", nil, true) + 1, #fieldtype - 1), 10)
			fieldtype = "C"
		end
		table.insert(
			new_lines,
			string.format(
				"    ('%s','%s',%d,'%s','%s','%s',%d,%d,'0','0',NULL,NULL,NULL,NULL),",
				intfid,
				fileid,
				num,
				fieldname,
				fieldname,
				fieldtype,
				size,
				declen
			)
		)
	end
	print(vim.inspect(new_lines))
	vim.api.nvim_buf_set_lines(0, start_line, end_line + 1, false, new_lines)
end

return M
