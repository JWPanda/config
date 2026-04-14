return {
	{
		"tpope/vim-rails",
	},
	{
		"mbbill/undotree",
	},
	{
		"folke/trouble.nvim",
		opts = {
			modes = {
				lsp = {
					win = { position = "right" },
				},
				symbols = { -- Configure symbols mode
					win = {
						type = "split", -- split window
						relative = "win", -- relative to current window
						position = "right", -- right side
						size = 0.3, -- 30% of the window
					},
				},
			},
		},
		cmd = "Trouble",
	},
}
