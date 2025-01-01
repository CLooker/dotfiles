local M = {}

local project_dir = require("cl.model.config").project_dir
local small_term_chan_id = 0
local term_name_to_bufnr = {}

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  -- Calculate the position to center the window
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Create a buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  end

  -- Define window configuration
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal", -- No borders or extra UI elements
    border = "rounded",
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

local function mk(term_name)
  local bufnr = term_name_to_bufnr[term_name]
  if bufnr and vim.fn.bufexists(bufnr) == 1 and vim.fn.bufname(bufnr) ~= "" then
    local visible = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == bufnr then
        visible = true
        vim.api.nvim_set_current_win(win)
        break
      end
    end
    if not visible then
      vim.cmd("buffer " .. bufnr)
    end
    vim.cmd("startinsert")
    return
  end
  if term_name == "full" then
    vim.cmd("cd " .. project_dir .. " | term")
  else
    vim.cmd("cd " .. project_dir .. " | vsp | term")
  end
  vim.cmd("startinsert")
  term_name_to_bufnr[term_name] = vim.fn.bufnr("%")
  if term_name == "small" then
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 10)
    vim.api.nvim_set_option_value("winfixheight", true, {})
    small_term_chan_id = vim.bo.channel
  end
end

function M.exec(cmds)
  cmds = cmds or {}
  table.insert(cmds, "")
  M.small()
  vim.fn.chansend(small_term_chan_id, cmds)
end

function M.full()
  return mk("full")
end

function M.small()
  return mk("small")
end

function M.vertical()
  return mk("vertical")
end

function M.floating()
  local state = {
    floating = {
      buf = -1,
      win = -1,
    },
  }

  local toggle_terminal = function()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
      state.floating = create_floating_window { buf = state.floating.buf }
      if vim.bo[state.floating.buf].buftype ~= "terminal" then
        vim.cmd.terminal()
        vim.cmd("startinsert")
      end
    else
      vim.api.nvim_win_hide(state.floating.win)
    end
  end

  return toggle_terminal
end

return M

