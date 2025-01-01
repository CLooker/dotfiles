local M = {}
local debug_enabled = require("cl.model.config").debug_enabled

local function _print(it)
  if type(it) == "table" then
    print(vim.inspect(it))
  else
    print(it)
  end
  print(" ")
end

function M.debug(it)
  if debug_enabled then
    _print(it)
  end
end

function M.info(it)
  _print(it)
end

return M
