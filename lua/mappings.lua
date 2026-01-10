require "nvchad.mappings"
local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- 0. Disable the old default mapping
map("n", "<leader>/", "<Nop>", { desc = "Disabled default comment" })
map("v", "<leader>/", "<Nop>", { desc = "Disabled default comment" })

-- Visual Mode
map("v", "<leader>l", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", {
  desc = "Comment toggle"
})

-- CMake-Tools
map("n", "<leader>cg", "<cmd>CMakeGenerate<cr>", { desc = "CMake Generate" })
map("n", "<leader>cb", "<cmd>CMakeBuild<cr>", { desc = "CMake Build" })
map("n", "<leader>cr", "<cmd>CMakeRun<cr>", { desc = "CMake Run" })

-- Compiler.nvim
map("n", "<leader>co", "<cmd>CompilerOpen<cr>", { desc = "Open Compiler" })
map("n", "<leader>cr", "<cmd>CompilerRedo<cr>", { desc = "Redo Last Task" })
map("n", "<leader>ct", "<cmd>CompilerToggleResults<cr>", { desc = "Toggle Results" })


