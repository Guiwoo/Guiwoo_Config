return {
	{
		"github/copilot.vim",
		lazy = false,
		config = function()
			-- Mapping tab is already used by NvChad
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true
			vim.g.copilot_tab_fallback = ""

			vim.keymap.set(
				"i",
				"<right>",
				'copilot#Accept(" < CR > ")',
				{ expr = true, silent = true, replace_keycodes = false, desc = "Accept Copilot suggestion" }
			)
			-- or run <leader>ch to see copilot mapping section
			vim.keymap.set("n", "<leader>ce", function()
				local name = "copilot.vim"
				require("lazy").enable(name)
				require("lazy").load({ plugins = { name } })
				vim.cmd("Copilot enable")
				vim.notify("Copilot enabled")
			end, { desc = "Enable Copilot (load plugin)" })
		end,
	},
}
