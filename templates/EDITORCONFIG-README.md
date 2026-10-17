# EditorConfig template helper

Maintain templates/editorconfig.template in your Neovim config. :EditEditorConfigTemplate opens that exact file; save it before generating a project config.

:MakeEditorConfig copies the current saved template to .editorconfig in the detected root. Detection starts at the current normal file (or cwd for unnamed/special buffers). It prefers a Git/Mercurial repository root, then the closest project manifest/.editorconfig marker. Without markers it uses cwd when that contains the file, otherwise the file's directory.

:MakeEditorConfig E:/Projects/my-project overrides root detection. A path containing spaces can be passed as the single remainder of the command, without surrounding quotes. The destination directory must already exist.

Existing .editorconfig files, directories and symlinks are preserved. There is no force overwrite. Edit an existing file manually when needed. A generated config is a separate copy; later master-template changes do not modify old projects. Reopen source buffers after creation to let Neovim read the new EditorConfig.

The default is 2 spaces, Python/PowerShell 4 spaces, Makefile tabs. Adjust the master template as desired. Formatter-specific configurations such as .prettierrc.json or pyproject.toml can override their own formatting behavior; this command creates only .editorconfig, not those files.

All files are additive, with no changes to your current package list or settings. The plugin/so-editorconfig.lua file automatically registers the commands at startup.
