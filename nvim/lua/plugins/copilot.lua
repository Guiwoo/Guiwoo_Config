return {
  --[[
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false }, -- avante와 충돌 방지를 위해 제안 기능은 끄는 것을 권장
				panel = { enabled = false },
			})
		end,
	},
  ]]--
}
