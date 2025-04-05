return {
	{

		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000, -- Make sure to load this before all the other start plugins.
		config = function()
			require("tokyonight").setup({
				styles = "night",
			})

			vim.cmd.colorscheme("tokyonight-night")
		end,
	}, -- tokyonight
	{
		"folke/tokyonight.nvim",
		name = "tokyonight",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			require("tokyonight").setup({
				style = "night",
			})

			vim.cmd("colorscheme tokyonight-night")
		end,
	},
}
