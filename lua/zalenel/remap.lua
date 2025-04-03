local builtin = require("telescope.builtin")
local harpoon = require("harpoon")

vim.keymap.set("n", "<leader>ef", vim.cmd.Ex, { desc = "Vim escape file" })
vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end)

-- Move stuff
vim.keymap.set("v", "J", ":m  '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m  '<-2<CR>gv=gv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Editing
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set("v", "<leader>d", '"_d')
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Find and replace current word" }
)

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
		bufmap("n", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
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

--Harpoon
harpoon:setup() -- REQUIRED

vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end, { desc = "Harpoon add to buffer" })

vim.keymap.set("n", "<C-e>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon open buffer float" })

vim.keymap.set("n", "<C-j>", function()
	harpoon:list():select(1)
end, { desc = "Harpoon open buffer 1" })

vim.keymap.set("n", "<C-k>", function()
	harpoon:list():select(2)
end, { desc = "Harpoon open buffer 2" })

vim.keymap.set("n", "<C-l>", function()
	harpoon:list():select(3)
end, { desc = "Harpoon open buffer 3" })

vim.keymap.set("n", "<C-;>", function()
	harpoon:list():select(4)
end, { desc = "Harpoon open buffer 4" })

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function()
	harpoon:list():prev()
end, { desc = "Harpoon go to previouse buffer" })

vim.keymap.set("n", "<C-S-N>", function()
	harpoon:list():next()
end, { desc = "Harpoon go to next buffer" })
