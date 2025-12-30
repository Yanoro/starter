return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    build = "make",

    opts = {
      provider = "gemini",
      providers = {
        gemini = {
          endpoint = "https://generativelanguage.googleapis.com/v1beta/models",

          model = "gemini-2.5-flash",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = { embed_image_as_base64 = false },
        },
      },
    },
  },
  {
    "marcinjahn/gemini-cli.nvim",
    cmd = "Gemini",
    -- Example key mappings for common actions:
    keys = {
      { "<leader>g/", "<cmd>Gemini toggle<cr>", desc = "Toggle Gemini CLI" },
      { "<leader>ga", "<cmd>Gemini ask<cr>", desc = "Ask Gemini", mode = { "n", "v" } },
      { "<leader>gf", "<cmd>Gemini add_file<cr>", desc = "Add File" },

    },
    dependencies = {
      "folke/snacks.nvim",
    },
    config = true,
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",         
      "sindrets/diffview.nvim",       

      "nvim-telescope/telescope.nvim", -- optional
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
    }
  }

}
