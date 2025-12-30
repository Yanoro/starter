require "nvchad.mappings"
local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- 1. Disable the old default mapping
map("n", "<leader>/", "<Nop>", { desc = "Disabled default comment" })
map("v", "<leader>/", "<Nop>", { desc = "Disabled default comment" })

-- Visual Mode
map("v", "<leader>l", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", {
  desc = "Comment toggle"
})
