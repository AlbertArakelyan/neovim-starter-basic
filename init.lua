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

    -- bufferline (tabs)
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- LSP
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    -- autocomplete
    { "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
        },
    },
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

require("bufferline").setup{}
vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', {})
vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', {})
vim.keymap.set('n', '<leader>x', ':bd<CR>', {})

-- LSP setup
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "ts_ls",           -- JS/TS
        "rust_analyzer",    -- Rust
        "zls",              -- Zig
        "lua_ls",           -- Lua
        "html",             -- HTML
        "cssls",            -- CSS
        "clangd",           -- C/C++
    },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = { "ts_ls", "rust_analyzer", "zls", "lua_ls", "html", "cssls", "clangd" }
for _, server in ipairs(servers) do
    vim.lsp.config(server, { capabilities = capabilities })
end
vim.lsp.enable(servers)

-- autocomplete setup
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
    }),
})

require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"
