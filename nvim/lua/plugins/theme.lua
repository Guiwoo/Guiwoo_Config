return {
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
		config = function()
			require("kanagawa").setup({
				compile = true,
				transparent = false,
				theme = "wave",
				background = {
					dark = "wave",
					light = "lotus",
				},
			})
			--vim.cmd("colorscheme kanagawa-dragon")
			--vim.api.nvim_set_hl(0, "Visual", { bg = "#fe8019", fg = "#3c3836" })
		end,
		build = function()
			vim.cmd("KanagawaCompile")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			flavor = "frappe",
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin-frappe")
			vim.api.nvim_set_hl(0, "Visual", { fg = "#1f1f28", bg = "#ff9e3b", bold = false })
			local function cursor_normal()
				vim.api.nvim_set_hl(0, "Cursor", { fg = "#2E3440", bg = "#EBCB8B" })
				vim.api.nvim_set_hl(0, "lCursor", { fg = "#2E3440", bg = "#EBCB8B" })
			end
			local function cursor_insert()
				vim.api.nvim_set_hl(0, "Cursor", { fg = "#2E3440", bg = "#A3BE8C" })
				vim.api.nvim_set_hl(0, "lCursor", { fg = "#2E3440", bg = "#A3BE8C" })
			end
			local group = vim.api.nvim_create_augroup("CursorColors", { clear = true })
			vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = cursor_normal })
			vim.api.nvim_create_autocmd("InsertEnter", { group = group, callback = cursor_insert })
			vim.api.nvim_create_autocmd("InsertLeave", { group = group, callback = cursor_normal })
		end,
	},
	{
		"olimorris/onedarkpro.nvim",
		name = "onedark",
		priority = 1002,
	},
	{
		"folke/tokyonight.nvim",
		lazy = true,
		opts = {
			style = "day",
			transparent = true,
		},
		config = function(_, opts)
			--require("tokyonight").setup(opts)
			--vim.cmd.colorscheme("tokyonight-day")
			--vim.api.nvim_set_hl(0, "Visual", { bg = "#fe8019", fg = "#3c3836" })
		end,
	},
	{
		"EdenEast/nightfox.nvim",
    lazy = true,
		opts = {
			styles = {
				comments = "italic",
				keywords = "bold",
				types = "italic,bold",
				opts = {
					options = {
						transparent = false,
					},
				},
			},
		},
		config = function(_, opts)
			require("nightfox").setup(opts)
			vim.cmd.colorscheme("nordfox")
			vim.api.nvim_set_hl(0, "Visual", { fg = "#1f1f28", bg = "#ff9e3b", bold = false })
			local function cursor_normal()
				vim.api.nvim_set_hl(0, "Cursor", { fg = "#2E3440", bg = "#EBCB8B" })
				vim.api.nvim_set_hl(0, "lCursor", { fg = "#2E3440", bg = "#EBCB8B" })
			end
			local function cursor_insert()
				vim.api.nvim_set_hl(0, "Cursor", { fg = "#2E3440", bg = "#A3BE8C" })
				vim.api.nvim_set_hl(0, "lCursor", { fg = "#2E3440", bg = "#A3BE8C" })
			end
			local group = vim.api.nvim_create_augroup("CursorColors", { clear = true })
			vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = cursor_normal })
			vim.api.nvim_create_autocmd("InsertEnter", { group = group, callback = cursor_insert })
			vim.api.nvim_create_autocmd("InsertLeave", { group = group, callback = cursor_normal })
		end,
	},
	{
		"scottmckendry/cyberdream.nvim",
		lazy = true,
		priority = 1000,
	}
}
