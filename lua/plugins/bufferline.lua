return {
  {
    'akinsho/bufferline.nvim',
    lazy = false,
    keys = {},
    config = function(_, opts)
      local bufferline = require 'bufferline'
      bufferline.setup {
        options = {
          diagnostics = 'nvim_lsp',
          always_show_bufferline = true,
          style_preset = {
            bufferline.style_preset.no_italic,
            bufferline.style_preset.no_bold,
          },
          -- diagnostics_indicator = function(_, _, diag)
          --     local icons = Config.icons.diagnostics
          --     local ret = (diag.error and icons.Error .. diag.error .. " " or "") ..
          --                     (diag.warning and icons.Warn .. diag.warning or "")
          --     return vim.trim(ret)
          -- end,
          offsets = {
            {
              filetype = 'neo-tree',
              text = 'Neo-tree',
              highlight = 'Directory',
              text_align = 'left',
            },
          },
          ---@param opts bufferline.IconFetcherOpts
          -- get_element_icon = function(opts)
          --     return Config.icons.ft[opts.filetype]
          -- end
        },
      }
    end,
  },
}
