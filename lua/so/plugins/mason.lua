require("mason").setup({
  PATH = "prepend",
  max_concurrent_installers = 2,
})

-- Configure the installer only after Mason. require() caches the module,
-- so the existing plugins/init.lua entry will not configure it twice.
require("so.plugins.mason-tool-installer")
