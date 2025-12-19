return {
	{
		"github/copilot.vim",
		lazy = false,
		config = function()
			-- Mapping tab is already used by NvChad
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true
			vim.g.copilot_tab_fallback = ""

			-- Copilot Toggle Key Mapping
			vim.keymap.set(
				"i",
				"<right>",
        'copilot#Accept(" < CR > ")',
				{ expr = true, silent = true, replace_keycodes = false, desc = "Accept Copilot suggestion" }
			)
			-- or run <leader>ch to see copilot mapping section
			local name = "copilot.vim"
			vim.g.copilot_active = true

			vim.keymap.set("n", "<leader>ce", function()
				if vim.g.copilot_active then
					pcall(vim.cmd, "Copilot disable")
					if ok_lazy and lazy and type(lazy.disable) == "function" then
						pcall(lazy.disable, "copilot.vim")
					end
					vim.g.copilot_active = false
					vim.notify("Copilot disabled")
				else
					if ok_lazy and lazy and type(lazy.enable) == "function" then
						pcall(lazy.enable, "copilot.vim")
						if type(lazy.load) == "function" then
							pcall(lazy.load, { plugins = { "copilot.vim" } })
						end
					end
					pcall(vim.cmd, "Copilot enable")
					vim.g.copilot_active = true
					vim.notify("Copilot enabled")
				end
			end, { desc = "Toggle Copilot (safe lazy usage)" })
		end,
	},
}
