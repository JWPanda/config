return {
	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			notify_on_error = false,
			formatters = {
				rubocop = {
					command = "bundle",
					args = { "exec", "rubocop", "--auto-correct-all", "--format", "quiet", "--stderr", "--stdin", "$FILENAME" },
					exit_codes = { 0, 1, 2 },
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				ruby = { "rubocop" },
				javascript = { "prettierd", stop_after_first = true },
				typescript = { "prettierd", stop_after_first = true },
				json = { "prettierd", stop_after_first = true },
				yaml = { "prettierd", stop_after_first = true },
			},
		},
	},
	{
		"esmuellert/nvim-eslint",
		config = function()
			require("nvim-eslint").setup({})
		end,
	},
	{ -- Linting
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				markdown = { "markdownlint" },
				ruby = { "ruby" },
				json = { "jsonlint" },
				text = { "vale" },
			}
		end,
	},
}
