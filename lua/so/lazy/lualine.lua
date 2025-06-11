return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local lsp_status = {
            function()
                local msg = 'No Active Lsp'
                local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
                local clients = vim.lsp.get_clients()
                if next(clients) == nil then
                    return msg
                end
                for _, client in ipairs(clients) do
                    local filetypes = client.config.filetypes
                    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                        return client.name
                    end
                end
                return msg
            end,
            icon = ' LSP:',
        }

        local function tab_list()
            local s = ''
            local total = vim.fn.tabpagenr('$')
            local current = vim.fn.tabpagenr()

            for i = 1, total do
                if i == current then
                    -- Highlight current tab
                    s = s .. '%#lualine_a_normal#[' .. i .. '] '
                else
                    -- Inactive tabs
                    s = s .. '%#lualine_a_inactive#[' .. i .. '] '
                end
            end

            return s
        end

        require('lualine').setup {
            options = {
                icons_enabled = true,
                theme = 'auto',
                section_separators = '',
                component_separators = '',
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                always_show_tabline = true,
                globalstatus = false,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                    refresh_time = 16, -- ~60fps
                    events = {
                        'WinEnter',
                        'BufEnter',
                        'BufWritePost',
                        'SessionLoadPost',
                        'FileChangedShellPost',
                        'VimResized',
                        'Filetype',
                        'CursorMoved',
                        'CursorMovedI',
                        'ModeChanged',
                    },
                }
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = {},
                lualine_c = {},
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
            inactive_sections = {},
            tabline = {

                lualine_a = {
                    tab_list,
                },
                lualine_b = {
                    {
                        function()
                            return vim.fn.getcwd()
                        end,
                        icon = '📁',
                    },
                },
                lualine_c = {
                    {
                        'filename',
                        path = 1, -- Shows relative path
                    },
                },
                lualine_x = { lsp_status },
                lualine_y = {
                    { 'branch' },
                    { 'diff' },
                    { 'diagnostics' },
                },
                lualine_z = {}
            },
            winbar = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = {},
                lualine_y = {},
                lualine_z = {}
            },
            inactive_winbar = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = {},
                lualine_y = { 'location' },
                lualine_z = {}
            },
            extensions = {}
        }
    end
}
