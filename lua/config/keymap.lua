local M = {}
M.setup = function()
    -- buffer
    vim.keymap.set("n", "<C-s>", "<Cmd>w<CR>", {})
    vim.keymap.set("n", "E", "<Cmd>e<CR>", {})
    vim.keymap.set("n", "<C-t>", "<Cmd>enew<CR>", {})
    -- 编辑
    vim.keymap.set("i", "<C-v>", "<C-r>+", {})
    vim.keymap.set("c", "<C-v>", "<C-r>+", {})
    vim.keymap.set("i", "<C-c>", "<ESC>yy", {})
    vim.keymap.set("i", "<C-a>", "<ESC>gg0vG$", {})
    vim.keymap.set("n", "<leader>a", "<ESC>gg0vG$", {})
    vim.keymap.set("i", "<Tab>", "<S-Tab>", {})
    -- vim.keymap.set("n", "H", "0", {})
    -- vim.keymap.set("n", "L", "$", {})
    -- vim.keymap.set("v", "H", "0", {})
    -- vim.keymap.set("v", "L", "$", {})
    -- 标签页操作
    vim.keymap.set("n", "H", "<Cmd>bp<CR>", {})
    vim.keymap.set("n", "L", "<Cmd>bn<CR>", {})
    vim.keymap.set("n", "<A-[>", "<Cmd>cp<CR>", {})
    vim.keymap.set("n", "<A-]>", "<Cmd>cn<CR>", {})
    vim.keymap.set("n", "[l", "<Cmd>colder<CR>", {})
    vim.keymap.set("n", "]l", "<Cmd>cnewer<CR>", {})
    vim.keymap.set("n", "<A-w>", "<Cmd>bd<CR>", {}) -- for mouse
    vim.keymap.set("n", "<C-F4>", "<Cmd>bd<CR>", {}) -- for mouse
    -- ctrl-Q进入block模式
    vim.keymap.set("n", "<C-q>", "<C-v>", {})

    -- terminal
    vim.keymap.set("n", "<C-j>", "<Cmd>lua Utils.terminal()<CR>", {})
    -- terminal下使用esc退出到普通模式
    vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", {})
    -- terminal下模拟Ctrl-R
    vim.cmd("tnoremap <expr> <C-R> '<C-\\><C-N>\"'.nr2char(getchar()).'pi'")

    -- 格式化
    -- vim.keymap.set("n", "<space><space>f", "<Cmd>lua Format()<CR>", {})
    -- 自动换行
    vim.keymap.set("n", "<A-z>", "<Cmd>lua Utils.extra.autowrap()<CR>", {})

    -- 复制当前路径
    vim.keymap.set("n", "<Leader>GY",
        "<Cmd>lua local path = Utils.root.bufpath();vim.fn.setreg('+', path);print(path);<CR>", {})
    vim.keymap.set("n", "<Leader>Y", "<Cmd>lua local path = Utils.root.cwd();vim.fn.setreg('+', path);print(path);<CR>",
        {})
    vim.keymap.set("n", "<Leader>gy",
        "<Cmd>lua local path = Utils.root.bufrelpath();vim.fn.setreg('+', path);print(path);<CR>", {})

    -- 清除搜索高亮
    vim.keymap.set("n", "<ESC>", "<Cmd>noh<CR>", {})
    -- 切换window
    vim.keymap.set("n", "<A-j>", "<C-w>j", {})
    vim.keymap.set("n", "<A-k>", "<C-w>k", {})
    vim.keymap.set("n", "<A-h>", "<C-w>h", {})
    vim.keymap.set("n", "<A-l>", "<C-w>l", {})
    -- 调整window大小
    vim.keymap.set("n", "<A-9>", "<C-w><", {})
    vim.keymap.set("n", "<A-0>", "<C-w>>", {})
    vim.keymap.set("n", "<A-=>", "<C-w>+", {})
    vim.keymap.set("n", "<A-->", "<C-w>-", {})

end
return M
