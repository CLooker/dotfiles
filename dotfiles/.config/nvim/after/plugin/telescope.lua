require('telescope').setup({
  defaults = {
    file_ignore_patterns = { ".git", "node_modules" }
  },
  extensions = {
    fzf = {}
  }
});
require('telescope').load_extension('fzf')

local builtin = require('telescope.builtin')
local noreOpts = { noremap = true }

-- find files
vim.keymap.set(
  'n',
  '<leader>ff',
  function()
    builtin.find_files({
      cwd = ProjectDir,
      follow = true,
      hidden = true
    })
  end,
  noreOpts
)

-- find git files
vim.keymap.set(
  'n',
  '<leader>fgf',
  function()
    builtin.git_files({
      cwd = ProjectDir,
      additional_args = { "--hidden" }
    })
  end,
  noreOpts
)

-- find help
vim.keymap.set('n', '<leader>fh', builtin.help_tags)

-- find neovim files
vim.keymap.set(
  'n',
  '<leader>fnf',
  function()
    builtin.find_files({
      cwd = vim.fn.expand('$HOME/code/dotfiles/dotfiles/.config/nvim'),
      follow = true,
      hidden = true
    })
  end,
  noreOpts
)

-- find in files
vim.keymap.set(
  'n',
  '<leader>fif',
  function()
    builtin.live_grep({
      cwd = ProjectDir,
      additional_args = { "--hidden" }
    })
  end,
  noreOpts
)
