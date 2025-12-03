local function add_ruby_deps_command(client, bufnr)
	vim.api.nvim_buf_create_user_command(bufnr, "ShowRubyDeps", function(opts)
		local params = vim.lsp.util.make_text_document_params()
		local showAll = opts.args == "all"

		client.request("rubyLsp/workspace/dependencies", params, function(error, result)
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
end

return {
	{
		"vim-ruby/vim-ruby",
		config = function()
			vim.cmd([[autocmd FileType ruby setlocal indentkeys-=.]])
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			{ "williamboman/mason.nvim", opts = {} },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },
			"folke/lazydev.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		opts = {
			servers = {},
		},
		config = function(_, opts)
			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
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
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()

			-- Blink
			local blink_loaded, blink = pcall(require, "blink.cmp")
			if blink_loaded then
				capabilities = vim.tbl_deep_extend("force", capabilities, blink.get_lsp_capabilities())
			end

			local servers = {
				ruby_lsp = {
					mason = false,
					cmd = { vim.fn.expand("~/.rbenv/shims/ruby-lsp") },
					root_dir = function(fname)
						return vim.lsp.util.root_pattern("Gemfile", ".git")(fname) or vim.fn.getcwd()
					end,
					formatter = "false",
					on_attach = function(client, buffer)
						add_ruby_deps_command(client, buffer)
					end,
				},
				rust_analyzer = {},
				solargraph = {
					cmd = { vim.fn.expand("~/.rbenv/shims/solargraph"), "stdio" },
					root_dir = function(fname)
						return vim.lsp.util.root_pattern("Gemfile", ".git")(fname) or vim.fn.getcwd()
					end,
					flags = {
						debounce_text_changes = 150,
					},
					settings = {
						solargraph = {
							autoformat = false,
							completion = true,
							diagnostic = true,
							folding = true,
							references = true,
							rename = true,
							symbols = true,
						},
					},
				},
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

			local ensure_installed = vim.tbl_keys(opts.servers or {})

			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"ruby_lsp",
				"eslint",
				"solargraph",
			})

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						vim.lsp.config(server_name, server)
						vim.lsp.enable(server_name)
					end,
				},
			})
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
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = { preset = "default" },

			appearance = {
				nerd_font_variant = "mono",
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = { documentation = { auto_show = false } },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
				},
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
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
	{ -- optional cmp completion source for require statements and module annotations
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			})
		end,
	},
}
