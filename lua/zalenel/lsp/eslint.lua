return {
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	settings = {
		workingDirectories = { mode = "auto" },
		run = "onSave",
		codeAction = {
			disableRuleComment = { enable = true, location = "separateLine" },
			showDocumentation = { enable = true },
		},
		problems = { shortenToSingleLine = false },
		format = false, -- prettierd handles formatting
	},
}
