return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		filesystem = {
			filtered_tiems = {
				visible = true,
				show_hidden_count = true,
				hide_dotfiles = false,
			},
		},
	},
	keys = {
		{ "<C-n>", ":Neotree filesystem reveal left toggle<CR>", mode = "n", desc = "Neo-tree" },
	},
}
