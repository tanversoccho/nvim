return {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
        'nvim-lua/plenary.nvim',

        -- {
        --     'nvim-telescope/telescope-fzf-native.nvim',
        --     build = 'make',
        -- },
        -- { 'nvim-telescope/telescope-ui-select.nvim' },
        {
            'benfowler/telescope-luasnip.nvim',
            dependencies = {
                'L3MON4D3/LuaSnip',
                'rafamadriz/friendly-snippets',
            },

        },
        {
            'nvim-tree/nvim-web-devicons',
            enabled = vim.g.have_nerd_font
        },
    },
    config = function()
        require('telescope').setup {
            defaults = {
                sorting_strategy = "ascending",
                layout_config = {
                    prompt_position = 'top',
                },
            },

            pickers = {
                jumplist = {
                    layout_strategy = 'vertical',
                    layout_config = {
                        mirror = true,
                        width = 0.62,
                    },
                },

                marks = {
                    layout_strategy = 'vertical',
                    layout_config = {
                        mirror = true,
                        width = 0.62,
                    },
                },
                buffers = {
                    layout_strategy = 'vertical',
                    layout_config = {
                        mirror = true,
                        width = 0.62,
                    },
                },
            },
            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown(),
                },
            },
        }

        -- require('telescope').load_extension( 'fzf')
        -- require('telescope').load_extension( 'ui-select')
        require('telescope').load_extension('luasnip')
        require("telescope").load_extension("noice")

        local builtin = require 'telescope.builtin'
        vim.keymap.set('n', '<leader><leader>', builtin.builtin, { desc = 'Telescope' })
        vim.keymap.set('n', '<leader>fd', builtin.find_files, { desc = '[F]iles' })
        vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[K]eymaps' })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[H]elp' })
        vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Grep [W]ord' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live [G]rep' })
        vim.keymap.set('n', '<leader>fq', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader>ff', builtin.resume, { desc = 'telescope [R]esume' })
        vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = 'Recent Files' })
        vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'buffers' })
        vim.keymap.set('n', "'", builtin.marks, { desc = 'Marks' })
        vim.keymap.set('n', '<C-s>', builtin.registers, { desc = 'Telescope: Show registers' })
        vim.keymap.set('n', '<leader>fs', function()
            require('telescope').extensions.luasnip.luasnip()
        end, { desc = '[F]ind [S]nippets' })

        vim.keymap.set('n', '<leader>f/', function()
            builtin.live_grep {
                grep_open_files = true,
                prompt_title = 'Live Grep in Open Files',
            }
        end, { desc = '[/] in Open Files' })

        vim.keymap.set('n', '<leader>fn', function()
            builtin.find_files { cwd = vim.fn.stdpath 'config' }
        end, { desc = '[N]vim config files' })
    end,
}
