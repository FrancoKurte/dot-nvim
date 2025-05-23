-- Smart buffer switching with Alt + number keys (Silent Version)
-- Maps Alt+1 through Alt+9 to switch to the 1st through 9th listed buffer
-- Alt+0 switches to the 10th buffer (if it exists)

local function get_listed_buffers()
  local buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    -- Only include listed buffers (excludes help, quickfix, etc.)
    if vim.api.nvim_buf_get_option(buf, "buflisted") then
      table.insert(buffers, buf)
    end
  end

  -- Sort buffers by buffer number to maintain consistent ordering
  table.sort(buffers)
  return buffers
end

local function switch_to_buffer_by_position(position)
  local buffers = get_listed_buffers()

  -- If no buffers, or position is out of bounds, silently do nothing.
  if #buffers == 0 or position <= 0 or position > #buffers then
    return
  end

  local target_buf = buffers[position]

  -- Check if buffer is still valid and loaded, then switch. Otherwise, do nothing.
  if vim.api.nvim_buf_is_valid(target_buf) then
    vim.api.nvim_set_current_buf(target_buf)
  end
  -- If buffer not valid or other conditions not met, exits silently.
end

-- Shows a buffer picker when Alt+` is pressed
local function show_buffer_picker()
  local buffers = get_listed_buffers()

  if #buffers == 0 then
    return -- Silently return if no buffers to show
  end

  -- These print statements are the core functionality of the picker
  print("Available buffers:")
  for i, buf in ipairs(buffers) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    local display_name = buf_name == "" and "[No Name]" or vim.fn.fnamemodify(buf_name, ":t")
    local current_marker = buf == vim.api.nvim_get_current_buf() and " (current)" or ""
    print(string.format("  %d: [%d] %s%s", i, buf, display_name, current_marker))
  end
  print("\nPress Alt+<number> to switch to that buffer")
end

-- Set up the keymaps for Alt+1 through Alt+9
for i = 1, 9 do
  vim.keymap.set("n", "<A-" .. i .. ">", function()
    switch_to_buffer_by_position(i)
  end, {
    noremap = true,
    silent = true, -- Ensures the mapping itself is silent
    desc = "Switch to " .. i .. "th buffer in list",
  })
end

-- Alt+0 switches to the 10th buffer
vim.keymap.set("n", "<A-0>", function()
  switch_to_buffer_by_position(10)
end, {
  noremap = true,
  silent = true, -- Ensures the mapping itself is silent
  desc = "Switch to 10th buffer in list",
})

-- Bonus: Alt+` shows the buffer picker
vim.keymap.set("n", "<A-`>", show_buffer_picker, {
  noremap = true,
  silent = true, -- Function handles its own printing, mapping is silent
  desc = "Show numbered buffer list",
})

-- Optional: Add a command to show the current buffer mapping
vim.api.nvim_create_user_command("BufferList", function()
  local buffers = get_listed_buffers()

  if #buffers == 0 then
    return -- Silently return if no buffers to list
  end

  -- These print statements are the core functionality of the command
  print("Buffer mappings (Alt+<number>):")
  for i, buf in ipairs(buffers) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    local display_name = buf_name == "" and "[No Name]" or vim.fn.fnamemodify(buf_name, ":t")
    local current_marker = buf == vim.api.nvim_get_current_buf() and " (current)" or ""
    local key = i <= 9 and i or (i == 10 and "0" or "none") -- 'none' for >10 is fine
    print(string.format("  Alt+%s: [%d] %s%s", key, buf, display_name, current_marker))
  end
end, { desc = "Show current buffer mappings" })

-- Debug function to understand your buffer situation
-- This function's purpose is to print debug info, so its print statements remain.
vim.api.nvim_create_user_command("BufferDebug", function()
  print("=== Buffer Debug Info ===")
  print("All buffers:")
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    local display_name = buf_name == "" and "[No Name]" or buf_name
    local listed = vim.api.nvim_buf_get_option(buf, "buflisted")
    local loaded = vim.api.nvim_buf_is_loaded(buf)
    local current = buf == vim.api.nvim_get_current_buf()

    print(string.format("  [%d] %s - listed: %s, loaded: %s, current: %s", buf, display_name, listed, loaded, current))
  end

  print("\nListed buffers only:")
  local listed_buffers = get_listed_buffers()
  if #listed_buffers == 0 then
    print("  (No listed buffers)") -- Clarifies if this section is empty
    -- No return needed here, loop below won't run
  end
  for i, buf in ipairs(listed_buffers) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    local display_name = buf_name == "" and "[No Name]" or vim.fn.fnamemodify(buf_name, ":t")
    local current = buf == vim.api.nvim_get_current_buf()
    print(string.format("  %d: [%d] %s%s", i, buf, display_name, current and " (current)" or ""))
  end
end, { desc = "Debug buffer information" })
