vim.keymap.set("n", "gl", function()
	vim.diagnostic.open_float()
end, { desc = "Open diagnostic in Float" })

vim.keymap.set("n", "<leader>grb", "<C-o>", { desc = "Go Back" })
vim.keymap.set("n", "<leader>grf", "<C-i>", { desc = "Go Forward" }) -- Tab과 충돌 시 키 바꾸세요

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- Esc Highlight Remove

--Nvim Set
vim.api.nvim_set_hl(0, "Search", { bg = "#fabd2f", fg = "#3c3836" })
vim.api.nvim_set_hl(0, "IncSearch", { bg = "#8ec07c", fg = "#3c3836" })
