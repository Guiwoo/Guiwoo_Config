print("VSCODE_INIT.LUA: Custom init file for VSCode Neovim loaded!")

vim.opt.clipboard = 'unnamedplus' -- 시스템 클립보드 연동
print("VSCODE_INIT.LUA: Clipboard set to unnamedplus.")

local leap_plugin_path = "/Users/guiwoopark/.local/share/nvim/lazy/leap.nvim" 

local stat = vim.loop.fs_stat(leap_plugin_path)
if stat then
  print("VSCODE_INIT.LUA: Adding leap.nvim path to runtimepath: " .. leap_plugin_path)
  vim.opt.runtimepath:append(leap_plugin_path)
else
  print("VSCODE_INIT.LUA: ERROR - leap.nvim path not found: " .. leap_plugin_path .. ". Leap will not be loaded.")
end

local leap_ok, leap = pcall(require, 'leap')

if leap_ok then
  print("VSCODE.LUA: leap.nvim required successfully. Configuring...")
  leap.setup({
    ignore_case = true,
    highlight_unlabeled_phase_one_targets = true,
  })
  local comment_hl = vim.api.nvim_get_hl(0, { name = "Comment" })
  if comment_hl and comment_hl.foreground then
    vim.api.nvim_set_hl(0, "LeapBackdrop", { fg = "#4a4a4a", dim = true })
  else
    vim.api.nvim_set_hl(0, "LeapBackdrop", { fg = "Gray" })
  end

  vim.api.nvim_set_hl(0, 'LeapMatch', { fg = 'white', bg = '#506090', bold = true, nocombine = true })

  vim.api.nvim_set_keymap('n', 's', [[<Cmd>lua require('leap').leap({ target_windows = { vim.api.nvim_get_current_win(), unpack(require('leap.util').get_enterable_windows()) } })<CR>]], { noremap = true, silent = true, desc = "Leap forward (VSCode)" })
  vim.api.nvim_set_keymap('v', 's', [[<Cmd>lua require('leap').leap({ target_windows = { vim.api.nvim_get_current_win(), unpack(require('leap.util').get_enterable_windows()) } })<CR>]], { noremap = true, silent = true, desc = "Leap forward (visual, VSCode)" })
  print("VSCODE.LUA: leap.nvim 's' key mapped.")
else
  print("VSCODE.LUA: ERROR - Failed to require 'leap'. Ensure it's correctly added to runtimepath or installed globally.")
end

print("VSCODE_INIT.LUA: Finished loading custom init file for VSCode.")
