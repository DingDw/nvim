-- 防止意外覆盖全局变量
setmetatable(_G, {
  __newindex = function(_, name, value)
    if rawget(_G, name) ~= nil then
      error('Attempt to override global var: ' .. name, 2)
    end
    rawset(_G, name, value)
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- 基础配置
require('config.base').setup()

-- gui配置
require('config.gui').setup()

-- keymap配置
require('config.keymap').setup()

-- Autocommands
require('config.autocmd').setup()

-- 工具类
require('utils').setup()

-- 自定义命令
require('config.user_commands').setup()

-- 插件
require('lazy').setup {
  spec = { { import = 'plugins' } },
  -- automatically check for plugin updates
  checker = { enabled = false },
}

-- colorscheme
require('config.colorscheme').setup()

-- 定义全局上下文
_G.context = {}
