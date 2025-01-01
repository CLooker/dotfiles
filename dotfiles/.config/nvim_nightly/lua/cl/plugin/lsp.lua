local keymap = require("cl.lib.keymap")
local blink_cmp_enabled = require("cl.model.config").blink_cmp_enabled
local lsp_enabled = require("cl.model.config").lsp_enabled
local lsp_debug_enabled = require("cl.model.config").lsp_debug_enabled

local dependencies = {
  "williamboman/mason.nvim",
  "nvimtools/none-ls.nvim",
}
if blink_cmp_enabled then
  dependencies[#dependencies + 1] = "saghen/blink.cmp"
end

return {
  {
    "jay-babu/mason-null-ls.nvim",
    enabled = lsp_enabled,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = dependencies,
    config = function()
      require("mason").setup()
      require("mason-null-ls").setup({
        ensure_installed = {
          "stylua",
        },
        automatic_installation = true,
      })
      require("null-ls").setup({
        sources = {
          require("null-ls").builtins.formatting.stylua,
        },
      })

      keymap.set("n", "g=", vim.lsp.buf.format)
    end,
  },
  {
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
    "neovim/nvim-lspconfig",
    enabled = lsp_enabled,
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local opts = {}
      if blink_cmp_enabled then
        opts.capabilities = require("blink.cmp").get_lsp_capabilities()
      end

      require("lspconfig").bashls.setup(opts)
      require("lspconfig").lua_ls.setup(opts)
      require("lspconfig").nil_ls.setup(opts)

      if lsp_debug_enabled then
        -- check logs using :LspLog
        vim.lsp.set_log_level("debug")
      end

      -- :h lsp-defaults to see keymaps
    end,
  },
}
