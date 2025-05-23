-- Keymaps are automatically loaded on the VeryLazy event
-- Basic Setup

-- tabs
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- lines
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- files
vim.opt.undofile = true

-- case handling
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- scrolling
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    local usable = vim.o.lines - vim.o.cmdheight - (vim.o.laststatus > 0 and 1 or 0)
    vim.o.scrolloff = math.floor(usable / 2)
  end,
})
vim.opt.cmdheight = 0

-- displaying characters
vim.opt.list = true
vim.opt.listchars = { tab = "--", trail = "-", nbsp = "-" }

-- key bindings

-- Next buffer & Previous buffer
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { noremap = true, silent = true })

-- Select all text in current buffer
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true })

-- Force closing everything, without saving
local function force_quit()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  vim.cmd("qa!")
end
vim.keymap.set({ "n", "i", "v", "x", "s", "o", "c", "t" }, "<A-q>", force_quit, { noremap = true, silent = true })
