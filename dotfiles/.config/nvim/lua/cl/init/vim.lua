local tabstop = 4

vim.hl = vim.highlight
vim.opt.clipboard = "unnamedplus"
vim.opt.colorcolumn = "120"
vim.opt.expandtab = true
vim.opt.hidden = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.shiftwidth = tabstop
vim.opt.splitright = true
vim.opt.smartindent = true
vim.opt.softtabstop = tabstop
vim.opt.tabstop = tabstop
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true

-- change insert cursor style
vim.cmd [[
  set ttimeout
  set ttimeoutlen=1
  set ttyfast
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
]]

