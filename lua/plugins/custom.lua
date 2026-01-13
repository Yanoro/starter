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
    "ggandor/leap.nvim",
    lazy = false,
    config = function()
      require('leap').add_default_mappings()
    end,
  },
  {
    "rhysd/clever-f.vim",
    lazy = false,
    init = function()
      vim.g.clever_f_ignore_case = 1
      vim.g.clever_f_smart_case = 1
      vim.g.clever_f_across_no_line = 1
    end,
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
    opts = {
      kind = "replace",
      commit_popup = {
        kind = "replace",
      },
      popup = {
        kind = "replace",
      },
    },
    keys = {
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
    }
  },
  {
    "Civitasv/cmake-tools.nvim",
    lazy = false, -- Load on startup so it can detect CMakeLists.txt
    opts = {},
  },

  {
    "stevearc/overseer.nvim",
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1,
      },
    },
  },
  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = { "stevearc/overseer.nvim" },
    config = function(_, opts)
      require("compiler").setup(opts)
    end,
  },
  {
    "folke/edgy.nvim",
    lazy = false,
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = {
      bottom = {
        -- toggleterm / trouble / qf etc
      },
      left = {
        {
          ft = "NvimTree",
          title = "NvimTree",
          size = { width = 60 },
          filter = function(buf)
             return vim.bo[buf].filetype == "NvimTree"
          end,
        },
        {
          ft = "OverseerList",
          title = "Overseer",
          size = { width = 60 },
        },
        {
          title = "Overseer Output",
          ft = "OverseerOutput",
          size = { width = 60 },
          filter = function(buf)
            local ft = vim.bo[buf].filetype
            return ft == "OverseerOutput"
          end,
        },
      },
    },
  },

}
