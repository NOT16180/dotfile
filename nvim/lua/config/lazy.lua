local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
vim.opt.clipboard = "unnamedplus"

require("lazy").setup({
  spec = {
    -- LazyVim plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- Plugins supplémentaires
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.ui.mini-animate" },

    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false, -- Toujours utiliser la dernière version du commit git
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- Vérification périodique des mises à jour des plugins
    notify = false, -- Ne pas notifier lors des mises à jour
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
