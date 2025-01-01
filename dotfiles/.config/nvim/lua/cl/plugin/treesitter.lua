return {
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = require("cl.model.config").treesitter_enabled,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false
        },
        indent = { enable = true },
        sync_install = false
      })
    end
  }
}
