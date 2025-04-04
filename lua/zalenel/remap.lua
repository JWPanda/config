local builtin = require("telescope.builtin")
local harpoon = require("harpoon")
local telescope = require("telescope.builtin")
local which_key = require("which-key")

vim.keymap.set("n", "<leader>ef", vim.cmd.Ex, { desc = "Vim escape file" })
vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end, { desc = "Shout out the current buffer" })

-- Move stuff
vim.keymap.set("v", "J", ":m  '>+1<CR>gv=gv", { desc = "Move hightlighted text down" })
vim.keymap.set("v", "K", ":m  '<-2<CR>gv=gv", { desc = "Move hightlighted text up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half screen jump down and centre cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half screen jump up and centre cursor" })
vim.keymap.set("n", "n", "nzzzv", { desc = "goto next search tearm with centre cursor" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "goto previous search tearm with centre cursor" })
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')
-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Editing
vim.keymap.set("n", "J", "mzJ`z", { desc = "Append next line to current without moving cursor" })
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "paste without removing current paste buffer" })
vim.keymap.set("n", "<leader>y", '"+y', { desc = "yank into system clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "yank into system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "yank line into system clipboard" })
vim.keymap.set("v", "<leader>d", '"_d')
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Find and replace current word" }
)

-- save file
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Keybinding to toggle diagnostics (id)
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- Window Management

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-------------
-- Plugins --
-------------

-- Trouble
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set(
  "n",
  "<leader>xX",
  "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
  { desc = "Buffer Diagnostics (Trouble)" }
)
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
vim.keymap.set(
  "n",
  "<leader>cl",
  "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
  { desc = "LSP Definitions / references / ... (Trouble)" }
)
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

-- Tmux
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

--UndoTree Plugin
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "UndotreeToggle" })

--Fugitive
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Fugitive git" })

-- Neotree
vim.keymap.set("n", "<C-t>", ":Neotree filesystem reveal left<CR>", { desc = "Neotree file systme rever" })

-- LSP
local lsp_cmds = vim.api.nvim_create_augroup("lsp_cmds", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_cmds,
  desc = "LSP actions",
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { buffer = true, remap = false })
    end

    bufmap("n", "D", "<cmd>lua vim.lsp.buf.hover()<cr>")
    bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
    bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
    bufmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>")
    bufmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
    bufmap("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
    bufmap("n", "<leader>rr", "<cmd>lua vim.lsp.buf.references()<cr>")
    bufmap("n", "<leader>rh", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
    bufmap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>")
    bufmap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>")
    bufmap("n", "<leader>cf", "<cmd>lua vim.lsp.buf.format()<cr>")
    bufmap("n", "<leader>ve", "<cmd>lua vim.diagnostic.open_float()<cr>")
    bufmap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
    bufmap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")
  end,
})

--Telescope
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>/", function()
  -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  telescope.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>s/", function()
  telescope.live_grep({
    grep_open_files = true,
    prompt_title = "Live Grep in Open Files",
  })
end, { desc = "[S]earch [/] in Open Files" })

vim.keymap.set("n", "<leader>sn", function()
  telescope.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })

-- Which-key
vim.keymap.set("n", "<leader>?", function()
  which_key.show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })

--Harpoon
harpoon:setup() -- REQUIRED

vim.keymap.set("n", "<leader>a", function()
  harpoon:list():add()
end, { desc = "Harpoon add to buffer" })

vim.keymap.set("n", "<leader>h", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon open buffer float" })

vim.keymap.set("n", "<leader>1", function()
  harpoon:list():select(1)
end, { desc = "Harpoon open buffer 1" })

vim.keymap.set("n", "<leader>2", function()
  harpoon:list():select(2)
end, { desc = "Harpoon open buffer 2" })

vim.keymap.set("n", "<leader>3", function()
  harpoon:list():select(3)
end, { desc = "Harpoon open buffer 3" })

vim.keymap.set("n", "<leader>4", function()
  harpoon:list():select(4)
end, { desc = "Harpoon open buffer 4" })

vim.keymap.set("n", "<leader>5", function()
  harpoon:list():select(5)
end, { desc = "Harpoon open buffer 5" })

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function()
  harpoon:list():prev()
end, { desc = "Harpoon go to previouse buffer" })

vim.keymap.set("n", "<C-S-N>", function()
  harpoon:list():next()
end, { desc = "Harpoon go to next buffer" })
