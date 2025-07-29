return {
  "ibhagwan/fzf-lua",
  dependencies = { "echasnovski/mini.icons" },
  keys={
    {
      "<leader>ff",
      function()
        require('fzf-lua').files()
      end,
      desc ="Find Files in Project directory"
    },
    {
      "<leader>fg",
      function()
        require('fzf-lua').live_grep()
      end,
      desc ="Find By grepping in project directory"
    },
    {
      "<leader>fc",
      function()
        require('fzf-lua').files({ cwd = vim.fn.stdpath("config") })
      end,
      desc ="Find By grepping in project directory"
    },
    {
      "<leader>fh",
      function()
        require('fzf-lua').helptags()
      end,
      desc ="Find Help"
    },
    {
      "<leader>fk",
      function()
        require('fzf-lua').keymaps()
      end,
      desc ="Find KeyMaps"
    },
    {
      "<leader>fb",
      function()
        require('fzf-lua').builtin()
      end,
      desc ="Find buildin fzf"
    },
    {
      "<leader>fw",
      function()
        require('fzf-lua').grep_cword()
      end,
      desc ="Find Current Word"
    },
    {
      "<leader>fo",
      function()
        require('fzf-lua').oldfiles()
      end,
      desc ="Find Old Files"
    },
    {
      "<leader><leader>",
      function()
        require('fzf-lua').buffers()
      end,
      desc ="Find Existing Buffers"
    },
    {
      "<leader>f/",
      function()
        require('fzf-lua').lgrip_curbuf()
      end,
      desc ="Find Existing Buffers"
    }

  },
  opts = {}
}
