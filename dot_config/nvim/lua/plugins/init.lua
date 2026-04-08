-- lua/plugins/init.lua — Plugin specs for lazy.nvim

return {
    -- Colorscheme
    {
        "morhetz/gruvbox",
        lazy = false,
        priority = 1000,
    },

    -- File explorer (replaces NERDTree)
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>n", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
            { "<leader>f", "<cmd>NvimTreeFindFile<cr>", desc = "Find file in tree" },
        },
        opts = {
            filters = { dotfiles = false },
            renderer = { icons = { show = { git = true } } },
        },
    },

    -- Status line (replaces vim-airline)
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = { theme = "gruvbox" },
            sections = {
                lualine_b = { "branch", "diff" },
            },
            extensions = { "nvim-tree", "fugitive" },
        },
    },

    -- Fuzzy finder
    {
        "junegunn/fzf",
        build = function() vim.fn["fzf#install"]() end,
    },
    {
        "junegunn/fzf.vim",
        dependencies = { "junegunn/fzf" },
        keys = {
            { "<C-p>", "<cmd>Files<cr>", desc = "Find files" },
            { "<leader>g", "<cmd>Rg<cr>", desc = "Ripgrep search" },
            { "<leader>b", "<cmd>Buffers<cr>", desc = "List buffers" },
        },
    },

    -- Git
    { "tpope/vim-fugitive" },
    { "airblade/vim-gitgutter" },

    -- Editing
    { "tpope/vim-surround" },
    { "tpope/vim-commentary" },
    { "jiangmiao/auto-pairs" },

    -- Ansible/YAML highlighting
    { "pearofducks/ansible-vim" },

    -- In-buffer markdown rendering (uses bundled treesitter parsers from nix nvim)
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        ft = { "markdown" },
        keys = {
            { "<leader>m", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle markdown rendering" },
        },
        opts = {},
    },
}
