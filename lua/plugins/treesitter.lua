return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      ensure_installed = {
        "asm",
        "nasm",
        "c",
        "lua",
        "vim",
        "bash",
        "go",
        "rust",
        "python",
        "dockerfile",
        "xml",
        "yaml",
        "json",
      },
      auto_install = false,
      sync_install = true,
      highlight = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<Enter>",
          node_incremental = "<Enter>",
          scope_incremental = false,
          node_decremental = "<Backspace>",
        },
      },
    })
  end,
}
