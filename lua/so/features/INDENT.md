# Native indent guides

Uses only Neovim's listchars: leadmultispace for leading spaces and tab for tab characters. The guide character is │. Leading-space spacing follows the buffer's shiftwidth; shiftwidth=0 uses tabstop. Other list characters are preserved.

Guides are enabled by default. :SoIndentToggle switches them on/off and restores the affected window's previous tab/leading-space display. To disable by default, put `vim.g.so_indent_guides = false` in init.lua. Configure your indentation with shiftwidth and tabstop as before; the guides only change display, never file contents.

The native method shows existing indentation, including tab markers outside leading whitespace. It does not infer a block scope, extend guides across empty lines, or draw guides in whitespace that is absent. It uses the theme's Whitespace highlight. Special buffers such as terminals and help are excluded.

This patch removes the indent-blankline package URL, startup require, and old placeholder settings file. Fully restart Neovim, then run `:lua vim.pack.del({ "indent-blankline.nvim" })` once to remove its inactive checkout and lockfile entry. Do not use force or remove unrelated packages.

Local feature: lua/so/features/indent.lua. Automatic loader: plugin/so-native-indent.lua.
