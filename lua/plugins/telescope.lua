return {{ -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    enabled = vim.g.telescope_enabled,
    event = 'VimEnter',
    version = false,
    dependencies = {{'nvim-lua/plenary.nvim'},
                    { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        -- cond = function()
        --   return vim.fn.executable 'make' == 1
        -- end,
    }, {'nvim-telescope/telescope-ui-select.nvim'}, {'echasnovski/mini.icons'}},
    keys = {{
        "<leader>t",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
        desc = "Switch Buffer"
    }, {
        "<leader>/",
        "<cmd>Telescope live_grep<cr>",
        desc = "Grep (Root Dir)"
    }, {
        "<leader>:",
        "<cmd>Telescope command_history<cr>",
        desc = "Command History"
    }, {
        "<leader><space>",
        "<cmd>Telescope find_files<cr>",
        desc = "Find Files (Root Dir)"
    }, -- search
    {
        "<leader>sb",
        "<cmd>Telescope current_buffer_fuzzy_find<cr>",
        desc = "Buffer"
    }, {
        "<leader>sk",
        "<cmd>Telescope keymaps<cr>",
        desc = "Key Maps"
    }, {
        "<leader>sM",
        "<cmd>Telescope man_pages<cr>",
        desc = "Man Pages"
    }, {
        "<leader>sm",
        "<cmd>Telescope marks<cr>",
        desc = "Jump to Mark"
    }, {
        "<leader>so",
        "<cmd>Telescope vim_options<cr>",
        desc = "Options"
    }, {
        "<leader>sR",
        "<cmd>Telescope resume<cr>",
        desc = "Resume"
    }, {
        "<leader>sq",
        "<cmd>Telescope quickfix<cr>",
        desc = "Quickfix List"
    }, {
        "<leader>/",
        "<cmd>Telescope grep_string<cr>",
        mode = "v",
        desc = "Selection (cwd)"
    }},
    config = function()
        local actions = require("telescope.actions")
        require('telescope').setup({
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                -- open files in the first window that is an actual file.
                -- use the current window if no other window is available.
                get_selection_window = function()
                    local wins = vim.api.nvim_list_wins()
                    table.insert(wins, 1, vim.api.nvim_get_current_win())
                    for _, win in ipairs(wins) do
                        local buf = vim.api.nvim_win_get_buf(win)
                        if vim.bo[buf].buftype == "" then
                            return win
                        end
                    end
                    return 0
                end,
                mappings = {
                    i = {
                        ["<C-Down>"] = actions.cycle_history_next,
                        ["<C-Up>"] = actions.cycle_history_prev,
                        ["<C-f>"] = actions.preview_scrolling_down,
                        ["<C-b>"] = actions.preview_scrolling_up
                    },
                    n = {
                        ["q"] = actions.close
                    }
                }
            },
            pickers = {
                find_files = {
                    find_command = {"rg", "--files", "--color", "never", "-g", "!.git"},
                    hidden = true
                }
            },
            extensions = {
                ['ui-select'] = {require('telescope.themes').get_dropdown()}
            }

        })

        -- Enable Telescope extensions if they are installed
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')
    end
}}
