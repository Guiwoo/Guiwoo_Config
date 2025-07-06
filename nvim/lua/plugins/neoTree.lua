return { 
  "nvim-neo-tree/neo-tree.nvim", 
  branch = "v3.x",
  dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", 
      "MunifTanjim/nui.nvim",
  },
  lazy = false, 
  opts = {
    filesystem = {
      filtered_tiems = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
      },
    },
  },
  config = function()
    vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>',{})
  end
}
