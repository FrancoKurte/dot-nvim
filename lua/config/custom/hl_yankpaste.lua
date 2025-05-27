-- loaded by lazy.lua after loading lazy
-- colors for highlighting (yanked and pasted)
vim.api.nvim_set_hl(0, "YankHighlight", {
  fg = "#000000",
  bg = "#FFFF88",
  blend = 70,
})

vim.api.nvim_set_hl(0, "PasteHighlight", {
  fg = "#000000",
  bg = "#88FF88",
  blend = 85,
})

-- temporary highlight for yanked text
vim.api.nvim_create_augroup("HighlightYank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = "HighlightYank",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "YankHighlight",
      timeout = 500,
    })
  end,
})

-- Create namespace for paste highlighting
local paste_ns = vim.api.nvim_create_namespace("paste_highlight")

-- Function to highlight pasted text
local function highlight_paste()
  -- Get the marks for the last pasted text
  local start_pos = vim.api.nvim_buf_get_mark(0, "[")
  local end_pos = vim.api.nvim_buf_get_mark(0, "]")

  -- Ensure we have valid positions
  if start_pos[1] == 0 or end_pos[1] == 0 then
    return
  end

  -- Clear any existing highlights in our namespace
  vim.api.nvim_buf_clear_namespace(0, paste_ns, 0, -1)

  -- Convert to 0-based indexing for the API
  local start_row = start_pos[1] - 1
  local start_col = start_pos[2]
  local end_row = end_pos[1] - 1
  local end_col = end_pos[2] + 1

  -- Handle single line vs multi-line paste
  if start_row == end_row then
    -- Single line paste
    vim.api.nvim_buf_add_highlight(0, paste_ns, "PasteHighlight", start_row, start_col, end_col)
  else
    -- Multi-line paste
    -- Highlight from start position to end of first line
    local first_line_end = vim.api.nvim_buf_get_lines(0, start_row, start_row + 1, false)[1]:len()
    vim.api.nvim_buf_add_highlight(0, paste_ns, "PasteHighlight", start_row, start_col, first_line_end)

    -- Highlight complete middle lines
    for row = start_row + 1, end_row - 1 do
      vim.api.nvim_buf_add_highlight(0, paste_ns, "PasteHighlight", row, 0, -1)
    end

    -- Highlight from start of last line to end position
    vim.api.nvim_buf_add_highlight(0, paste_ns, "PasteHighlight", end_row, 0, end_col)
  end

  -- Clear the highlight after timeout
  vim.defer_fn(function()
    vim.api.nvim_buf_clear_namespace(0, paste_ns, 0, -1)
  end, 500)
end

-- Remap paste commands to include highlighting
vim.keymap.set("n", "p", function()
  vim.cmd("normal! p")
  vim.schedule(highlight_paste)
end, { noremap = true, silent = true, desc = "Paste after cursor with highlight" })

vim.keymap.set("n", "P", function()
  vim.cmd("normal! P")
  vim.schedule(highlight_paste)
end, { noremap = true, silent = true, desc = "Paste before cursor with highlight" })

-- Also handle visual mode paste
vim.keymap.set("x", "p", function()
  vim.cmd("normal! p")
  vim.schedule(highlight_paste)
end, { noremap = true, silent = true, desc = "Paste in visual mode with highlight" })

vim.keymap.set("x", "P", function()
  vim.cmd("normal! P")
  vim.schedule(highlight_paste)
end, { noremap = true, silent = true, desc = "Paste in visual mode with highlight" })
