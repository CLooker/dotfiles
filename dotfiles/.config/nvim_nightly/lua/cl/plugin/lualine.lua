return {
  {
    "nvim-lualine/lualine.nvim",
    enabled = require("cl.model.config").lualine_enabled,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      extensions = {},
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {}
      },
      inactive_winbar = {},
      options = {
        always_divide_middle = true,
        always_show_tabline = true,
        component_separators = {
          left = "",
          right = ""
        },
        disabled_filetypes = {
          statusline = { "neo-tree" },
          winbar = {}
        },
        globalstatus = false,
        icons_enabled = true,
        ignore_focus = {},
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100
        },
        section_separators = {
          left = "",
          right = ""
        },
        theme = "auto"
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename", "%n" }, -- %n is bufrn
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" }
      },
      tabline = {},
      winbar = {}
    }
  }
}
