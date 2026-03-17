-- Basic settings
vim.opt.number = true
-- vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.tabstop = 4
-- vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true

vim.g.mapleader = " "

-- Install lazy.nvim automatically
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    { "nvim-lua/plenary.nvim" },

    -- theme
    --{ "folke/tokyonight.nvim", config = function()
    --    vim.cmd.colorscheme("tokyonight")
    --end },

    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    -- telescope
    {
        'nvim-telescope/telescope.nvim', tag = '*',
        dependencies = { 
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        }
    },

    -- treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate'
    },

    -- file tree
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- LSP
    -- { "neovim/nvim-lspconfig" },

    -- autocomplete
    -- { "hrsh7th/nvim-cmp",
    --  dependencies = {
    --      "hrsh7th/cmp-nvim-lsp",
    --      "L3MON4D3/LuaSnip",
    --  },
    -- },
}
local opts = {}

-- Plugins
require("lazy").setup(plugins, opts)

local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

local config = require("nvim-treesitter.config")
config.setup({
    ensure_installed = {"lua", "javascript", "rust", "zig"},
    highlight = { enable = true },
    indent = { enable = true }
})

require("nvim-tree").setup()
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', {})

require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"
