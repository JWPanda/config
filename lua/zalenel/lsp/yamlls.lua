return {
	settings = {
		yaml = {
			validate = true,
			completion = true,
			hover = true,
			schemaStore = { enable = true, url = "https://www.schemastore.org/api/json/catalog.json" },
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*.yml",
				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
			},
		},
	},
}
