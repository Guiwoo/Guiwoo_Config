return { 
  "nvim-treesitter/nvim-treesitter", 
  branch = 'master', 
  lazy = false, 
  build = ":TSUpdate",
  config = function()
    local treeConfig = require("nvim-treesitter.configs")
    treeConfig.setup({
      ensure_installed = {"lua","go","gomod","javascript"},
      highlight = {enable=true},
      indent = { enable=true}
    })
  end
} 
