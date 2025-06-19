return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        dim_inactive = false,
        transparent_mode = false,
        overrides = {
          Normal = { bg = "#282828" }, -- Définit la couleur de fond de la zone principale
        },
      })
      vim.cmd("colorscheme gruvbox")
    end,
  },
}
