vim.keymap.set("n", "gl", function()
	vim.diagnostic.open_float()
end, { desc = "Open diagnostic in Float" })

vim.keymap.set("n", "<leader>grb", "<C-o>", { desc = "Go Back" })
vim.keymap.set("n", "<leader>grf", "<C-i>", { desc = "Go Forward" }) -- Tab과 충돌 시 키 바꾸세요
