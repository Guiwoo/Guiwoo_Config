return {
	{
		"rebelot/kanagawa.nvim",
		config = function()
			require("kanagawa").setup({
				compile = true,
				transparent = true,
				theme = "wave",
				background = {
					dark = "wave",
					light = "lotus",
				},
			})
			vim.cmd("colorscheme kanagawa")
			vim.api.nvim_set_hl(0, "Visual", { bg = "#f5e0b8", fg = "#3c3836" })
		end,
		build = function()
			vim.cmd("KanagawaCompile")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},
  {
    "olimorris/onedarkpro.nvim",
    name = "onedark",
    priority = 999,
  }
}
