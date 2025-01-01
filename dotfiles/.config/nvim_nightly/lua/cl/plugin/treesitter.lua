return {
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = require("cl.model.config").treesitter_enabled,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false
        },
        indent = { enable = true }
      })
    end
  }
}
