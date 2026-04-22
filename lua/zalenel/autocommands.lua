local function augroup(name)
	return vim.api.nvim_create_augroup("local_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("FileType", {
	group = augroup("treesitter"),
	callback = function(args)
		if pcall(vim.treesitter.start, args.buf) and vim.bo[args.buf].filetype == "ruby" then
			vim.api.nvim_buf_call(args.buf, function()
				vim.cmd("syntax enable")
			end)
		end
	end,
})

-- Workaround for neovim 0.12.1 bug: treesitter conceal_line crashes in LSP float windows
local orig_open_floating_preview = vim.lsp.util.open_floating_preview
vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
	local buf, win = orig_open_floating_preview(contents, syntax, opts, ...)
	vim.treesitter.stop(buf)
	return buf, win
end

-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("kickstart-hightlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- LSP Progress message
vim.api.nvim_create_autocmd("LspProgress", {
	group = augroup("lsp_progress"),
	callback = function(ev)
		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
		local ok, status = pcall(vim.lsp.status)
		if not ok or status == "" then
			return
		end
		vim.notify(status, vim.log.levels.WARN, {
			id = "lsp_progress",
			title = "LSP Progress",
			opts = function(notif)
				notif.icon = ev.data.params.value.kind == "end" and " "
					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
			end,
		})
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		local conform = require("conform")

		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
		map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
		map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
		map("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
		map("<leader>ds", vim.lsp.buf.document_symbol, "[D]ocument [S]ymbols")
		map("<leader>ws", vim.lsp.buf.workspace_symbol, "[W]orkspace [S]ymbols")
		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
		map("<leader>cf", function()
			conform.format({ async = true, lsp_format = "fallback" })
		end, "[C]ode [F]ormat")
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end

		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_signatureHelp, event.buf) then
			map("<C-h>", vim.lsp.buf.signature_help, "Signature [H]elp", "i")
			vim.api.nvim_create_autocmd("CursorHoldI", {
				buffer = event.buf,
				callback = vim.lsp.buf.signature_help,
			})
		end

		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "[T]oggle Inlay [H]ints")
		end
	end,
})
