return {
    setup = function()
        vim.api.nvim_create_user_command("W", Utils.extra.save, {
            nargs = 1
        })
        vim.api.nvim_create_user_command("E", Utils.extra.open, {
            nargs = 1
        })
        vim.api.nvim_create_user_command("WZ", Utils.extra.open_wezterm, {})
        vim.api.nvim_create_user_command("GIT", Utils.extra.open_lazygit, {})
        vim.api.nvim_create_user_command("Quit", Utils.extra.quit, {})
        vim.api.nvim_create_user_command("MacbsSearch", Utils.extra.macbs_search, {})
        -- 转Camelcase
        vim.api.nvim_create_user_command("CamelCase", "'<,'>s/_\\(\\w\\)/\\u\\1/g", {
            range = true
        })
        -- 转SnakeCase
        vim.api.nvim_create_user_command("SnakeCase", "'<,'>s/\\([A-Z]\\)/_\\l\\1/g", {
            range = true
        })
        -- cmake
        vim.api.nvim_create_user_command("CMakeConfigure", Utils.cmake.configure, {
            nargs = 1
        })
        -- project
        vim.api.nvim_create_user_command("ProjectSave", Utils.project.export_func, {
            nargs = 1
        })
        vim.api.nvim_create_user_command("ProjectDelete", Utils.project.export_func, {
            nargs = 1
        })
    end
}
