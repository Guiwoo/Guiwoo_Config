return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },

  opts = {
    signs = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      delete       = { text = "" },
      topdelete    = { text = "" },
      changedelete = { text = "▎" },
    },

    current_line_blame = false,
    on_attach = function (bufnr)
     vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#a9b1d6", bg = "#292e42", italic = true })
    end,

    current_line_blame_opts = {
      delay = 500,
      virt_text_pos = "eol",
    },

    preview_config = {
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
  },

  keys = {

    -- navigation
    { "]c", function() require("gitsigns").next_hunk() end, desc = "Next Hunk" },
    { "[c", function() require("gitsigns").prev_hunk() end, desc = "Prev Hunk" },

    -- preview
    { "<leader>gp", function() require("gitsigns").preview_hunk() end, desc = "Preview Hunk" },

    -- stage
    { "<leader>gs", function() require("gitsigns").stage_hunk() end, desc = "Stage Hunk" },
    { "<leader>gS", function() require("gitsigns").stage_buffer() end, desc = "Stage Buffer" },

    -- reset
    { "<leader>gr", function() require("gitsigns").reset_hunk() end, desc = "Reset Hunk" },
    { "<leader>gR", function() require("gitsigns").reset_buffer() end, desc = "Reset Buffer" },

    -- blame
    { "<leader>gb", function() require("gitsigns").blame_line() end, desc = "Blame Line" },
    { "<leader>gB", ":Gitsigns toggle_current_line_blame<CR>", desc = "Toggle Blame" },

    -- diff
    { "<leader>gd", function() require("gitsigns").diffthis() end, desc = "Diff This" },

    -- word diff
    { "<leader>gw", ":Gitsigns toggle_word_diff<CR>", desc = "Word Diff" },
  },
}
