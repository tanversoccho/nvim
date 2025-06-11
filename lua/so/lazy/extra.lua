return {
    { "OXY2DEV/markview.nvim",    lazy = false },
    {
        "iamcco/markdown-preview.nvim",
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    { "folke/todo-comments.nvim", opts = {} },
    { "nvim-lua/plenary.nvim",    lazy = true },
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        },
    },
    { "kdheepak/lazygit.nvim" },
    {
        'echasnovski/mini.nvim',
        config = function()
            require('mini.ai').setup { n_lines = 500 }
            require('mini.surround').setup()
            require("mini.pairs").setup()
        end,
    },
    {
        'stevearc/oil.nvim',
        opts = { vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }) },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
    },
    {
        'folke/which-key.nvim',
        event = 'VimEnter',
        opts = {
            preset = "helix",
        },
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        lazy = false,
        config = function()
            require("neo-tree").setup({
                window = {
                    position = "right",
                },
            })
        end,
    }
}
