local buf = require("cl.lib.buf")
local keymap = require("cl.lib.keymap")
local project_dir = require("cl.model.config").project_dir

return {
  {
    'stevearc/oil.nvim',
    enabled = require("cl.model.config").oil_enabled,
    ---@module 'oil'
    ---@type oil.SetupOpts
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    config = function()
      require("oil").setup({
        view_options = {
          show_hidden = true
        }
      })

      keymap.set("n", "<leader>e", function()                             -- explorer
        vim.cmd("Oil " .. (buf.is_term() and project_dir or buf.dir()))
      end)

      keymap.set("n", "<leader>pe", function()                            -- explorer (project)
        vim.cmd("Oil " .. project_dir)
      end)

      keymap.set("n", "<leader>ve", function()                            -- explorer (vertical)
        vim.cmd.vnew()
        vim.cmd("Oil " .. (buf.is_term() and project_dir or buf.dir()))
      end)
    end
  }
}

