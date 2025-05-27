return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      rust = { "rustfmt", lsp_format = "fallback" },
      go = { "goimports", "gofmt" },
      java = { "google-java-format" },
      sh = { "shfmt" },
      sql = { "sql-formatter" },
      yaml = { "yamlfmt" },
      asm = { "asmfmt" },
    },
    format_on_save = {
      timeout_ms = 250,
      lsp_format = "fallback",
    },
    formatexpr = true,
    formatters = {
      stylua = {
        prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
      },
      rustfmt = {
        prepend_args = { "--edition", "2021" },
      },
      shfmt = {
        prepend_args = { "-i", "2" },
      },
      yamlfmt = {
        prepend_args = { "--indent", "2" },
      },
      goimports = {
        prepend_args = {},
      },
      ["google-java-format"] = {
        prepend_args = { "--aosp" },
      },
      sql_formatter = {
        prepend_args = {},
      },
      asmfmt = {
        prepend_args = {},
      },
    },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
