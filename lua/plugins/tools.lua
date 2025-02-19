return {{
    "nvim-lua/plenary.nvim",
    lazy = true
}, {'MunifTanjim/nui.nvim'}, {
    "junegunn/fzf",
    build = function()
        vim.fn["fzf#install"]()
    end,
    lazy = true
},{'echasnovski/mini.icons'}}
