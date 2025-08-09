return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		view_options = {
			show_hidden = true,
		},
	},
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	keys = {
		{ "<C-n>", "<cmd>Oil --float<cr>", desc = "Oil Float screen on the boobs" },
		{
			"<Esc>",
			function()
				if vim.bo.filetype == "oil" then
					require("oil").close()
				end
			end,
			desc = "close oil float",
		},
	},
}
