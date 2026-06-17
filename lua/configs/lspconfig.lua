require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", 'clangd', "basedpyright"}
vim.lsp.enable(servers)

-- LSP floating window configuration (wraps long text)
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.max_width = opts.max_width or 80
  opts.wrap = true
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Diagnostic configuration
vim.diagnostic.config({
  float = {
    wrap = true,
    max_width = 80,
  },
})

-- read :h vim.lsp.config for changing options of lsp servers 
