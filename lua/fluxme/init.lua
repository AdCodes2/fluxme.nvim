local M = {}

-- Default configuration
M.config = {
  message = "Flux me now!",
  width = 32,
  height = 5,
  border = "rounded",      -- "none", "single", "double", "rounded", "solid", "shadow"
  timeout = 3000,          -- milliseconds. Set to 0 to keep open until you press a key
  focusable = true,
}

-- Allow the user to override defaults
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- The function that actually shows the popup
function M.show(custom_message)
  local message = custom_message or M.config.message

  -- Support multi-line messages
  local lines = vim.split(message, "\n", { plain = true })

  -- Create a temporary scratch buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Make the buffer non-modifiable and wipe it when closed
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })

  -- Calculate window size (at least as wide as the message)
  local content_width = 0
  for _, line in ipairs(lines) do
    content_width = math.max(content_width, #line)
  end
  local width = math.max(M.config.width, content_width + 4)
  local height = math.max(M.config.height, #lines + 2)

  -- Center the window on the editor
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = M.config.border,
    focusable = M.config.focusable,
    zindex = 50,
  }

  -- Open the floating window and focus it
  local win = vim.api.nvim_open_win(buf, true, win_opts)

  -- Close the popup when the user presses Esc, Enter, or q
  local close_keys = { "<Esc>", "<CR>", "q", "<C-c>" }
  for _, key in ipairs(close_keys) do
    vim.keymap.set("n", key, function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end, { buffer = buf, silent = true, nowait = true })
  end

  -- Optional: auto-close after timeout
  if M.config.timeout and M.config.timeout > 0 then
    vim.defer_fn(function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end, M.config.timeout)
  end
end

return M
