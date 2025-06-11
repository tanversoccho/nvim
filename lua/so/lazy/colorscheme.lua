return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require("rose-pine").setup({
                -- styles = {
                --     transparency = true,
                -- },
            })
            -- vim.cmd("colorscheme rose-pine-main")
        end,
    },

    {
        'folke/tokyonight.nvim',
        priority = 1000,
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require('tokyonight').setup {
                styles = {
                    comments = { italic = false },
                },
            }
            vim.cmd.colorscheme 'tokyonight-night'
        end,
    }

}
