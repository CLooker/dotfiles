ProjectDir = vim.uv.cwd();

local function setEnv()
    print("ProjectDir: " .. ProjectDir)
end

local function setOpts()
    local tabstop = 4
    vim.hl = vim.highlight
    vim.opt.clipboard = "unnamedplus" -- use OS clipboard
    vim.opt.colorcolumn = "120"       -- set vertical ruler column
    vim.opt.expandtab = true
    vim.opt.hidden = false
    vim.opt.hlsearch = false
    vim.opt.incsearch = true
    vim.opt.mouse = "a" -- highlight to paste
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.scrolloff = 8
    vim.opt.shiftwidth = tabstop
    vim.opt.splitright = true
    vim.opt.smartindent = true
    vim.opt.softtabstop = tabstop
    vim.opt.termguicolors = true
    vim.opt.undofile = true
end

local function setKeymaps()
    local noreOpts = { noremap = true }
    local silentNoreOpts = { noremap = true, silent = true }

    vim.g.mapleader = " "

    -- explorer
    vim.keymap.set(
        "n",
        "<leader>e",
        function()
            local bufPath = vim.api.nvim_exec(":echo expand('%s:p')", true)
            local isTerm = bufPath:find("^" .. "term://") ~= nil
            local cmd = isTerm and ("e " .. ProjectDir) or "Ex"
            vim.cmd(cmd)
        end,
        noreOpts
    )

    -- explorer (project dir)
    vim.keymap.set(
        "n",
        "<leader>pe",
        ":e " .. ProjectDir .. "<CR>",
        noreOpts
    )

    -- explorer (vertically split)
    vim.keymap.set("n", "<leader>ve", ":vsp " .. ProjectDir .. "<CR>", noreOpts)

    -- terminal creating it if it doesn't exist
    vim.keymap.set(
        "n",
        "<leader>t",
        function()
            local termBuf = vim.fn.bufnr("term://*")
            local termCmd = termBuf > 0
                and ("buffer " .. termBuf)
                or "cd " .. ProjectDir .. " | terminal"
            vim.cmd(termCmd)
            vim.cmd("startinsert")
        end,
        noreOpts
    )

    -- terminal (vertically split) creating it if it doesn't exist
    vim.keymap.set(
        "n",
        "<leader>vt",
        function()
            local termBuf = vim.fn.bufnr("term://*")
            local termCmd = termBuf > 0
                and ("vertical buffer " .. termBuf)
                or "vsp | cd " .. ProjectDir .. " | terminal"
            vim.cmd(termCmd)
            vim.cmd("startinsert")
        end,
        noreOpts
    )

    -- down half page and center screen
    vim.keymap.set("n", "<C-d>", "<C-d>zz", noreOpts)

    -- up half page and center screen
    vim.keymap.set("n", "<C-u>", "<C-u>zz", noreOpts)

    -- previous buffer
    vim.keymap.set("n", "<C-6>", "<C-^>", silentNoreOpts)

    -- <Esc> works in terminal
    vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", noreOpts)

    -- paste without swapping register
    vim.keymap.set("x", "<leader>p", "\"_dP", noreOpts)

    -- runtime path
    vim.keymap.set("n", "<leader>rp", ":echo nvim_list_runtime_paths()<CR>")

    -- source config
    vim.keymap.set("n", "<leader>sc", "<cmd>source %<CR>")

    -- exec lua (line)
    vim.keymap.set("n", "<leader>x", ":.lua<CR>")

    -- exec lua (block)
    vim.keymap.set("v", "<leader>x", ":lua<CR>")
end

local function configureTerminal()
    -- use git-bash in windows
    vim.cmd [[
  if has("win32")
    let &shell='bash.exe'
    let &shellcmdflag = '-c'
    let &shellredir = '>%s 2>&1'
    set shellquote= shellxescape=
    " set noshelltemp
    set shellxquote=
    let &shellpipe='2>&1| tee'
    endif
    ]]
end


local function main()
    if vim.g.vscode then
        setOpts()
        return
    end

    setEnv()
    setOpts()
    setKeymaps()
    configureTerminal()
end
main()
