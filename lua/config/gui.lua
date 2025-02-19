return {
    setup = function()
        -- 设置字体
        -- vim.o.guifont = "VictorMono Nerd Font,等距更纱黑体 SC Nerd Font:h12"
        -- vim.o.guifont = "ZedMono Nerd Font,等距更纱黑体 SC Nerd Font:h12"
        -- vim.o.guifont = "GoMono Nerd Font,等距更纱黑体 SC Nerd Font:h12"
        -- vim.o.guifont = "FiraCode Nerd Font,等距更纱黑体 SC Nerd Font:h11"
        vim.o.guifont = "Sarasa Term SC Nerd Font:h12"
        -- vim.o.guifont = "Sarasa Term Slab SC Nerd Font:h11"
        -- vim.o.guifont = "CaskaydiaCove Nerd Font,等距更纱黑体 SC Nerd Font:h11"
        -- vim.o.guifont="Maple Mono SC NF,等距更纱黑体 SC Nerd Font:h11"
        -- vim.o.guifont="FantasqueSansM Nerd Font,等距更纱黑体 SC Nerd Font:h13"
        -- vim.o.guifont = "0xProto Nerd Font,等距更纱黑体 SC Nerd Font:h11"
        -- 透明度
        vim.g.neovide_transparency = 1
        -- 记忆上次窗口大小
        vim.g.neovide_remember_window_size = true
        -- 动画时间
        vim.g.neovide_cursor_animation_length = 0
        -- 拖尾长度
        vim.g.neovide_cursor_trail_length = 0
        -- 退出确认
        vim.g.neovide_confirm_quit = true
        -- floating window radius
        vim.g.neovide_floating_corner_radius = 10.0

        -- autocmd 只有Insert模式和Cmdline模式才启动输入法，其他情况禁用输入法
        vim.g.neovide_input_ime = false
        local function set_ime(args)
            if args.event:match("Enter$") then
                vim.g.neovide_input_ime = true
            else
                vim.g.neovide_input_ime = false
            end
        end

        local ime_input = vim.api.nvim_create_augroup("ime_input", {
            clear = true
        })

        vim.api.nvim_create_autocmd({"InsertEnter", "InsertLeave"}, {
            group = ime_input,
            pattern = "*",
            callback = set_ime
        })

        vim.api.nvim_create_autocmd({"CmdlineEnter", "CmdlineLeave"}, {
            group = ime_input,
            -- pattern = "[/,\\?]",
            pattern = "*",
            callback = set_ime
        })

        vim.api.nvim_create_autocmd({"TermEnter"}, {
            group = ime_input,
            -- pattern = "[/,\\?]",
            pattern = "*",
            callback = set_ime
        })
    end
}
