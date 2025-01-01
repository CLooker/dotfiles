local keymap = require("cl.lib.keymap")
local term = require("cl.lib.term")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- buffer
keymap.set("n", "<leader><TAB>", "<C-W><C-W>")                                  -- buffer cycle
keymap.set("n", "<C-h>", "<C-W>h")                                              -- buffer left
keymap.set("n", "<C-j>", "<C-W>j")                                              -- buffer down
keymap.set("n", "<C-k>", "<C-W>k")                                              -- buffer up
keymap.set("n", "<C-l>", "<C-W>l")                                              -- buffer right
keymap.set("n", "<C-6>", "<C-^>")                                               -- buffer previous
keymap.set("n", "<C-S-v>", ":vsp<CR>")                                          -- buffer split
--keymap.set("n", "<leader>qo", ":%bd!|e#<CR>")                                 -- buffer quit (other)
keymap.set("x", "<C>p", "\"_dP")                                                -- buffer paste without register swap

-- exec
keymap.set("n", "<leader>xl", ":.lua<CR>")                                      -- exec lua (line)
keymap.set("v", "<leader>xl", ":lua<CR>")                                       -- exec lua (block)
keymap.set("n", "<leader>xlp", function()                                       -- exec lua (print line)
  local line = vim.fn.getline("."):replace("return", "")
  local command = "lua print(" .. line .. ")"
  vim.cmd(command)
end)
keymap.set("n", "<leader>xrp", ":echo nvim_list_runtime_paths()<CR>")           -- exec runtime paths 
keymap.set("n", "<leader>xdp", function()                                       -- exec dotfiles push
  term.exec({ "dotfiles push" })
end)
keymap.set("n", "<leader>xds", function()                                       -- exec dotfiles sync
  vim.cmd("wa")
  term.exec({ "dotfiles syncp" })
end)

-- messages
keymap.set(                                                                     -- messages
  "n", "<leader>m", ":messages<CR>"
)

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

