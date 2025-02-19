return {
  {
    'echasnovski/mini.files',
    version = '*',
    lazy = false,
    opts = {
      -- Customization of shown content
      content = {
        -- Predicate for which file system entries to show
        filter = nil,
        -- What prefix to show to the left of file system entry
        prefix = nil,
        -- In which order to show file system entries
        sort = nil,
      },

      -- Module mappings created only inside explorer.
      -- Use `''` (empty string) to not create one.
      mappings = {
        close = '<esc>',
        go_in = 'l',
        go_in_plus = '<CR>',
        go_out = 'H',
        go_out_plus = 'h',
        mark_goto = "'",
        mark_set = 'm',
        reset = '<BS>',
        reveal_cwd = '@',
        show_help = 'g?',
        synchronize = 's',
        trim_left = '<',
        trim_right = '>',
        go_in_vertical_plus = '<C-v>',
        go_in_horizontal_plus = '<C-s>',
        go_in_vertical = '<C-w>V',
        go_in_horizontal = '<C-w>S',
        toggle_hidden = 'g.',
        change_cwd = 'gc',
      },

      -- General options
      options = {
        -- Whether to delete permanently or move into module-specific trash
        permanent_delete = false,
        -- Whether to use for editing directories
        use_as_default_explorer = true,
      },

      -- Customization of explorer windows
      windows = {
        -- Maximum number of windows to show side by side
        max_number = math.huge,
        -- Whether to show preview of file/directory under cursor
        preview = false,
        -- Width of focused window
        width_focus = 30,
        -- Width of non-focused window
        width_nofocus = 25,
        -- Width of preview window
        width_preview = 50,
      },
    },
    keys = {
      {
        '<leader>e',
        function()
          MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
          vim.schedule(function()
            -- MiniFiles.reveal_cwd();
            Utils.mini.files.reveal_cwd()
          end)
        end,
        desc = 'Open mini.files (Directory of Current File)',
      },
      {
        '<leader>E',
        function()
          require('mini.files').open(vim.uv.cwd(), false)
        end,
        desc = 'Open mini.files (cwd)',
      },
    },
    config = function(_, opts)
      require('mini.files').setup(opts)

      local show_dotfiles = true
      local filter_show = function(fs_entry)
        return true
      end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, '.')
      end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        require('mini.files').refresh {
          content = {
            filter = new_filter,
          },
        }
      end

      local map_split = function(buf_id, lhs, direction, close_on_file)
        local rhs = function()
          local new_target_window
          local cur_target_window = require('mini.files').get_explorer_state().target_window
          if cur_target_window ~= nil then
            vim.api.nvim_win_call(cur_target_window, function()
              vim.cmd('belowright ' .. direction .. ' split')
              new_target_window = vim.api.nvim_get_current_win()
            end)

            require('mini.files').set_target_window(new_target_window)
            require('mini.files').go_in {
              close_on_file = close_on_file,
            }
          end
        end

        local desc = 'Open in ' .. direction .. ' split'
        if close_on_file then
          desc = desc .. ' and close'
        end
        vim.keymap.set('n', lhs, rhs, {
          buffer = buf_id,
          desc = desc,
        })
      end

      local files_set_cwd = function()
        local cur_entry_path = MiniFiles.get_fs_entry().path
        local cur_directory = vim.fs.dirname(cur_entry_path)
        if cur_directory ~= nil then
          print(cur_directory)
          vim.fn.chdir(cur_directory)
        end
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id

          vim.keymap.set('n', opts.mappings and opts.mappings.toggle_hidden, toggle_dotfiles, {
            buffer = buf_id,
            desc = 'Toggle hidden files',
          })

          vim.keymap.set('n', opts.mappings and opts.mappings.change_cwd, files_set_cwd, {
            buffer = args.data.buf_id,
            desc = 'Set cwd',
          })

          vim.keymap.set('n', '<leader>/', function()
            local entry_path = MiniFiles.get_fs_entry().path
            MiniFiles.close()
            if vim.g.telescope_enabled then
              require('telescope.builtin').live_grep {
                search_dirs = { entry_path },
                prompt_title = string.format('Grep in [%s]', entry_path),
              }
            else
              Snacks.picker.grep {
                dirs = { entry_path },
              }
            end
          end, {
            buffer = args.data.buf_id,
            desc = 'Search current path',
          })

          vim.keymap.set('n', 'gy', function()
            local entry_path = MiniFiles.get_fs_entry().path
            local rel_path = entry_path:sub(#vim.uv.cwd() + 2)
            Utils.info(string.format('Copy Path[%s]', rel_path))
            vim.fn.setreg('+', rel_path)
          end, {
            buffer = args.data.buf_id,
            desc = 'Copy Entry Relpath',
          })

          vim.keymap.set('n', 'gY', function()
            local entry_path = MiniFiles.get_fs_entry().path
            Utils.info(string.format('Copy Path[%s]', entry_path))
            vim.fn.setreg('+', entry_path)
          end, {
            buffer = args.data.buf_id,
            desc = 'Copy Entry Relpath',
          })

          vim.keymap.set('n', 'O', function()
            local entry_path = MiniFiles.get_fs_entry().path
            require('lazy.util').open(entry_path, {
              system = true,
            })
          end, {
            buffer = args.data.buf_id,
            desc = 'Open With System App',
          })

          map_split(buf_id, opts.mappings and opts.mappings.go_in_horizontal or '<C-w>s', 'horizontal', false)
          map_split(buf_id, opts.mappings and opts.mappings.go_in_vertical or '<C-w>v', 'vertical', false)
          map_split(buf_id, opts.mappings and opts.mappings.go_in_horizontal_plus or '<C-w>S', 'horizontal', true)
          map_split(buf_id, opts.mappings and opts.mappings.go_in_vertical_plus or '<C-w>V', 'vertical', true)
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesActionRename',
        callback = function(event)
          Snacks.rename.on_rename_file(event.data.from, event.data.to)
        end,
      })
    end,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    cmd = 'Neotree',
    enabled = true,
    lazy = true,
    dependencies = {
      { 'echasnovski/mini.icons', opts = {} }, -- add mini.icons
    },
    keys = {
      {
        '<leader>r',
        function()
          require('neo-tree.command').execute {
            toggle = true,
            dir = vim.uv.cwd(),
          }
        end,
        desc = 'Explorer NeoTree (cwd)',
        remap = true,
      },
    },
    deactivate = function()
      vim.cmd [[Neotree close]]
    end,
    init = function()
      -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
      -- because `cwd` is not set up properly.
      vim.api.nvim_create_autocmd('BufEnter', {
        group = vim.api.nvim_create_augroup('Neotree_start_directory', {
          clear = true,
        }),
        desc = 'Start Neo-tree with directory',
        once = true,
        callback = function()
          if package.loaded['neo-tree'] then
            return
          else
            local stats = vim.uv.fs_stat(vim.fn.argv(0))
            if stats and stats.type == 'directory' then
              require 'neo-tree'
            end
          end
        end,
      })
    end,
    opts = {
      sources = { 'filesystem' },
      open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf', 'Outline' },
      enable_diagnostics = false,
      enable_git_status = false,
      filesystem = {
        bind_to_cwd = true,
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },
      window = {
        mappings = {
          ['<C-s>'] = 'open_split',
          ['<C-v>'] = 'open_vsplit',
          ['gY'] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg('+', path, 'c')
            end,
            desc = 'Copy Path to Clipboard',
          },
          ['O'] = {
            function(state)
              require('lazy.util').open(state.tree:get_node().path, {
                system = true,
              })
            end,
            desc = 'Open with System Application',
          },
          ['P'] = {
            'toggle_preview',
            config = {
              use_float = true,
            },
          },
          ['/'] = 'noop',
          ['<leader>/'] = {
            function(state)
              if vim.g.telescope_enabled then
                require('telescope.builtin').live_grep {
                  search_dirs = { state.tree:get_node().path },
                  prompt_title = string.format('Grep in [%s]', state.tree:get_node().path),
                }
              else
                Snacks.picker.grep {
                  dirs = { entry_path },
                }
              end
            end,
          },
        },
      },
      default_component_configs = {
        icon = {
          provider = function(icon, node) -- setup a custom icon provider
            local text, hl
            local mini_icons = require "mini.icons"
            if node.type == "file" then -- if it's a file, set the text/hl
              text, hl = mini_icons.get("file", node.name)
            elseif node.type == "directory" then -- get directory icons
              text, hl = mini_icons.get("directory", node.name)
              -- only set the icon text if it is not expanded
              if node:is_expanded() then text = nil end
            end
  
            -- set the icon text/highlight only if it exists
            if text then icon.text = text end
            if hl then icon.highlight = hl end
          end,
        },
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
        git_status = {
          symbols = {
            unstaged = '󰄱',
            staged = '󰱒',
          },
        },
      },
    },
    config = function(_, opts)
      local function on_move(data)
        Utils.lsp.on_rename(data.source, data.destination)
      end

      local events = require 'neo-tree.events'
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        {
          event = events.FILE_MOVED,
          handler = on_move,
        },
        {
          event = events.FILE_RENAMED,
          handler = on_move,
        },
      })
      require('neo-tree').setup(opts)
      vim.api.nvim_create_autocmd('TermClose', {
        pattern = '*lazygit',
        callback = function()
          if package.loaded['neo-tree.sources.git_status'] then
            require('neo-tree.sources.git_status').refresh()
          end
        end,
      })
    end,
  },
}
