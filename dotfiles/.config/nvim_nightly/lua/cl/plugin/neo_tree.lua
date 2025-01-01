local buf = require("cl.lib.buf")
local keymap = require("cl.lib.keymap")
local project_dir = require("cl.model.config").project_dir

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = require("cl.model.config").neo_tree_enabled,
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            visible = true,
          }
        },
        use_libuv_file_watcher = true
      })

      if buf.is_dir() then
        -- wipe netrw
        vim.cmd("bw")

        -- set cwd and focus
        require('neo-tree.command').execute({
          action = "focus",
          source = "filesystem",
          position = "left",
          reveal_file = project_dir,
          reveal_force_cwd = true,
          dir = project_dir
        })
      else
        -- set cwd and don't focus
        require('neo-tree.command').execute({
          action = "show",
          source = "filesystem",
          position = "left",
          dir = project_dir
        })
      end

      keymap.set("n", "<leader>e", function()                                       -- explorer
        vim.cmd("Neotree reveal " .. (buf.is_term() and project_dir or buf.path()))
      end)

      keymap.set("n", "<leader>E", ":Neotree toggle<CR>")                           -- explorer (toggle)

      keymap.set(                                                                   -- explorer (project) (breaks LSP)
        "n", "<leader>pe", ":Neotree action=focus dir=" .. project_dir ..  "<CR>"
      )
    end
  }
}
