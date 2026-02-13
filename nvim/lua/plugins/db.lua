-- Database Plugins
-- DB 관련 플러그인
return {
	{
		"tpope/vim-dadbod",
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = { "tpope/vim-dadbod" },
		cmd = { "DBUI", "DBUIToggle" },
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.dbs = {
				local_pg = "postgres://postgres:postgres@localhost:5432/postgres",
				local_mysql = "mysql://root:mysqlvotmdnjem@127.0.0.1:53306/vueron-local?default-character-set=utf8mb4",
			}

			vim.keymap.set("n", "<leader>du", "<cmd>DBUIToggle<cr>", { desc = "DB UI Toggle" })
			vim.keymap.set("n", "<leader>df", "<cmd>DBUIFindBuffer<cr>", { desc = "DB Find Buffer" })
			vim.keymap.set("n", "<leader>dr", "<cmd>DBUIRenameBuffer<cr>", { desc = "DB Rename Buffer" })
			vim.keymap.set("n", "<leader>dl", "<cmd>DBUILastQueryInfo<cr>", { desc = "DB Last Query Info" })
		end,
	},
	{
		"kristijanhusak/vim-dadbod-completion",
		dependencies = { "tpope/vim-dadbod" },
		ft = { "sql", "mysql", "plsql" },
	},
}
