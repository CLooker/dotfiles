local keymap = require("cl.lib.keymap")
local term = require("cl.lib.term")

keymap.set("n", "<leader>t", function() term.full() end)      -- full
keymap.set("n", "<leader>vt", function() term.vertical() end) -- vertical
keymap.set("n", "<leader>ft", term.floating())                -- floating
keymap.set("n", "<leader>st", function() term.small() end)    -- small
keymap.set("t", "<Esc>", "<C-\\><C-n>")                       -- <Esc> works

vim.api.nvim_create_autocmd("TermOpen", {
  desc = "Set term options",
  group = vim.api.nvim_create_augroup("TermOpenOptions", { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end
})
