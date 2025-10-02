return {
  --[[
	"ggandor/leap.nvim",
	keys = { "s", "S", "gs" },
	config = function()
		local leap = require("leap")
		leap.add_default_mappings() -- s / S / gs 자동 설정
		leap.opts.case_sensitive = false
		vim.o.timeout = true
		vim.o.timeoutlen = 500

		vim.api.nvim_set_hl(0, "LeapLabelPrimary", { link = "IncSearch" })
		vim.api.nvim_set_hl(0, "LeapLabelSecondary", { link = "Search" })
		vim.api.nvim_set_hl(0, "LeapMatch", { link = "Search" })

		vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
	end,
  ]]--
}
