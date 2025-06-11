-- ~/.config/nvim/lua/plugins/mini-config.lua
local bracketed = require("mini.bracketed")
local surround = require("mini.surround")

-- ------------------------------------------------------------
-- 1. mini.bracketed: The "[ ]" navigation engine
-- ------------------------------------------------------------
-- This allows you to use keys like `]b` (next buffer) or `[d` (prev diagnostic)
bracketed.setup({
    -- These are the default mappings.
    -- You don't need to redefine them unless you want to change the suffix keys.
    buffer     = { suffix = "b" }, -- ]b / [b
    comment    = { suffix = "c" }, -- ]c / [c
    conflict   = { suffix = "x" }, -- ]x / [x
    diagnostic = { suffix = "d" }, -- ]d / [d  (LSP errors/warnings)
    file       = { suffix = "f" }, -- ]f / [f
    indent     = { suffix = "i" }, -- ]i / [i  (Indent level changes)
    jump       = { suffix = "j" }, -- ]j / [j  (Jumplist)
    location   = { suffix = "l" }, -- ]l / [l  (Location list)
    oldfile    = { suffix = "o" }, -- ]o / [o  (Recent files)
    quickfix   = { suffix = "q" }, -- ]q / [q  (Quickfix list)
    treesitter = { suffix = "t" }, -- ]t / [t  (Navigate TS nodes)
    undo       = { suffix = "u" }, -- ]u / [u  (Undo states)
    window     = { suffix = "w" }, -- ]w / [w  (Windows)
    yank       = { suffix = "y" }, -- ]y / [y  (Yank history)
})

-- ------------------------------------------------------------
-- 2. mini.surround: The "sa/sd/sr" bracket editor
-- ------------------------------------------------------------
-- This allows you to add/delete/change brackets, quotes, tags, etc.
surround.setup({
    -- Mappings (Default keys are perfect, but listed here so you know them)
    mappings = {
        add = "sa",        -- "sa" + textobject + char  (e.g., saw" to wrap word in quotes)
        delete = "sd",     -- "sd" + char (e.g., sd" to delete quotes)
        replace = "sr",    -- "sr" + old_char + new_char (e.g., sr") to swap ( ) for " ")
        find = "sf",       -- "sf" + char (find to the right)
        find_left = "sF",  -- "sF" + char (find to the left)
        highlight = "sh",  -- "sh" + char
        update_n_lines = "sn",

        suffix_last = "l", -- e.g., sdl) to delete using "last" method
        suffix_next = "n", -- e.g., sdn) to delete using "next" method
    },

    -- How many lines to look for a match
    n_lines = 20,

    -- How to search: 'cover', 'cover_or_next', 'next', etc.
    search_method = "cover",

    -- Duration of highlight when finding surrounding
    highlight_duration = 500,

    -- Custom surroundings (Example: Adding Lua long brackets [[ ]])
    -- This is the "trick" for bracket customization you asked for!
    custom_surroundings = {
        -- Lua long bracket: [[   ]]
        -- Input 'l' will trigger this.
        ["l"] = {
            -- The pattern to find the surrounding text
            -- %[%[ = [[ , .- = any text, %]%] = ]]
            input = { "%[%[.-%]%]" },
            output = {
                left = "[[",
                right = "]]",
            },
        },
        -- Example: Surround with space brackets: [ ]
        -- Use input 's' (space bracket)
        ["s"] = {
            input = { "%[ .- %]" }, -- Matches "[ text ]"
            output = {
                left = "[ ",
                right = " ]",
            },
        },
        -- Example: Markdown bold: ** text ** (No spaces inside)
        -- Use input 'b' (bold)
        ["b"] = {
            input = { "%*%*.-%*%*" },
            output = {
                left = "**",
                right = "**",
            },
        },
    },
})

