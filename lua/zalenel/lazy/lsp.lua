return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			{ "williamboman/mason.nvim", opts = {} },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
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

			local capabilities = vim.tbl_deep_extend(
				"force",
				vim.lsp.protocol.make_client_capabilities(),
				require("blink.cmp").get_lsp_capabilities()
			)

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
				rust_analyzer = {},
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				},
			}

			local ensure_installed = {
				"stylua",
				"eslint",
			}

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						vim.lsp.config(server_name, server)
						vim.lsp.enable(server_name)
					end,
					ruby_lsp = function() end, -- configured via lsp/ruby_lsp.lua using rbenv
					rubocop = function() end,  -- not used as LSP; ruby-lsp handles rubocop diagnostics
				},
			})

			vim.lsp.enable("ruby_lsp")
		end,
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
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
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}
