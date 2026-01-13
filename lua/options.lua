require 'nvchad.options'
vim.opt.shiftround = true
vim.opt.number = true
vim.keymap.set("x", "<", "<gv", { noremap = true, silent = true })
vim.keymap.set("x", ">", ">gv", { noremap = true, silent = true })
vim.opt.backspace = "indent,eol,start"

-- Allow identation logic to work
vim.o.virtualedit = "all"
