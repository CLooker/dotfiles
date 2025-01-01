local keymap = require("cl.lib.keymap")
local term = require("cl.lib.term")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- exec
keymap.set("n", "<leader><leader>l", ":.lua<CR>")                               -- exec lua (line)
keymap.set("v", "<leader><leader>l", ":lua<CR>")                                -- exec lua (block)
keymap.set("n", "<leader><leader>lp", function()                                -- exec lua (print line)
  local line = vim.fn.getline("."):replace("return", "")
  local command = "lua print(" .. line .. ")"
  vim.cmd(command)
end)
keymap.set("n", "<leader><leader>rp", ":echo nvim_list_runtime_paths()<CR>")    -- exec runtime paths 
keymap.set("n", "<leader><leader>dp", function()                                -- exec dotfiles push
  term.exec({ "dotfiles push" })
end)
keymap.set("n", "<leader><leader>ds", function()                                -- exec dotfiles sync
  vim.cmd("wa")
  term.exec({ "dotfiles syncp" })
end)

-- messages
keymap.set(                                                                     -- messages
  "n", "<leader>m", ":messages<CR>"
)

-- misc
keymap.set("n", "g=", "gg=G")                                                   -- format
keymap.set("x", "<leader>p", "\"_dP")                                           -- paste without register swap

-- motion
keymap.set("n", "<C-d>", "<C-d>zz")                                             -- motion down half page and center screen
keymap.set("n", "<C-u>", "<C-u>zz")                                             -- motion up half page and center screen

-- source
keymap.set("n", "<leader>so", ":so %<CR>")                                      -- source
keymap.set(                                                                     -- source (init.lua)
  "n",
  "<leader>si",
  ":so ~/code/dotfiles/dotfiles/.config/nvim/init.lua<CR>"
)

-- window
keymap.set("n", "<C-h>", "<C-w>h")                                              -- window left
keymap.set("n", "<C-j>", "<C-w>j")                                              -- window down
keymap.set("n", "<C-k>", "<C-w>k")                                              -- window up
keymap.set("n", "<C-l>", "<C-w>l")                                              -- window right
keymap.set("n", "<C-p>", "<C-w>p")                                              -- window prev
keymap.set("n", "<C-6>", "<C-^>")                                               -- window prev (buffer)
keymap.set("n", "<C-s>", "<C-w>v")                                              -- window split

