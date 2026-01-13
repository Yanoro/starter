require "nvchad.mappings"
local map = vim.keymap.set

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

 -- Custom function to move and preserve indentation from previous non-blank line
local function move_indent(direction)
  return function()
    -- Move 'j' (down) or 'k' (up)
    vim.cmd('normal! ' .. direction)

    -- Find the line number of the previous non-blank line
    local prev_line = vim.fn.prevnonblank(vim.fn.line('.'))

    -- If we found a valid line, move cursor to that indentation level
    if prev_line > 0 then
      local indent = vim.fn.indent(prev_line)
      -- 'virtcol' might be better if using tabs, but 'indent' is safer for spaces
      vim.fn.cursor(0, indent + 1) -- +1 because Lua is 1-indexed for columns often, but check

    end
  end
end

-- Map j and k
map("n", "j", move_indent("j"), { desc = "Move down and match indent" })
map("n", "k", move_indent("k"), { desc = "Move up and match indent" }) 
