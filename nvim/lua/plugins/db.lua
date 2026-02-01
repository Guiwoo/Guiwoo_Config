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
	},
	{
		"kristijanhusak/vim-dadbod-completion",
		dependencies = { "tpope/vim-dadbod" },
		ft = { "sql", "mysql", "plsql" },
	},
}
