local M = {}

M.setup = function()
    -- utf8
    vim.opt.encoding = 'UTF-8'
    vim.opt.fileencodings = 'utf-8,gbk,gb2312,latin1'
    -- jk移动时光标下上方保留8行
    vim.opt.scrolloff = 8
    vim.opt.sidescrolloff = 8
    -- 使用相对行号
    vim.opt.number = true
    vim.opt.relativenumber = true
    -- 高亮所在行
    vim.opt.cursorline = true
    -- 显示左侧图标指示列
    vim.opt.signcolumn = 'yes'
    -- statuscolumn
    -- vim.opt.statuscolumn = '%#NonText#%{&nu?v:lnum:''}%=%{&rnu&&(v:lnum%2)?' '.v:relnum:''}%#LineNr#%{&rnu&&!(v:lnum%2)?' '.v:relnum:''}'
    -- vim.opt.statuscolumn = '%#LineNr#%{v:lnum} %=%#NonText#%{v:relnum} '
    vim.opt.statuscolumn = nil
    -- 右侧参考线，超过表示代码太长了，考虑换行
    -- vim.opt.colorcolumn = '80'
    -- 缩进4个空格等于一个Tab
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftround = true
    vim.opt.shiftwidth = 4
    -- 新行对齐当前行，空格替代tab
    vim.opt.expandtab = true
    vim.opt.autoindent = true
    vim.opt.smartindent = true
    -- 搜索大小写不敏感，除非包含大写
    vim.opt.ignorecase = true
    vim.opt.smartcase = true
    -- 搜索高亮
    vim.opt.hlsearch = true
    -- 边输入边搜索
    vim.opt.incsearch = true
    -- 使用增强状态栏后不再需要 vim 的模式提示
    vim.opt.showmode = false
    -- 命令行高为2，提供足够的显示空间
    vim.opt.cmdheight = 1
    -- 当文件被外部程序修改时，自动加载
    vim.opt.autoread = true
    -- 折行
    vim.opt.wrap = true
    -- 行结尾可以跳到下一行
    vim.opt.whichwrap = 'b,s,<,>,[,],h,l'
    -- 允许隐藏被修改过的buffer
    vim.opt.hidden = true
    -- 鼠标支持
    vim.opt.mouse = 'a'
    -- 禁止创建备份文件
    vim.opt.backup = false
    vim.opt.writebackup = false
    vim.opt.swapfile = false
    -- smaller updatetime
    vim.opt.updatetime = 300
    -- 等待mappings
    vim.opt.timeoutlen = 500
    -- split window 从下边和右边出现
    vim.opt.splitbelow = true
    vim.opt.splitright = true
    -- 自动补全不自动选中
    vim.g.completeopt = 'menu,menuone,noselect,noinsert'
    -- 样式
    vim.opt.termguicolors = true
    vim.opt.termguicolors = true
    -- 不可见字符的显示，这里只把空格显示为一个点
    vim.opt.list = true
    vim.opt.listchars = {
        tab = ' ',
        eol = '',
        trail = '·',
        nbsp = '␣'
    }
    -- 补全增强
    vim.opt.wildmenu = true
    -- Dont' pass messages to |ins-completin menu|
    -- vim.opt.shortmess = vim.opt.shortmess .. 'c'
    vim.opt.pumheight = 10
    -- always show tabline
    vim.opt.showtabline = 2
    -- 离开insert模式自动切换英文
    vim.g.noimdisable = true
    -- 状态栏
    vim.opt.laststatus = 3
    -- title
    vim.opt.title = true
    vim.opt.titlelen = 0
    vim.opt.titlestring = '%{getcwd()} - NVIM'
    -- 默认使用系统剪切板
    vim.schedule(function()
        vim.opt.clipboard = 'unnamedplus'
    end)
    -- 设置Terminal
    vim.opt.shell = 'pwsh'
    vim.opt.shellcmdflag =
        '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
    vim.opt.shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
    vim.opt.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    vim.opt.shellquote = ''
    vim.opt.shellxquote = ''
    -- 使用rg替换grep
    vim.opt.grepprg = 'rg --vimgrep --hidden --no-heading --smart-case'
    -- filetypes
    -- vim.filetype.add({
    --     extension = {
    --         jinja = 'jinja',
    --         jinja2 = 'jinja',
    --         j2 = 'jinja'
    --     }
    -- })
    -- mapleader
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '

    -- Preview substitutions live, as you type!
    vim.opt.inccommand = 'split'

    -- Telescope or Snacks
    vim.g.telescope_enabled = false
    vim.g.snacks_enabled = true

    vim.o.foldlevel = 99
end

return M
