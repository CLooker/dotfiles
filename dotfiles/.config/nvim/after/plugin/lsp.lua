require('lspconfig').bashls.setup({})
require('lspconfig').gopls.setup({})
require('lspconfig').lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }
      },
      telemetry = {
        enable = false
      }
    }
  }
})

-- format on save
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or not client.supports_method('textDocument/formatting') then
      return
    end
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = args.buf,
      callback = function()
        vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
      end
    })
  end
})
