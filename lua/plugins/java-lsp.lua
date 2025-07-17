-- plugins/java-lsp.lua
return {
  "mfussenegger/nvim-jdtls",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "saghen/blink.cmp",
  },
  ft = { "java" },
  config = function()
    local jdtls = require("jdtls")

    -- Configuration function that will be called for each Java buffer
    local function setup_jdtls()
      -- Get Mason registry
      local mason_registry = require("mason-registry")
      local jdtls_pkg = mason_registry.get_package("jdtls")
      local jdtls_path = jdtls_pkg:get_install_path()

      -- Platform detection
      local system = vim.loop.os_uname().sysname
      local config_name = "config_linux"
      if system == "Darwin" then
        config_name = "config_mac"
      elseif system:match("Windows") then
        config_name = "config_win"
      end

      -- Enhanced root directory detection - this is crucial for Maven projects
      local root_markers = {
        ".git",
        "pom.xml", -- Maven marker should be first priority
        "build.gradle",
        "build.gradle.kts",
        "gradlew",
        "mvnw",
        ".project",
        "settings.gradle",
        "settings.gradle.kts"
      }

      local function find_root(markers)
        local root_dir = require("jdtls.setup").find_root(markers)
        if not root_dir then
          -- Fallback: look for pom.xml specifically
          local current_dir = vim.fn.expand("%:p:h")
          while current_dir ~= "/" and current_dir ~= "" do
            if vim.fn.filereadable(current_dir .. "/pom.xml") == 1 then
              return current_dir
            end
            current_dir = vim.fn.fnamemodify(current_dir, ":h")
          end
          return vim.fn.getcwd()
        end
        return root_dir
      end

      -- Workspace detection - make it project-specific
      local function get_workspace_dir()
        local root_dir = find_root(root_markers)
        local project_name = vim.fn.fnamemodify(root_dir, ":t")
        local workspace_dir = vim.fn.stdpath("data") .. "/workspace/" .. project_name
        return workspace_dir
      end

      -- Java executable detection
      local function get_java_executable()
        local specific_java = vim.fn.expand("~/.sdkman/candidates/java/21.0.2-tem/bin/java")
        if vim.fn.executable(specific_java) == 1 then
          return specific_java
        end

        local java_home = vim.env.JAVA_HOME
        if java_home then
          local java_bin = java_home .. "/bin/java"
          if vim.fn.executable(java_bin) == 1 then
            return java_bin
          end
        end

        local sdkman_java = vim.fn.expand("~/.sdkman/candidates/java/current/bin/java")
        if vim.fn.executable(sdkman_java) == 1 then
          return sdkman_java
        end

        return "java"
      end

      -- Get capabilities from blink.cmp
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Enhanced capabilities for Java
      capabilities.workspace = capabilities.workspace or {}
      capabilities.workspace.configuration = true
      capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = true }
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" }
      }

      -- Find the correct JDTLS launcher jar
      local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
      if launcher_jar == "" then
        vim.notify("JDTLS launcher jar not found in " .. jdtls_path, vim.log.levels.ERROR)
        return
      end

      -- Create workspace directory
      local workspace_dir = get_workspace_dir()
      vim.fn.mkdir(workspace_dir, "p")

      local root_dir = find_root(root_markers)

      -- JDTLS configuration with enhanced Maven support
      local config = {
        cmd = {
          get_java_executable(),
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-Xms1g",
          "-Xmx4g", -- Increased memory for better dependency resolution
          -- Enhanced JVM arguments for Java 21
          "--add-modules=ALL-SYSTEM",
          "--add-opens", "java.base/java.util=ALL-UNNAMED",
          "--add-opens", "java.base/java.lang=ALL-UNNAMED",
          "--add-opens", "java.base/java.io=ALL-UNNAMED",
          "--add-opens", "java.base/java.nio=ALL-UNNAMED",
          "--add-opens", "java.base/sun.nio.fs=ALL-UNNAMED",
          "--add-opens", "java.base/java.net=ALL-UNNAMED",
          "--add-opens", "java.base/java.security=ALL-UNNAMED",
          "--add-opens", "java.base/java.text=ALL-UNNAMED",
          "--add-opens", "java.desktop/java.awt.font=ALL-UNNAMED",
          "-Djava.awt.headless=true",
          "-jar", launcher_jar,
          "-configuration", jdtls_path .. "/" .. config_name,
          "-data", workspace_dir,
        },

        root_dir = root_dir,
        capabilities = capabilities,

        settings = {
          java = {
            eclipse = {
              downloadSources = true,
            },
            configuration = {
              updateBuildConfiguration = "automatic", -- Changed from "interactive"
              runtimes = {
                {
                  name = "JavaSE-21",
                  path = vim.fn.expand("~/.sdkman/candidates/java/21.0.2-tem"),
                  default = true,
                },
              }
            },
            maven = {
              downloadSources = true,
              updateSnapshots = true, -- Add this for snapshot dependencies
            },
            -- Enhanced import settings
            import = {
              maven = {
                enabled = true,
              },
              gradle = {
                enabled = true,
              },
              exclusions = {
                "**/node_modules/**",
                "**/.metadata/**",
                "**/archetype-resources/**",
                "**/META-INF/maven/**",
              },
            },
            implementationsCodeLens = {
              enabled = true,
            },
            referencesCodeLens = {
              enabled = true,
            },
            references = {
              includeDecompiledSources = true,
            },
            format = {
              enabled = true,
              settings = {
                url = vim.fn.stdpath("config") .. "/lang-servers/intellij-java-google-style.xml",
                profile = "GoogleStyle",
              },
            },
            signatureHelp = {
              enabled = true,
              description = {
                enabled = true,
              },
            },
            contentProvider = {
              preferred = "fernflower"
            },
            completion = {
              favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*",
                "com.fasterxml.jackson.databind.ObjectMapper.*" -- Add Jackson support
              },
              filteredTypes = {
                "com.sun.*",
                "io.micrometer.shaded.*",
                "java.awt.*",
                "jdk.*",
                "sun.*",
              },
              importOrder = {
                "java",
                "javax",
                "com",
                "org"
              },
              -- Enhanced completion settings
              guessMethodArguments = true,
              maxResults = 50,
              postfix = {
                enabled = true,
              },
            },
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
            codeGeneration = {
              toString = {
                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
              },
              useBlocks = true,
            },
            inlayHints = {
              parameterNames = {
                enabled = "all",
              },
            },
            -- Re-enable autobuild for proper dependency resolution
            autobuild = {
              enabled = true,
            },
            maxConcurrentBuilds = 2, -- Allow some concurrency
            -- Add this to help with Maven dependency resolution
            project = {
              referencedLibraries = {
                "lib/**/*.jar",
                "target/dependency/*.jar",
              },
            },
          }
        },

        flags = {
          allow_incremental_sync = true,
          debounce_text_changes = 150, -- Slightly higher debounce
        },

        init_options = {
          bundles = {},
          extendedClientCapabilities = {
            progressReportProvider = true, -- Re-enable progress reporting
            classFileContentsSupport = true,
            generateToStringPromptSupport = true,
            hashCodeEqualsPromptSupport = true,
            advancedExtractRefactoringSupport = true,
            advancedOrganizeImportsSupport = true,
            generateConstructorsPromptSupport = true,
            generateDelegateMethodsPromptSupport = true,
            moveRefactoringSupport = true,
          },
        },

        on_attach = function(client, bufnr)
          -- Java-specific keymaps
          local opts = { buffer = bufnr, silent = true }

          -- Java-specific actions
          vim.keymap.set("n", "<leader>jo", function()
            require("jdtls").organize_imports()
          end, vim.tbl_extend("force", opts, { desc = "Java: Organize imports" }))

          vim.keymap.set("n", "<leader>jv", function()
            require("jdtls").extract_variable()
          end, vim.tbl_extend("force", opts, { desc = "Java: Extract variable" }))

          vim.keymap.set("v", "<leader>jv", function()
            require("jdtls").extract_variable(true)
          end, vim.tbl_extend("force", opts, { desc = "Java: Extract variable" }))

          vim.keymap.set("n", "<leader>jc", function()
            require("jdtls").extract_constant()
          end, vim.tbl_extend("force", opts, { desc = "Java: Extract constant" }))

          vim.keymap.set("v", "<leader>jc", function()
            require("jdtls").extract_constant(true)
          end, vim.tbl_extend("force", opts, { desc = "Java: Extract constant" }))

          vim.keymap.set("v", "<leader>jm", function()
            require("jdtls").extract_method(true)
          end, vim.tbl_extend("force", opts, { desc = "Java: Extract method" }))

          -- Test running
          vim.keymap.set("n", "<leader>jt", function()
            require("jdtls").test_class()
          end, vim.tbl_extend("force", opts, { desc = "Java: Test class" }))

          vim.keymap.set("n", "<leader>jT", function()
            require("jdtls").test_nearest_method()
          end, vim.tbl_extend("force", opts, { desc = "Java: Test nearest method" }))

          -- Project management
          vim.keymap.set("n", "<leader>ju", function()
            require("jdtls").update_project_config()
          end, vim.tbl_extend("force", opts, { desc = "Java: Update project config" }))

          -- Compile workspace
          vim.keymap.set("n", "<leader>jw", function()
            require("jdtls").compile("incremental")
          end, vim.tbl_extend("force", opts, { desc = "Java: Compile workspace" }))

          -- Clean and full compile
          vim.keymap.set("n", "<leader>jW", function()
            require("jdtls").compile("full")
          end, vim.tbl_extend("force", opts, { desc = "Java: Clean and compile workspace" }))

          -- Add Maven-specific commands
          vim.keymap.set("n", "<leader>jM", function()
            vim.cmd("!mvn clean compile")
          end, vim.tbl_extend("force", opts, { desc = "Java: Maven clean compile" }))

          vim.keymap.set("n", "<leader>jD", function()
            vim.cmd("!mvn dependency:resolve")
          end, vim.tbl_extend("force", opts, { desc = "Java: Maven resolve dependencies" }))

          -- Enable inlay hints if supported
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end

          -- Auto-organize imports on save
          local group = vim.api.nvim_create_augroup("JavaLspImports" .. bufnr, { clear = true })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            buffer = bufnr,
            callback = function()
              vim.schedule(function()
                pcall(require("jdtls").organize_imports)
              end)
            end,
          })

          vim.notify("Java LSP attached successfully to " .. (root_dir or "unknown project"), vim.log.levels.INFO)
        end,

        on_init = function(client, _)
          vim.notify("JDTLS initialized for " .. (client.config.root_dir or "unknown project"), vim.log.levels.INFO)

          -- Trigger a project refresh after initialization
          vim.schedule(function()
            vim.wait(2000) -- Wait 2 seconds for JDTLS to fully initialize
            pcall(require("jdtls").update_project_config)
          end)
        end,

        on_exit = function(code, signal, client_id)
          vim.notify(
            string.format("JDTLS exited with code %d and signal %d", code, signal),
            vim.log.levels.WARN
          )
        end,
      }

      -- Start JDTLS
      jdtls.start_or_attach(config)
    end

    -- Set up autocommand to initialize JDTLS for Java files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        vim.schedule(setup_jdtls)
      end,
      group = vim.api.nvim_create_augroup("jdtls_setup", { clear = true }),
    })

    -- Enhanced commands for debugging
    vim.api.nvim_create_user_command("JdtlsRestart", function()
      vim.cmd("LspRestart jdtls")
    end, { desc = "Restart JDTLS" })

    vim.api.nvim_create_user_command("JdtlsUpdateConfig", function()
      require("jdtls").update_project_config()
    end, { desc = "Update JDTLS project config" })

    vim.api.nvim_create_user_command("JdtlsWorkspaceRefresh", function()
      vim.lsp.buf.execute_command({
        command = "java.clean.workspace",
        arguments = {},
      })
    end, { desc = "Clean JDTLS workspace" })
  end,
}
