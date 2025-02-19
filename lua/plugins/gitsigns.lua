return {{
    "lewis6991/gitsigns.nvim",
    opts = {
        signs = {
            add = {
                text = '+'
            },
            change = {
                text = '~'
            },
            delete = {
                text = '_'
            },
            topdelete = {
                text = '‾'
            },
            changedelete = {
                text = '~'
            }
        },
        current_line_blame = true,
        on_attach = function(buffer)
            local gs = package.loaded.gitsigns
            vim.keymap.set("n", "]h", function()
                gs.nav_hunk("next")
            end, {
                buffer = buffer,
                desc = "Next Hunk"
            })
            vim.keymap.set("n", "[h", function()
                gs.nav_hunk("prev")
            end, {
                buffer = buffer,
                desc = "Prev Hunk"
            })
            vim.keymap.set("n", "]H", function()
                gs.nav_hunk("last")
            end, {
                buffer = buffer,
                desc = "Last Hunk"
            })
            vim.keymap.set("n", "[H", function()
                gs.nav_hunk("first")
            end, {
                buffer = buffer,
                desc = "First Hunk"
            })
        end
    }
}}
