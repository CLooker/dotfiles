  -- open help in right split
  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = vim.api.nvim_create_augroup("help_window_right", { clear = true}),
    pattern = { "*.txt" },
    callback = function()
      local nvim_lsp_detected = vim.fn.expand("%:p"):match("nvim%-lspconfig") ~= nil
      if vim.bo.filetype == 'help' or nvim_lsp_detected then
        vim.cmd.wincmd("L")
      end
    end
  })
