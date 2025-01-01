local keymap = require("cl.lib.keymap")
local project_dir = require("cl.model.config").project_dir

return {
  {
    "nvim-telescope/telescope.nvim",
    enabled = require("cl.model.config").telescope_enabled,
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make"
      }
    },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { ".git", "node_modules" },
          preview = {
            check_mime_type = false
          }
        },
        extensions = {
          fzf = {}
        }
      });
      require("telescope").load_extension("fzf")

      local finders = require("telescope.finders")
      local pickers = require("telescope.pickers")
      local make_entry = require("telescope.make_entry")
      local builtin = require("telescope.builtin")

      local cwd = project_dir

      local grep = function(opts)
        opts = opts or {}
        opts.cwd = opts.cwd or project_dir

        local finder = finders.new_async_job {
          command_generator = function(prompt)
            if not prompt or prompt == "" then
              return nil
            end

            local args = { "rg" }
            local split_prompt = vim.split(prompt, "  ")
            if split_prompt[1] then
              table.insert(args, "--hidden")
              table.insert(args, "--regexp")
              table.insert(args, split_prompt[1])
            end
            if split_prompt[2] then
              table.insert(args, "--glob")
              table.insert(args, split_prompt[2])
            end

            ---@diagnostic disable-next-line: deprecated
            return vim.tbl_flatten {
              args,
              { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
            }
          end,
          entry_maker = make_entry.gen_from_vimgrep(opts),
          cwd = opts.cwd,
        }

        pickers.new(opts, {
          debounce = 100,
          prompt_title = "Grep: <line>[<space><space><file>], e.g. 'foo' or 'foo  **/dir/*.sh'",
          finder = finder,
          previewer = require("telescope.config").values.grep_previewer(opts),
          sorter = require("telescope.sorters").empty(),
        }):find()
      end

      keymap.set("n", "<leader>ff", function()            -- find files
        builtin.find_files({
          cwd = cwd,
          follow = true,
          hidden = true
        })
      end)

      keymap.set("n", "<leader>fg", grep)                 -- find grep

      keymap.set("n", "<leader>fh", builtin.help_tags)    -- find help
    end
  }
}
