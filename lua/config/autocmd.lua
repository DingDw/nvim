local M = {}
M.setup = function()
    -- Highlight when yanking (copying) text
    vim.api.nvim_create_autocmd('TextYankPost', {
        desc = 'Highlight when yanking (copying) text',
        group = vim.api.nvim_create_augroup('kickstart-highlight-yank', {
            clear = true
        }),
        callback = function()
            vim.highlight.on_yank()
        end
    })

    -- 修改c++的默认comment
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("FixCppCommentString", { clear = true }),
        callback = function(ev)
          vim.bo[ev.buf].commentstring = "// %s"
        end,
        pattern = { "hpp", "cc", "cpp", "h", "c" },
      })

    -- bigfile Snacks提供该功能,不需要自行配置
    -- vim.filetype.add({
    --     pattern = {
    --       [".*"] = {
    --         function(path, buf)
    --           return vim.bo[buf]
    --               and vim.bo[buf].filetype ~= "bigfile"
    --               and path
    --               and vim.fn.getfsize(path) > 1.5 * 1024 * 1024 -- 1.5M
    --               and "bigfile"
    --             or nil
    --         end,
    --       },
    --     },
    --   })
    --   vim.api.nvim_create_autocmd({ "FileType" }, {
    --     pattern = "bigfile",
    --     callback = function(ev)
    --       vim.b.minianimate_disable = true
    --       vim.schedule(function()
    --         vim.bo[ev.buf].syntax = vim.filetype.match({ buf = ev.buf }) or ""
    --       end)
    --     end,
    --   })

end
return M
