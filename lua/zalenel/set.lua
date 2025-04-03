-- Leader sets
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.have_nerd_font = true
vim.opt.showmode = false

-- Line Numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Set Tab Size
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Paste History
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undordir"
vim.opt.undofile = true
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Search Highlight
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true

-- Control splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Colors
vim.opt.termguicolors = true

-- Font
vim.g.have_nerd_font = true

-- Scroll control
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Update time
vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

-- Auto commands
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("kickstart-hightlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
