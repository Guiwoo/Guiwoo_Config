local active_theme = {
	plugin = "nightfox",
	colorscheme = "carbonfox",
}

local function setup_theme(module_name)
	return function(_, opts)
		require(module_name).setup(opts)
	end
end

local function set_hl(name, value)
	vim.api.nvim_set_hl(0, name, value)
end

local function apply_highlights(specs)
	for name, value in pairs(specs) do
		set_hl(name, value)
	end
end

local function apply_cursor(colors)
	apply_highlights({
		Cursor = colors,
		lCursor = colors,
	})
end

local function create_augroup(name)
	return vim.api.nvim_create_augroup(name, { clear = true })
end

local function configure_nightfox_highlights()
	apply_highlights({
		Visual = { fg = "#1f1f28", bg = "#ff9e3b", bold = false },
	})

	local cursor_colors = { fg = "#192330", bg = "#FFD75F" }
	local apply_theme_overrides = function()
		apply_cursor(cursor_colors)
	end

	local group = create_augroup("CursorColors")
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = apply_theme_overrides,
	})
	vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
		group = group,
		callback = apply_theme_overrides,
	})

	apply_theme_overrides()
end

local function configure_active_theme(plugin_name, colorscheme, after_setup)
	return function(_, opts)
		require(plugin_name).setup(opts)
		if active_theme.plugin ~= plugin_name then
			return
		end

		vim.cmd.colorscheme(colorscheme)
		if after_setup then
			after_setup()
		end
	end
end

return {
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
		opts = {
			compile = true,
			transparent = false,
			theme = "wave",
			background = {
				dark = "wave",
				light = "lotus",
			},
		},
		config = setup_theme("kanagawa"),
		build = function()
			vim.cmd("KanagawaCompile")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		opts = {
			flavor = "frappe",
			transparent_background = true,
		},
		--config = configure_active_theme("catppuccin", active_theme.colorscheme, configure_nightfox_highlights),
	},
	{
		"olimorris/onedarkpro.nvim",
		lazy = true,
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
		config = setup_theme("tokyonight"),
	},
	{
		"EdenEast/nightfox.nvim",
    name = "nightfox",
		--lazy = true,
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
		config = configure_active_theme("nightfox", active_theme.colorscheme, configure_nightfox_highlights),
	},
}
