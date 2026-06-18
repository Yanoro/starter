require "nvchad.autocmds"

local function open_gemini_layout(callback)

  local function attempt_layout(retries)
    local chad_win = nil
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.bo[buf].filetype
      local name = vim.api.nvim_buf_get_name(buf)
      -- Check for 'CHADTree' (observed), 'CHADtree', or 'chadtree' just in case
      if ft == "CHADTree" or ft == "CHADtree" or ft == "chadtree" or string.find(name, "chadtree://") then
        chad_win = win
        break
      end
    end

    if chad_win then
      vim.schedule(function()
        vim.cmd("Gemini toggle")
        -- Capture Gemini buffer (assuming it focuses on open)
        local gemini_buf = vim.api.nvim_get_current_buf()
        vim.cmd("close") -- Close the default Gemini window

        if vim.api.nvim_win_is_valid(chad_win) then
          vim.api.nvim_set_current_win(chad_win)
          vim.cmd("vertical resize 70")
          vim.cmd("split")
          vim.api.nvim_win_set_buf(0, gemini_buf)
          
          if callback then
            callback()
          end
        end
      end)
    elseif retries > 0 then
      vim.defer_fn(function() attempt_layout(retries - 1) end, 100)
    else
      print("GeminiLayout: Failed to detect CHADtree window.")
    end
  end

  attempt_layout(50) -- Wait up to 5 seconds
end

local function get_rightmost_non_terminal_window()
  local windows = vim.api.nvim_list_wins()
  local rightmost_win = nil
  local max_col = -1

  for _, win in ipairs(windows) do
    local bufnr = vim.api.nvim_win_get_buf(win)
    local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
    local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

    if buftype ~= "terminal" and ft ~= "CHADTree" and ft ~= "NvimTree" then
      local pos = vim.api.nvim_win_get_position(win)
      local col = pos[2]
      if col > max_col then
        max_col = col
        rightmost_win = win
      end
    end
  end
  return rightmost_win
end

-- Custom command to open Gemini CLI layout
vim.api.nvim_create_user_command("CodeEditingStart", function(opts)
  local args = opts.fargs
  local target_file = args[1]
  local worktree_dir = nil
  local context_start_idx = 2

  if #args > 1 then
    local stat = vim.loop.fs_stat(args[2])
    if stat and stat.type == "directory" then
      worktree_dir = args[2]
      context_start_idx = 3
    end
  end

  if worktree_dir then
    require("gemini_cli.api").toggle_terminal({ cwd = worktree_dir, args = { "-s" } })
  else
    vim.cmd("Gemini toggle")
  end

  vim.cmd("wincmd H")
  vim.cmd("vertical resize 70")
  vim.cmd("split")
  vim.cmd("enew")
  local ok, _ = pcall(vim.fn.termopen, "gemini --sandbox --yolo", { cwd = "../AIRogueAgent" })
  if not ok then
    vim.fn.termopen("gemini --sandbox --yolo")
  end
  vim.cmd("wincmd l")

  if target_file then
    vim.cmd("noswapfile e " .. target_file)
    vim.cmd("vsplit")
    vim.cmd("noswapfile e " .. target_file)
    vim.cmd("wincmd h")
  end

  -- Add remaining arguments as context to Gemini with robust polling
  if #args >= context_start_idx then
    local function add_context_files(retries)
      local found = false
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
         local name = vim.api.nvim_buf_get_name(buf)
         if name:match("gemini") and vim.bo[buf].buftype == "terminal" then
            found = true
            break
         end
      end

      if found then
         vim.defer_fn(function()
            for i = context_start_idx, #args do
              local context_path = args[i]
              vim.schedule(function()
                -- Use Lua API directly for better reliability
                pcall(function()
                  require("gemini_cli.api").add_file(context_path)
                end)
                print("Gemini Context: Added " .. context_path)
              end)
            end
         end, 10000)
      elseif retries > 0 then
         vim.defer_fn(function() add_context_files(retries - 1) end, 200)
      else
         print("Gemini Context: Failed to detect Gemini terminal.")
      end
    end

    add_context_files(50) -- Try for 10 seconds
  end

  -- Open a generic terminal below the rightmost code window
  local rightmost_code_win = get_rightmost_non_terminal_window()
  if rightmost_code_win then
    local original_win = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(rightmost_code_win)
    vim.cmd("split")
    local term_height = math.floor(vim.o.lines * 0.20)
    vim.cmd("resize " .. term_height)
    vim.cmd("terminal")
    -- and return to the original window
    vim.api.nvim_set_current_win(original_win)
  end
end, { nargs = '+' })

-- Custom command to open Gemini CLI in sidebar only
vim.api.nvim_create_user_command("GeminiSidebar", function()
  open_gemini_layout(nil)
end, {})

vim.api.nvim_create_user_command('EditConfig', function()
      open_gemini_layout(function ()
        vim.cmd("wincmd l") -- Return focus to main editor
        vim.cmd("vsplit")
        vim.cmd("noswapfile e configuration.nix")
        vim.cmd("wincmd h")
      end)end, {})

-- Prevent auto-insert mode and restore cursor position (fixes gemini-cli focus issue)
vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
  pattern = "term://*",
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.b.last_cursor = vim.api.nvim_win_get_cursor(0)
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "TermOpen" }, {
  pattern = "term://*",
  callback = function()
    local pos = vim.b.last_cursor
    vim.schedule(function()
      vim.cmd("stopinsert")
      if pos then
        -- Delay restoration slightly to ensure terminal focus logic has finished
        vim.defer_fn(function()
          pcall(vim.api.nvim_win_set_cursor, 0, pos)
        end, 15)
      end
    end)
  end,
})

-- Fix conflict: Remove default LSP <leader>wr mapping so global Resize Mode works
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    vim.schedule(function()
      pcall(vim.keymap.del, "n", "<leader>wr", { buffer = bufnr })
    end)
  end,
})

