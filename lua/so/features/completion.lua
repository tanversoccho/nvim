local M = {}

function M.setup()
  -- Native word completion plus the buffer's omnifunc (LSP where available).
  vim.opt.autocomplete = true
  vim.opt.complete = { ".", "w", "b", "u", "o" }
  vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }

  local function attach(client, buf)
    if client and client:supports_method("textDocument/completion", buf) then
      vim.bo[buf].omnifunc = "v:lua.vim.lsp.omnifunc"
      -- Core autocomplete handles normal words; LSP also reacts to server trigger
      -- characters, such as '.'; native completion applies snippets/import edits.
      vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
    end
  end
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("so-native-completion", { clear = true }),
    callback = function(args)
      attach(vim.lsp.get_client_by_id(args.data.client_id), args.buf)
    end,
  })
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do attach(client, buf) end
  end

  local function jump(direction)
    if vim.snippet.active({ direction = direction }) then
      -- Snippet jumps modify text/selection; defer outside expression-map textlock.
      vim.schedule(function() vim.snippet.jump(direction) end)
      return true
    end
    return false
  end
  vim.keymap.set({ "i", "s" }, "<Tab>", function()
    if vim.fn.pumvisible() == 1 then
      -- With noselect, choose the first entry before accepting it.
      return vim.fn.complete_info({ "selected" }).selected == -1 and "<C-n><C-y>" or "<C-y>"
    end
    if jump(1) then return "" end
    return "<Tab>"
  end, { expr = true, desc = "Accept completion / next native snippet field / Tab" })
  vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
    if vim.fn.pumvisible() == 1 then return "<C-p>" end
    if jump(-1) then return "" end
    return "<S-Tab>"
  end, { expr = true, desc = "Previous completion / native snippet field" })
  vim.keymap.set("i", "<C-Space>", function()
    vim.lsp.completion.get()
  end, { desc = "Request native LSP completion" })

  -- Removing declarations prevents activation; this command removes the old
  -- managed checkouts and lockfile entries after a fresh restart.
  local retired = {
    ["blink.cmp"] = true, ["nvim-cmp"] = true, ["cmp-nvim-lsp"] = true,
    ["cmp-buffer"] = true, ["cmp-path"] = true, ["cmp-cmdline"] = true,
    ["cmp_luasnip"] = true, ["LuaSnip"] = true, ["friendly-snippets"] = true,
    ["lazydev.nvim"] = true, ["vim-dadbod-completion"] = true,
  }
  vim.api.nvim_create_user_command("SoCompletionClean", function()
    local names = {}
    for _, plugin in ipairs(vim.pack.get(nil, { info = false })) do
      if retired[plugin.spec.name] then
        if plugin.active then
          vim.notify("Restart Neovim before cleaning active completion plugin: " .. plugin.spec.name,
            vim.log.levels.WARN)
          return
        end
        table.insert(names, plugin.spec.name)
      end
    end
    if #names == 0 then vim.notify("No retired completion plugins remain."); return end
    vim.pack.del(names)
    vim.notify("Removed completion plugins: " .. table.concat(names, ", "))
  end, { desc = "Remove retired completion plugins from vim.pack" })
end
return M
