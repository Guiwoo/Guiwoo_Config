return {
	{ "rcarriga/nvim-dap-ui", enabled = false },
	{
		"miroshQa/debugmaster.nvim",
		-- osv is needed if you want to debug neovim lua code. Also can be used
		-- as a way to quickly test-drive the plugin without configuring debug adapters
		dependencies = { "mfussenegger/nvim-dap", "jbyuki/one-small-step-for-vimkind" },
		config = function()
			local dm = require("debugmaster")
			-- Alternative keybindings to "<leader>d" could be: "<leader>m", "<leader>;"
			vim.keymap.set({ "n", "v" }, "<leader>dbg", dm.mode.toggle, { nowait = true })
			-- If you want to disable debug mode in addition to leader+d using the Escape key:
			vim.keymap.set("n", "<Esc>", dm.mode.disable)
			-- This might be unwanted if you already use Esc for ":noh"
			vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })


			dm.plugins.osv_integration.enabled = true -- needed if you want to debug neovim lua code
			local dap = require("dap")
      --[[
      dap.adapters.go = {
        type = "server",
        port = "38607",
        executable = {
          command = "/Users/guiwoopark/go/bin/dlv",
          args = { "dap", "-l", "127.0.0.1:${port}"},
        },
      }
      ]]--
      dap.adapters.delve = function(callback, config)
        if config.mode == "remote" and config.request == "attach" then
          callback({
            type = "server",
            host = config.host or "127.0.0.1",
            port = config.port or "38607",
            executable = {
              command = "dlv",
              args = { "dap", "-l", "127.0.0.1:${port}", "--log", "--log-output=dap,debugger,debuglineerr,rpc" },
            },
          })
        else
          callback({
            type = "server",
            port = "${port}",
            executable = {
              command = "dlv",
              args = { "dap", "-l", "127.0.0.1:${port}", "--log", "--log-output=dap,debugger,debuglineerr,rpc" },
            },
          })
        end
      end
      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug",
          request = "launch",
          program = "${fileDirname}",
          console = "externalTerminal",
        },
        {
          type = "delve",
          name = "Debug test",
          request = "launch",
          mode = "test",
          program = "${file}",
          console = "externalTerminal",
        },
        {
          type = "delve",
          name = "Debug test (go.mod)",
          request = "launch",
          mode = "test",
          program = "./${relativeFileDirname}",
          console = "integratedTerminal",
        },
      }
      -- Configure your debug adapters here
      -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
    end,
  },
}
