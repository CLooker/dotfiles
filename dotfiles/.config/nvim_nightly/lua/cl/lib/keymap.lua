local M = {}
local nore_opts = { noremap = true }

function M.set(mode, lhs, rhs)
  vim.keymap.set(mode, lhs, rhs, nore_opts)
end

return M
