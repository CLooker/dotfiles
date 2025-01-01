-- replace buffer at cursor with output of lua cmd
-- :R vim.fn.expand("%s")
vim.api.nvim_create_user_command(
  "R",
  function(opts)
    local ok, result = pcall(loadstring("return " .. opts.args))
    if not ok then
      vim.api.nvim_echo({ { "Error: " .. result, "ErrorMsg" } }, true, {})
      return
    end
    -- split tables or convert single values to strings
    local lines = type(result) == "table" and vim.split(vim.inspect(result), "\n") or { tostring(result) }
    -- insert the lines into the buffer below the current cursor
    vim.api.nvim_buf_set_lines(0, vim.api.nvim_win_get_cursor(0)[1], vim.api.nvim_win_get_cursor(0)[1], false, lines)
  end,
  { nargs = 1 } -- One argument required
)

