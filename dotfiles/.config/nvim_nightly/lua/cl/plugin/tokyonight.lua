return {
  {
    "folke/tokyonight.nvim",
    enabled = require("cl.model.config").tokyonight_enabled,
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({})
      vim.cmd("colorscheme tokyonight-night")
    end
  }
}
