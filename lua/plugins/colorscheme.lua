return {
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({
        options = {
          transparent = true,
          terminal_colors = false,
          styles = {
            comments = "italic",
            functions = "bold",
            keywords = "bold,italic",
            variables = "NONE",
            conditionals = "bold",
            constants = "bold",
            numbers = "italic",
            operators = "NONE",
            strings = "italic",
            types = "bold",
          },
        },
      })
      vim.cmd("colorscheme github_dark_high_contrast")
    end,
  },
}
