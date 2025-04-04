return {
  { "nvim-tree/nvim-web-devicons", opts = {} },
  { "tpope/vim-fugitive" },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      icons = {
        mappings = false,
      },
    },
  },
}

