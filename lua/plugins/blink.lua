return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "saghen/blink.compat",
    },
    version = "1.*", -- Use stable 1.x release for reliability
    event = "InsertEnter",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = {
        expand = function(snippet, _)
          return require("luasnip").lsp_expand(snippet.body) -- Use luasnip directly as fallback
        end,
      },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
        kind_icons = vim.tbl_extend("force", {}, vim.g.lazyvim_icons and vim.g.lazyvim_icons.kinds or {}),
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = vim.g.ai_cmp or false,
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "lazydev" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
        compat = {},
      },
      cmdline = {
        enabled = false,
      },
      keymap = {
        preset = "super-tab", -- Use super-tab preset as desired
        ["<C-y>"] = { "select_and_accept" },
        ["<Tab>"] = {
          function()
            local blink = require("blink.cmp")
            if blink.is_visible() then
              return blink.accept()
            elseif require("luasnip").jumpable(1) then
              return require("luasnip").jump(1)
            end
            return vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
          end,
          "fallback",
        },
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
    },
    config = function(_, opts)
      -- Ensure opts.keymap is valid to prevent nil access
      opts.keymap = opts.keymap or { preset = "super-tab" }

      -- Setup compat sources
      local enabled = opts.sources.default
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
          "force",
          { name = source, module = "blink.compat.source" },
          opts.sources.providers[source] or {}
        )
        if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
          table.insert(enabled, source)
        end
      end

      -- Unset custom prop to pass blink.cmp validation
      opts.sources.compat = nil

      -- Handle custom kind overrides
      for _, provider in pairs(opts.sources.providers or {}) do
        if provider.kind then
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1

          CompletionItemKind[kind_idx] = provider.kind
          CompletionItemKind[provider.kind] = kind_idx

          local transform_items = provider.transform_items
          provider.transform_items = function(ctx, items)
            items = transform_items and transform_items(ctx, items) or items
            for _, item in ipairs(items) do
              item.kind = kind_idx or item.kind
              item.kind_icon = (vim.g.lazyvim_icons and vim.g.lazyvim_icons.kinds[item.kind_name]) or item.kind_icon or
              nil
            end
            return items
          end

          provider.kind = nil
        end
      end

      require("blink.cmp").setup(opts)
    end,
  },
  -- Catppuccin support
  {
    "catppuccin",
    optional = true,
    opts = {
      integrations = { blink_cmp = true },
    },
  },
}
