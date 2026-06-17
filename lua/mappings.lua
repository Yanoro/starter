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

-- LSP Mappings
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
map("n", "<leader>fs", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Find Workspace Symbols" })
map("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Find Document Symbols" })
map("n", "<leader>ss", function()
  local params = { uri = vim.uri_from_bufnr(0) }
  vim.lsp.buf_request(0, "textDocument/switchSourceHeader", params, function(err, result)
    if err then return print("Error: " .. tostring(err)) end
    if not result then return print("Corresponding file not found") end
    vim.cmd.edit(vim.uri_to_fname(result))
  end)
end, { desc = "Switch Source/Header" })

map("n", "<leader>ci", function()
  vim.lsp.buf.code_action({
    apply = true,
    filter = function(action)
      local title = action.title:lower()
      return title:find("create implementation") or title:find("definition") or title:find("out%-of%-line")
    end,
  })
end, { desc = "Create Implementation" })

-- nvim-treesitter-cpp-tools
map({ "n", "v" }, "<leader>gn", "<cmd>TSCppDefineClassFunc<cr>", { desc = "Generate Implementation" })

-- Smear Cursor
map("n", "<leader>sc", function() require("smear_cursor").toggle() end, { desc = "Toggle Smear Cursor" })




-- Disable increment/decrement
map("n", "<C-a>", "<Nop>", { desc = "Disabled increment" })
map("n", "<C-x>", "<Nop>", { desc = "Disabled decrement" })

-- Remap conflicting LSP command
map("n", "<leader>wR", function() vim.lsp.buf.remove_workspace_folder() end, { desc = "Remove workspace folder" })

-- Interactive Resize Mode
map("n", "<leader>wr", function()
  print("Resize Mode: h/j/k/l or Arrows to resize. q/Esc to exit.")
  
  local opts = { buffer = 0, nowait = true }
  local set = vim.keymap.set
  local del = vim.keymap.del
  
  -- Resize logic
  set("n", "h", "<cmd>vertical resize +5<CR>", opts)
  set("n", "l", "<cmd>vertical resize -5<CR>", opts)
  set("n", "k", "<cmd>resize -5<CR>", opts)
  set("n", "j", "<cmd>resize +5<CR>", opts)
  set("n", "<Left>", "<cmd>vertical resize -5<CR>", opts)
  set("n", "<Right>", "<cmd>vertical resize +5<CR>", opts)
  set("n", "<Up>", "<cmd>resize -5<CR>", opts)
  set("n", "<Down>", "<cmd>resize +5<CR>", opts)

  -- Exit logic
  local function exit()
    local keys = { "h", "l", "k", "j", "<Left>", "<Right>", "<Up>", "<Down>", "q", "<Esc>" }
    for _, k in ipairs(keys) do
      pcall(del, "n", k, { buffer = 0 })
    end
    print("Exited Resize Mode")
  end

  set("n", "q", exit, opts)
  set("n", "<Esc>", exit, opts)
end, { desc = "Enter Interactive Resize Mode" })

-- Toggle between Implementation and Definition
map("n", "<leader>gd", function()
  local params = vim.lsp.util.make_position_params()
  
  vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result, ctx, config)
    if err then vim.notify("LSP Error: " .. tostring(err)) return end
    
    -- Result can be Location or Location[] or LocationLink[]
    if not result or vim.tbl_isempty(result) then
      -- If no definition found, try declaration
      vim.lsp.buf.declaration()
      return
    end

    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local offset_encoding = client and client.offset_encoding or "utf-16"

    local def_location = result
    if vim.islist(result) then def_location = result[1] end
    
    local def_uri
    local def_range
    
    if def_location.targetUri then -- LocationLink
       def_uri = def_location.targetUri
       def_range = def_location.targetRange
    else -- Location
       def_uri = def_location.uri
       def_range = def_location.range
    end
    
    local current_buf = vim.api.nvim_get_current_buf()
    local current_cursor = vim.api.nvim_win_get_cursor(0)
    local current_line = current_cursor[1] - 1 -- 0-based
    
    local def_buf = vim.uri_to_bufnr(def_uri)
    
    -- Check if definition is effectively current position
    local is_same_file = (def_buf == current_buf)
    local is_same_line = (math.abs(def_range.start.line - current_line) <= 1)
    
    if is_same_file and is_same_line then
       -- We are already at definition. Jump to Declaration.
       vim.lsp.buf.declaration()
    else
       -- Jump to definition
       vim.lsp.util.jump_to_location(def_location, offset_encoding)
    end
  end)
end, { desc = "Toggle Impl/Def" })

-- Menu mappings
map("n", "<C-t>", function()
  require("menu").open("default")
end, { desc = "Open Menu" })

map({ "n", "v" }, "<RightMouse>", function()
  require('menu.utils').delete_old_menus()

  vim.cmd.exec '"normal! \\<RightMouse>"'

  local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
  local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

  require("menu").open(options, { mouse = true })
end, { desc = "Open Menu (Mouse)" })
