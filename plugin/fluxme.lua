-- This file is automatically loaded by Neovim/Packer
-- It creates the :FluxMeNow user command

vim.api.nvim_create_user_command("FluxMeNow", function(opts)
  local msg = nil
  if opts.args and opts.args ~= "" then
    msg = opts.args
  end
  require("fluxme").show(msg)
end, {
  nargs = "?",           -- optional argument
  desc = "Show the FluxMe popup with an optional message",
})
