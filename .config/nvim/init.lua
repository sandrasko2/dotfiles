-- ~/.config/nvim/init.lua — Neovim configuration with lazy.nvim

-- ---------------------------------------------------------------------------
-- Bootstrap lazy.nvim
-- ---------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ---------------------------------------------------------------------------
-- Leader key (must be set before lazy)
-- ---------------------------------------------------------------------------
vim.g.mapleader = " "

-- ---------------------------------------------------------------------------
-- General settings
-- ---------------------------------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.hidden = true
vim.opt.confirm = true
vim.opt.mouse = "a"
vim.opt.updatetime = 250
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "120"
vim.opt.cursorline = true
vim.opt.termguicolors = true

-- ---------------------------------------------------------------------------
-- Indentation
-- ---------------------------------------------------------------------------
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- ---------------------------------------------------------------------------
-- Persistent undo
-- ---------------------------------------------------------------------------
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")
vim.opt.undofile = true

-- ---------------------------------------------------------------------------
-- Load plugins
-- ---------------------------------------------------------------------------
require("lazy").setup("plugins")

-- ---------------------------------------------------------------------------
-- Color scheme (after plugins load)
-- ---------------------------------------------------------------------------
vim.opt.background = "dark"
vim.cmd.colorscheme("gruvbox")

-- ---------------------------------------------------------------------------
-- Key mappings
-- ---------------------------------------------------------------------------
local map = vim.keymap.set

-- Window navigation with Ctrl+hjkl
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Clear search highlight
map("n", "<leader><space>", ":nohlsearch<CR>", { silent = true })

-- Quick save / quit
map("n", "<leader>w", ":w<CR>")
map("n", "<leader>q", ":q<CR>")

-- Buffer navigation
map("n", "<leader>]", ":bnext<CR>", { silent = true })
map("n", "<leader>[", ":bprevious<CR>", { silent = true })

-- ---------------------------------------------------------------------------
-- Filetype-specific settings
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "yaml", "yml", "ansible" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
    end,
})

-- Trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        local pos = vim.api.nvim_win_get_cursor(0)
        vim.cmd([[%s/\s\+$//e]])
        vim.api.nvim_win_set_cursor(0, pos)
    end,
})
