return {
    {
        'jedrzejboczar/possession.nvim',
        -- event = {"VeryLazy"},
        cmd = {"SSave", "SList", "SShow", "SLoad"},
        dependencies = {'nvim-lua/plenary.nvim'},
        opts = {
            session_dir = (require("plenary.path"):new(vim.fn.stdpath('data')) / 'possession'):absolute(),
            silent = false,
            load_silent = true,
            debug = false,
            logfile = false,
            prompt_no_cr = false,
            autosave = {
                current = true, -- or fun(name): boolean
                cwd = false, -- or fun(): boolean
                tmp = false, -- or fun(): boolean
                tmp_name = 'tmp', -- or fun(): string
                on_load = true,
                on_quit = true
            },
            autoload = false, -- or 'last' or 'auto_cwd' or 'last_cwd' or fun(): string
            commands = {
                save = 'SSave',
                load = 'SLoad',
                save_cwd = 'SSaveCwd',
                load_cwd = 'SLoadCwd',
                rename = 'SRename',
                close = 'SClose',
                delete = 'SDelete',
                show = 'SShow',
                list = 'SList',
                list_cwd = 'SListCwd',
                migrate = 'SMigrate'
            },
            hooks = {
                before_save = function(name)
                    return {}
                end,
                after_save = function(name, user_data, aborted)
                end,
                before_load = function(name, user_data)
                    return user_data
                end,
                after_load = function(name, user_data)
                end
            },
            plugins = {
                close_windows = {
                    hooks = {'before_save', 'before_load'},
                    preserve_layout = true, -- or fun(win): boolean
                    match = {
                        floating = true,
                        buftype = {},
                        filetype = {},
                        custom = false -- or fun(win): boolean
                    }
                },
                delete_hidden_buffers = false,
                -- delete_hidden_buffers = {
                --     hooks = {'before_load', vim.o.sessionoptions:match('buffer') and 'before_save'},
                --     force = false -- or fun(buf): boolean
                -- },
                nvim_tree = false,
                neo_tree = false,
                symbols_outline = false,
                outline = false,
                tabby = false,
                dap = false,
                dapui = false,
                neotest = false,
                delete_buffers = false,
                stop_lsp_clients = true,
            }
        }
    }
}