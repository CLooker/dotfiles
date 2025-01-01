local M = {}

function M.cwd()
  return vim.fn.getcwd()
end

function M.dir()
  return vim.fn.expand("%:p:h")
end

function M.is_dir()
  return vim.fn.isdirectory(M.path()) == 1
end

function M.is_term()
  return M.path():contains("term://")
end

function M.path()
  return vim.fn.expand("%:p")
end

return M
