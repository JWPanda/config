return {
  {
    'nvim-telescope/telescope.nvim',
    lazy = false,
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      local telescope = require("telescope")

      telescope.setup {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
            }
          }
        }
      }

      require("telescope").load_extension("ui-select")
    end
  },
  {
    "folke/zen-mode.nvim",
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  {
   "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    lazy = false, -- neo-tree will lazily load itself
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight"
        }
      })
    end
  }
}

