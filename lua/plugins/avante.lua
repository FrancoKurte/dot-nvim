return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  opts = {
    -- Core provider configuration
    provider = "gemini",
    auto_suggestions = false,

    -- Behavior configuration optimized for development
    behaviour = {
      auto_suggestions = false,
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = true,
      support_paste_from_clipboard = true,
    },

    -- Model configuration
    gemini = {
      model = "gemini-2.0-flash-lite",
      temperature = 0.1,
      max_tokens = 8192,
      timeout = 45000,
    },

    -- Enhanced mappings for development workflow
    mappings = {
      --- @class AvanteConflictMappings
      diff = {
        ours = "co",
        theirs = "ct",
        all_theirs = "ca",
        both = "cb",
        cursor = "cc",
        next = "]x",
        prev = "[x",
      },
      suggestion = {
        accept = "<M-l>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
      jump = {
        next = "]]",
        prev = "[[",
      },
      submit = {
        normal = "<CR>",
        insert = "<C-s>",
      },
      sidebar = {
        apply_all = "A",
        apply_cursor = "a",
        switch_windows = "<Tab>",
        reverse_switch_windows = "<S-Tab>",
      },
    },

    -- System programming optimized hints
    hints = {
      enabled = true,
    },

    -- Enhanced windows configuration for multi-file projects
    windows = {
      position = "right",
      width = 30,
      sidebar_header = {
        enabled = true,
        align = "left",
        rounded = false,
      },
      input = {
        prefix = "> ",
        height = 8, -- Larger input for complex queries
      },
      edit = {
        border = "rounded",
        start_insert = true,
      },
      ask = {
        floating = false, -- Integrated experience
        start_insert = true,
        border = "rounded",
        focus_on_apply = "ours",
      },
    },

    -- File selector optimized for system development
    selector = {
      provider = "fzf_lua", -- Fast for large codebases
      provider_opts = {
        -- Prioritize system programming files
        file_ignore_patterns = {
          "%.git/",
          "node_modules/",
          "target/debug/",
          "target/release/",
          "build/",
          "%.o$",
          "%.so$",
          "%.a$",
          "core%.%d+$",
        },
      },
    },

    -- Development-focused highlights
    highlights = {
      diff = {
        current = "DiffText",
        incoming = "DiffAdd",
      },
    },

    -- Custom system prompts for different development contexts
    system_prompt = [[
You are an expert systems programmer with deep knowledge of C, Go, Rust, and Linux kernel.

CORE PRINCIPLES:
- Prioritize code safety, performance, and maintainability
- Follow language-specific best practices and idioms
- Consider cpu cycles, memory management, concurrency, and system resource usage
- Provide production-ready, well-documented code
- Explain complex system concepts clearly

LANGUAGE EXPERTISE:
- C: Focus on memory safety, proper error handling, and system calls
- Go: Emphasize simplicity, error handling, and effective use of goroutines
- Rust: Leverage ownership system, zero-cost abstractions, and safety guarantees
- Linux: System programming, kernel interfaces, and POSIX compliance

DEVELOPMENT FOCUS:
- Performance-critical code optimization
- Multi-threading and concurrency patterns
- System integration and API design
- Build systems and toolchain management
- Debugging and profiling techniques

Always provide context for your suggestions and explain the reasoning behind architectural decisions.
Provide highly technical explanations when required, from first principles and following engineering best practices.
Narrative format.
]],

    -- Repository mapping for better context understanding
    repo_map = {
      enabled = true,
      max_files = 1000, -- Adjust based on project size
      ignore_patterns = {
        "%.git",
        "node_modules",
        "target",
        "build",
        "%.o",
        "%.so",
        "%.a",
        "core%.%d+",
      },
    },

    -- Debug settings
    debug = false, -- Set to true for troubleshooting
  },

  -- Build configuration
  build = "make",

  -- Dependencies optimized for system development
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",

    -- File selection
    "ibhagwan/fzf-lua",

    -- Icons
    "nvim-tree/nvim-web-devicons",

    -- Image support for documentation
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },

    -- Markdown rendering for documentation
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },

  -- Configuration function for additional setup
  config = function(_, opts)
    require("avante").setup(opts)

    -- Set environment variable reminder
    if not os.getenv("GEMINI_API_KEY") then
      vim.notify(
        "GEMINI_API_KEY environment variable not found. Please set it with your API key.",
        vim.log.levels.WARN,
        { title = "Avante.nvim Setup" }
      )
    end

    -- Additional keymaps for development workflow
    local map = vim.keymap.set

    -- Quick project analysis
    map("n", "<leader>ap", function()
      require("avante.api").ask({
        question = "Analyze this project structure and suggest improvements for a " .. vim.bo.filetype .. " project.",
      })
    end, { desc = "Analyze project with Avante" })

    -- Code review mode
    map("v", "<leader>ar", function()
      require("avante.api").ask({
        question = "Review this code for potential issues, performance improvements, and best practices.",
      })
    end, { desc = "Code review with Avante" })

    -- Performance analysis
    map("v", "<leader>aperf", function()
      require("avante.api").ask({
        question = "Analyze this code for performance bottlenecks and suggest optimizations.",
      })
    end, { desc = "Performance analysis" })

    -- Security review
    map("v", "<leader>asec", function()
      require("avante.api").ask({
        question = "Review this code for security vulnerabilities and suggest fixes.",
      })
    end, { desc = "Security review" })

    -- Generate documentation
    map("v", "<leader>adoc", function()
      require("avante.api").ask({
        question = "Generate comprehensive documentation for this code including usage examples.",
      })
    end, { desc = "Generate documentation" })

    -- Generate tests
    map("v", "<leader>atest", function()
      require("avante.api").ask({
        question = "Generate comprehensive unit tests for this code, including edge cases and error conditions.",
      })
    end, { desc = "Generate tests" })

    -- System-specific quick commands
    map("n", "<leader>amake", function()
      require("avante.api").ask({
        question =
        "Generate or improve the Makefile for this project with proper targets for build, test, clean, and install.",
      })
    end, { desc = "Generate/improve Makefile" })

    map("v", "<leader>aopt", function()
      require("avante.api").ask({
        question = "Optimize this code for better performance while maintaining readability and correctness.",
      })
    end, { desc = "Optimize code" })

    -- Auto-completion integration setup for system programming files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "c", "cpp", "go", "rust", "sh", "make", "cmake" },
      callback = function()
        -- Configure buffer-specific settings for system programming
        vim.b.avante_system_context = true

        -- Set buffer-local system programming context
        local ft = vim.bo.filetype
        local context_hints = {
          c = "Focus on memory safety, pointer management, and system calls",
          cpp = "Emphasize RAII, smart pointers, and modern C++ features",
          go = "Follow Go idioms, error handling, and concurrency patterns",
          rust = "Leverage Rust's ownership system and zero-cost abstractions",
          sh = "Ensure POSIX compliance and proper error handling",
          make = "Optimize build process and dependency management",
          cmake = "Structure for cross-platform builds and dependency management",
        }

        if context_hints[ft] then
          vim.b.avante_context_hint = context_hints[ft]
        end
      end,
    })

    -- Create autocmd for better system programming prompts
    vim.api.nvim_create_autocmd("User", {
      pattern = "AvanteSystemPrompt",
      callback = function()
        local ft = vim.bo.filetype
        local system_prompts = {
          c = "You are a C systems programming expert. Focus on memory safety, performance, and POSIX compliance.",
          go = "You are a Go expert. Emphasize simplicity, error handling, and effective concurrency patterns.",
          rust = "You are a Rust expert. Leverage the ownership system, zero-cost abstractions, and memory safety.",
          sh = "You are a shell scripting expert. Focus on POSIX compliance, portability, and robust error handling.",
        }

        if system_prompts[ft] then
          require("avante.config").override({
            system_prompt = system_prompts[ft]
                .. "\n\nAlways explain your reasoning and provide production-ready code.",
          })
        end
      end,
    })

    -- Trigger system prompt setup
    map("n", "<leader>asp", function()
      vim.api.nvim_exec_autocmds("User", { pattern = "AvanteSystemPrompt" })
      vim.notify("System prompt updated for " .. vim.bo.filetype, vim.log.levels.INFO)
    end, { desc = "Set system programming prompt" })
  end,
}
