return {
	{
		"miroshQa/debugmaster.nvim",
		dependencies = {
			"mfussenegger/nvim-dap",
			"jbyuki/one-small-step-for-vimkind",
		},
		config = function()
			local dm = require("debugmaster")
			vim.keymap.set({ "n", "v" }, "<leader>dbg", dm.mode.toggle, { nowait = true })
			vim.keymap.set("n", "<Esc>", dm.mode.disable)
			vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
			dm.plugins.osv_integration.enabled = true
			local dap = require("dap")
			--------------------------------------------------------------------
			-- 여기부터 VSCode 스타일 Go 디버거 설정
			--------------------------------------------------------------------
			-- 1) VSCode Go 디버그 어댑터 등록
			dap.adapters.go = {
				type = "executable",
				command = "node",
				args = { os.getenv("HOME") .. "/dev/golang/vscode-go/extension/dist/debugAdapter.js" },
			}
			dap.configurations.go = {
				{
					type = "go",
					name = "Debug",
					request = "launch",
					showLog = false,
					program = "${file}",
					dlvToolPath = vim.fn.exepath("/Users/guiwoopark/go/bin/dlv"), -- Adjust to where delve is installed
				},
			}
		end,
	},
}
