return {
  {
    'nvim-telescope/telescope.nvim', 
    lazy = false,
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' } 
  },
  {
    "folke/zen-mode.nvim",
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  }
}

