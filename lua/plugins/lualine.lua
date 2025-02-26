return { -- statusline
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = ' '
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require 'lualine_require'
      lualine_require.require = require

      vim.o.laststatus = vim.g.lualine_laststatus

      local opts = {
        options = {
          theme = 'auto',
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = {
            statusline = { 'dashboard', 'alpha', 'ministarter' },
          },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { function() return _G.context.current_project or '' end, 'branch',  },

          lualine_c = { -- Utils.lualine.root_dir(),
            -- {
            -- 	"diagnostics",
            -- 	symbols = {
            -- 		error = icons.diagnostics.Error,
            -- 		warn = icons.diagnostics.Warn,
            -- 		info = icons.diagnostics.Info,
            -- 		hint = icons.diagnostics.Hint,
            -- 	},
            -- },
            -- {
            -- 	"filetype",
            -- 	icon_only = true,
            -- 	separator = "",
            -- 	padding = {
            -- 		left = 1,
            -- 		right = 0,
            -- 	},
            -- },
            {
              'filename',
              file_status = true, -- Displays file status (readonly status, modified status)
              path = 1, -- 0: Just the filename 1: Relative path 2: Absolute path 3: Absolute path, with tilde as the home directory
              shorting_target = 40, -- Shortens path to leave 40 spaces in the window
            }, -- { Utils.lualine.pretty_path() },
          },
          lualine_x = { -- stylua: ignore
            -- {
            --     function()
            --         return require("noice").api.status.command.get()
            --     end,
            --     cond = function()
            --         return package.loaded["noice"] and require("noice").api.status.command.has()
            --     end,
            --     -- color = function()
            --     --     return Utils.ui.fg("Statement")
            --     -- end
            -- }, -- stylua: ignore
            -- {
            --     function()
            --         return require("noice").api.status.mode.get()
            --     end,
            --     cond = function()
            --         return package.loaded["noice"] and require("noice").api.status.mode.has()
            --     end,
            --     -- color = function()
            --     --     return Utils.ui.fg("Constant")
            --     -- end
            -- }, -- stylua: ignore
            -- {
            --     function()
            --         return "  " .. require("dap").status()
            --     end,
            --     cond = function()
            --         return package.loaded["dap"] and require("dap").status() ~= ""
            --     end,
            --     -- color = function()
            --     --     return Utils.ui.fg("Debug")
            --     -- end
            -- }, -- stylua: ignore
            {
              function()
                return require('lsp-status').status()
              end,
            }, -- {
            -- 	require("lazy.status").updates,
            -- 	cond = require("lazy.status").has_updates,
            -- 	color = function()
            -- 		return Utils.ui.fg("Special")
            -- 	end,
            -- },
            {
              'diff',
              symbols = {
                added = '+',
                modified = '~',
                removed = '-',
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_y = { 'quickfix', 'ctrlspace', 'searchcount', 'encoding', 'fileformat', 'filetype' },
          lualine_z = {
            "'0x' .. '%B'",
            "' ' .. vim.fn.line('$')",
            {
              'location',
              padding = {
                left = 0,
                right = 1,
              },
            },
          },
        },
        -- extensions = {{filetypes = {"neo-tree"}}, "lazy"}
      }

      local trouble = require 'trouble'
      local symbols = trouble.statusline {
        mode = 'symbols',
        groups = {},
        title = false,
        filter = {
          range = true,
        },
        format = '{kind_icon}{symbol.name:Normal}',
        hl_group = 'lualine_c_normal',
      }
      table.insert(opts.sections.lualine_c, {
        symbols and symbols.get,
        cond = function()
          return symbols.has()
        end,
      })

      return opts
    end,
  },
}
