-- Additional configuration for Java file type
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    -- Java-specific settings
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = true
    vim.opt_local.textwidth = 120

    -- Additional Java-specific keymaps that don't require LSP
    local opts = { buffer = true, silent = true }

    -- Quick compilation (if you have javac available)
    vim.keymap.set("n", "<leader>jC", function()
      local file = vim.fn.expand("%")
      vim.cmd("!" .. "javac " .. file)
    end, vim.tbl_extend("force", opts, { desc = "Java: Compile current file" }))

    -- Run main class (basic runner)
    vim.keymap.set("n", "<leader>jr", function()
      local file = vim.fn.expand("%:t:r") -- filename without extension
      vim.cmd("!" .. "java " .. file)
    end, vim.tbl_extend("force", opts, { desc = "Java: Run current file" }))
  end,
})
