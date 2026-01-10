require "nvchad.autocmds"

-- Custom command to open Gemini CLI layout
vim.api.nvim_create_user_command("GeminiStart", function()
  vim.cmd('NvimTreeToggle')
  vim.cmd("Gemini toggle")
  vim.cmd("wincmd L")
  vim.defer_fn(function()
    vim.cmd("vertical resize 100")
    vim.cmd("wincmd h")
    end, 1)
  vim.cmd("belowright 10split | terminal")
end, {})

vim.api.nvim_create_user_command('EditConfig', function()
  vim.cmd('tabnew')
  vim.cmd('tcd ~/nixos')
  vim.cmd("noswapfile edit ./configuration.nix")
  vim.cmd("noswapfile edit ./home.nix")
  vim.cmd('GeminiStart')
end, {})

