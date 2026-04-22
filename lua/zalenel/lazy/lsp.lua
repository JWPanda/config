return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			{ "williamboman/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{
				"j-hui/fidget.nvim",
				opts = {
					notification = { override_vim_notify = true },
				},
			},
			"folke/lazydev.nvim",
		},
		config = function()
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = { source = "if_many", spacing = 2 },
			})

			vim.lsp.config("*", {
				capabilities = vim.tbl_deep_extend(
					"force",
					vim.lsp.protocol.make_client_capabilities(),
					require("blink.cmp").get_lsp_capabilities()
				),
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client or client.name ~= "ruby_lsp" then
						return
					end
					local bufnr = args.buf
					vim.api.nvim_buf_create_user_command(bufnr, "ShowRubyDeps", function(opts)
						local params = vim.lsp.util.make_text_document_params(bufnr)
						local showAll = opts.args == "all"
						client:request("rubyLsp/workspace/dependencies", params, function(error, result)
							if error then
								print("Error showing deps: " .. error)
								return
							end
							local qf_list = {}
							for _, item in ipairs(result) do
								if showAll or item.dependency then
									table.insert(qf_list, {
										text = string.format("%s (%s) - %s", item.name, item.version, item.dependency),
										filename = item.path,
									})
								end
							end
							vim.fn.setqflist(qf_list)
							vim.cmd("copen")
						end, bufnr)
					end, {
						nargs = "?",
						complete = function()
							return { "all" }
						end,
					})
				end,
			})

			local servers = {
				rust_analyzer = require("zalenel.lsp.rust_analyzer"),
				lua_ls = require("zalenel.lsp.lua_ls"),
				eslint = require("zalenel.lsp.eslint"),
				ruby_lsp = require("zalenel.lsp.ruby_lsp"),
				yamlls = require("zalenel.lsp.yamlls"),
			}

			for server_name, config in pairs(servers) do
				vim.lsp.config(server_name, config)
			end

			require("mason-tool-installer").setup({ ensure_installed = { "stylua", "eslint" } })

			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_enable = {
					exclude = { "rubocop" },
				},
			})

			vim.lsp.enable("ruby_lsp")
		end,
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		ft = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
		opts = {
			settings = {
				jsx_close_tag = { enable = true },
			},
		},
	},
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = { preset = "default" },
			appearance = { nerd_font_variant = "mono" },
			completion = { documentation = { auto_show = false } },
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"lewis6991/hover.nvim",
		keys = {
			{ "K", function() require("hover").hover() end, desc = "Hover" },
			{ "gK", function() require("hover").hover_select() end, desc = "Hover (select provider)" },
		},
		config = function()
			require("hover").setup({
				init = function()
					require("hover.providers.lsp")
					require("hover.providers.man")
					require("hover.providers.dictionary")
				end,
				preview_opts = { border = "rounded" },
				preview_window = false,
				title = true,
				mouse_providers = { "LSP" },
				mouse_delay = 1000,
			})
		end,
	},
}
