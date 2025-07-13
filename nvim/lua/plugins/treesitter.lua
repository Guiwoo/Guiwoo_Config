return {
  "nvim-treesitter/nvim-treesitter",
  branch = 'master',
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local treeConfig = require("nvim-treesitter.configs")
    treeConfig.setup({
      ensure_installed = {"c","lua","go","gomod","javascript","vim","vimdoc"},
      highlight = {enable=true},
      indent = { enable=true},
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<Enter>",
          node_incremental = "<Enter>",
          scope_incremental = false,
          node_decremental = "<Backspace>",
        },
      },
    })
  end
}
