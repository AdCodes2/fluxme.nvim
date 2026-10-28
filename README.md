# fluxme.nvim

A tiny Neovim plugin that shows a centered popup with a message.

## Installation (Packer)

```lua
use {
  "YOUR_USERNAME/fluxme.nvim",
  config = function()
    require("fluxme").setup({
      message = "Hello from FluxMe!",
      timeout = 4000,
    })
  end,
}
