return {
  {
    "RRethy/vim-illuminate",
    event = { "CursorHold", "CursorHoldI" },
    config = function()
      require("illuminate").configure({
        delay = 200,
        large_file_cutoff = 2000,
        large_file_overrides = {
          providers = { "lsp" },
        },
      })
    end,
  },
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
    url = "https://codeberg.org/andyg/leap.nvim",
    lazy = false,
    config = function()
      vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
      vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')
      vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)')

      local function set_hl()
        vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
        vim.api.nvim_set_hl(0, 'LeapMatch', {
          fg = '#ccff88', bold = true, nocombine = true,
        })
      end

      set_hl()
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_hl,
      })
    end,
  },
  {
    "leath-dub/snipe.nvim",
    keys = {
      { "gb", function () require("snipe").open_buffer_menu() end, desc = "Open Snipe buffer menu" }
    },
    opts = {},
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
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History" },
    },
    opts = {},
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
    "Badhi/nvim-treesitter-cpp-tools",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "cpp", "c", "h", "hpp" }, -- Lazy load on C++ files
    config = function()
      require("nt-cpp-tools").setup({
        preview = {
          quit = "q",
          accept = "<tab>",
        },
        header_extension = "h",
        source_extension = "cpp",
        custom_define_class_function_commands = {
          TSCppDefineClassFunc = {
            output_handle = function(str, context)
              local current_file = vim.api.nvim_buf_get_name(0)
              -- Map include/ -> src/ and .h -> .cpp
              local target_file = current_file:gsub("/include/", "/src/"):gsub("%.h$", ".cpp")
              
              -- Open the target file
              vim.cmd("edit " .. target_file)

              -- Calculate the end of the file to append
              local last_line = vim.api.nvim_buf_line_count(0)
              
              -- Write the text
              require("nt-cpp-tools.util").add_text_edit(str, last_line, 0)

              -- Jump to the end and center
              vim.cmd("normal! G")
              vim.cmd("normal! zz")
            end,
          },
        },
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = function()
      local conf = require "nvchad.configs.telescope"
      local actions = require "telescope.actions"

      conf.defaults.mappings.i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.move_selection_next,
        ["<C-p>"] = actions.move_selection_previous,
      }

      return conf
    end,
  },
  {
    "sindrets/winshift.nvim",
    cmd = "WinShift",
    keys = {
      { "<leader>wm", "<cmd>WinShift<cr>", desc = "WinShift" },
    },
  },
  {
    "ms-jpq/chadtree",
    branch = "chad",
    build = "python3 -m chadtree deps",
    cmd = "CHADopen",
    keys = {
      { "<leader>v", "<cmd>CHADopen<cr>", desc = "Toggle CHADtree" },
      { "<C-n>", "<cmd>CHADopen<cr>", desc = "Toggle CHADtree" },
    },
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Open DAP REPL" },
      { "<leader>dk", function() require("dap").up() end, desc = "Stack Up" },
      { "<leader>dj", function() require("dap").down() end, desc = "Stack Down" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate Session" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      require("nvim-dap-virtual-text").setup()

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- C++ / Rust Adapter Setup
      dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. '/mason/bin/codelldb',
          args = {"--port", "${port}"},
        }
      }

      local last_program = vim.fn.getcwd() .. '/'
      local last_args = ""

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            last_program = vim.fn.input('Path to executable: ', last_program, 'file')
            return last_program
          end,
          args = function()
            last_args = vim.fn.input("Input args: ", last_args, "file")
            return vim.split(last_args, " ", { trimempty = true })
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }

      dap.configurations.c = dap.configurations.cpp
    end,
  },
  {
    "sphamba/smear-cursor.nvim",
    lazy = false,
    opts = {},
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local cmp = require "cmp"
      local conf = require "nvchad.configs.cmp"

      conf.mapping["<C-j>"] = cmp.mapping.select_next_item()
      conf.mapping["<C-k>"] = cmp.mapping.select_prev_item()

      return conf
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>S", '<cmd>lua require("spectre").toggle()<cr>', desc = "Toggle Spectre" },
      { "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<cr>', desc = "Search current word" },
      { "<leader>sw", '<cmd>lua require("spectre").open_visual()<cr>', mode = "v", desc = "Search current word" },
      { "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<cr>', desc = "Search on current file" },
    },
  },
}
