-- Basic Setup
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.cmdheight = 0
vim.opt.list = true
vim.opt.listchars = { tab = "--", trail = "-", nbsp = "-" }

-- Buffer navigation
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { silent = true })
vim.keymap.set("n", "<C-a>", "ggVG", { silent = true })

-- Terminal
vim.keymap.set("n", "<leader>ft", function()
  Snacks.terminal(nil, { win = { position = "right", width = 0.25 } })
end, { desc = "Right terminal" })

-- Force quit
local function force_quit()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  vim.cmd("qa!")
end
vim.keymap.set({ "n", "i", "v", "x", "s", "o", "c", "t" }, "<C-z>", force_quit, { silent = true })

-- Diagnostics
vim.keymap.set("n", "gl", function()
  vim.diagnostic.open_float({
    focusable = true,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    border = "rounded",
    source = "always",
    prefix = " ",
    scope = "cursor",
  })
end, { desc = "Show diagnostic" })

vim.keymap.set("n", "[d", function()
  vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.HINT } })
end, { desc = "Previous diagnostic" })

vim.keymap.set("n", "]d", function()
  vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.HINT } })
end, { desc = "Next diagnostic" })

vim.keymap.set("n", "[e", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Previous error" })

vim.keymap.set("n", "]e", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next error" })

vim.keymap.set("n", "[w", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
end, { desc = "Previous warning" })

vim.keymap.set("n", "]w", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
end, { desc = "Next warning" })

-- Diagnostic lists
vim.keymap.set("n", "<leader>dl", function()
  vim.diagnostic.setloclist({ open = true })
end, { desc = "Location list" })

vim.keymap.set("n", "<leader>dq", function()
  vim.diagnostic.setqflist({ open = true })
end, { desc = "Quickfix list" })

vim.keymap.set("n", "<leader>db", function()
  vim.diagnostic.setloclist({ open = true, title = "Buffer Diagnostics" })
end, { desc = "Buffer diagnostics" })

vim.keymap.set("n", "<leader>de", function()
  vim.diagnostic.setloclist({
    severity = vim.diagnostic.severity.ERROR,
    open = true,
    title = "Errors Only",
  })
end, { desc = "Errors only" })

vim.keymap.set("n", "<leader>dw", function()
  vim.diagnostic.setloclist({
    severity = { min = vim.diagnostic.severity.WARN },
    open = true,
    title = "Warnings and Errors",
  })
end, { desc = "Warnings and errors" })

vim.keymap.set("n", "<leader>dt", function()
  local enabled = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not enabled)
  vim.notify(string.format("Diagnostics %s", enabled and "disabled" or "enabled"))
end, { desc = "Toggle diagnostics" })

-- Code actions & refactoring
vim.keymap.set("n", "<leader>ra", vim.lsp.buf.code_action, { desc = "Code actions" })
vim.keymap.set("v", "<leader>ra", vim.lsp.buf.code_action, { desc = "Code actions" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })

-- Quick fixes
vim.keymap.set("n", "<leader>qf", function()
  vim.diagnostic.open_float({ focusable = true })
end, { desc = "Quick fix" })

vim.keymap.set("n", "<leader>qa", function()
  vim.lsp.buf.code_action({
    filter = function(action)
      return action.isPreferred or string.match(action.title:lower(), "fix")
    end,
    apply = true,
  })
end, { desc = "Auto fix" })

-- Code formatting
vim.keymap.set("n", "<leader>cf", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format code" })

vim.keymap.set("v", "<leader>cf", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format selection" })

vim.keymap.set("n", "<leader>f", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer" })

-- Navigation
vim.keymap.set("n", "<leader>cs", vim.lsp.buf.document_symbol, { desc = "Document symbols" })
vim.keymap.set("n", "<leader>ci", vim.lsp.buf.incoming_calls, { desc = "Incoming calls" })
vim.keymap.set("n", "<leader>co", vim.lsp.buf.outgoing_calls, { desc = "Outgoing calls" })
vim.keymap.set("n", "<leader>ck", vim.lsp.buf.signature_help, { desc = "Signature help" })

vim.keymap.set("n", "<leader>ct", function()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, "textDocument/typeDefinition", params, function(err, result)
    if err or not result or vim.tbl_isempty(result) then
      vim.notify("No type definition found", vim.log.levels.INFO)
      return
    end
    vim.lsp.util.preview_location(result[1], { border = "rounded" })
  end)
end, { desc = "Type definition preview" })

-- Completion
vim.keymap.set("i", "<C-Space>", function()
  require("blink.cmp").show()
end, { desc = "Trigger completion" })

-- LSP management
vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP info" })
vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "LSP restart" })
vim.keymap.set("n", "<leader>ls", "<cmd>LspStart<cr>", { desc = "LSP start" })
vim.keymap.set("n", "<leader>lS", "<cmd>LspStop<cr>", { desc = "LSP stop" })

-- Mason
vim.keymap.set("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })
vim.keymap.set("n", "<leader>cM", "<cmd>MasonUpdate<cr>", { desc = "Mason update" })

-- Workspace management
vim.keymap.set("n", "<leader>wc", function()
  vim.diagnostic.reset()
  vim.notify("Workspace diagnostics cleared")
end, { desc = "Clear diagnostics" })

vim.keymap.set("n", "<leader>wR", function()
  vim.cmd("LspRestart")
  vim.notify("All LSP clients restarted")
end, { desc = "Restart LSP" })

-- Toggles
vim.keymap.set("n", "<leader>tf", function()
  vim.g.auto_format = not vim.g.auto_format
  vim.notify(string.format("Auto-format on save: %s", vim.g.auto_format and "enabled" or "disabled"))
end, { desc = "Toggle format on save" })

-- Language-specific keymaps
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    local buf = vim.api.nvim_get_current_buf()

    vim.keymap.set("n", "<leader>gi", function()
      vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" } },
        apply = true,
      })
    end, { buffer = buf, desc = "Organize imports" })

    vim.keymap.set("n", "<leader>gf", function()
      vim.lsp.buf.code_action({
        context = { only = { "refactor.rewrite" } },
        apply = true,
      })
    end, { buffer = buf, desc = "Fill struct" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    local buf = vim.api.nvim_get_current_buf()

    vim.keymap.set("n", "<leader>rm", function()
      vim.lsp.buf.code_action({
        context = { only = { "rust-analyzer.expandMacro" } },
        apply = true,
      })
    end, { buffer = buf, desc = "Expand macro" })

    vim.keymap.set("n", "<leader>rp", function()
      vim.lsp.buf.code_action({
        context = { only = { "rust-analyzer.parentModule" } },
        apply = true,
      })
    end, { buffer = buf, desc = "Parent module" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    vim.keymap.set(
      "n",
      "<leader>ch",
      "<cmd>ClangdSwitchSourceHeader<cr>",
      { buffer = buf, desc = "Switch header/source" }
    )
  end,
})

-- Debug utilities
vim.keymap.set("n", "<leader>lD", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local diagnostics = vim.diagnostic.get(0)

  print("=== LSP Debug Info ===")
  print("Buffer:", vim.api.nvim_buf_get_name(0))
  print("Filetype:", vim.bo.filetype)
  print("LSP Clients:", #clients)

  for i, client in ipairs(clients) do
    print(string.format("  %d. %s (id: %d)", i, client.name, client.id))
  end

  print("Diagnostics count:", #diagnostics)
  for i, diag in ipairs(diagnostics) do
    local severity_names = { [1] = "ERROR", [2] = "WARN", [3] = "INFO", [4] = "HINT" }
    print(string.format("  %d. [%s] Line %d: %s", i, severity_names[diag.severity], diag.lnum + 1, diag.message))
  end

  print("Diagnostic config:")
  print(vim.inspect(vim.diagnostic.config()))
end, { desc = "LSP debug info" })

vim.keymap.set("n", "<leader>lR", function()
  vim.diagnostic.reset()
  vim.cmd("edit")
  vim.notify("LSP diagnostics refreshed")
end, { desc = "Refresh diagnostics" })

vim.keymap.set("n", "<leader>ll", function()
  vim.cmd.edit(vim.lsp.get_log_path())
end, { desc = "Show LSP log" })

vim.keymap.set("n", "<leader>lC", function()
  vim.diagnostic.reset()
  vim.notify("All diagnostics cleared")
end, { desc = "Clear all diagnostics" })
