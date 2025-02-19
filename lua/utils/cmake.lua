local M = {
	configure = function(opts)
        local preset_name = opts.args
		vim.cmd(
			string.format(
				'!cmd.exe /k """C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\Tools\\VsDevCmd.bat"" -arch=x64 -host_arch=x64 && cd ""%s"" && cmake --preset %s -DCMAKE_EXPORT_COMPILE_COMMANDS=1 . && copy /Y .\\out\\build\\%s\\compile_commands.json .\\compile_commands.json"',
				vim.uv.cwd(),
				preset_name,
				preset_name
			)
		)
	end,
}

return M
