local buf = require("cl.lib.buf")
local keymap = require("cl.lib.keymap")
local project_dir = require("cl.model.config").project_dir

-- explorer
keymap.set("n", "<leader>e", function()
  vim.cmd("Ex " .. (buf.is_term() and project_dir or buf.dir()))
end)

-- project explorer
keymap.set("n", "<leader>pe", function()
  vim.cmd("Ex " .. project_dir)
end)

-- vertical explorer
keymap.set("n", "<leader>ve", function()
  vim.cmd("vsp " .. (buf.is_term() and project_dir or buf.dir()))
end)

