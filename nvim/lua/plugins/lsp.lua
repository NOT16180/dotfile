return {
  -- Mason + LSP config
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "clangd", -- C/C++
        "ocamllsp", -- OCaml
        "html", -- HTML
        "cssls", -- CSS
        "jdtls", -- Java
        "tsserver", -- JavaScript / TypeScript
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mfussenegger/nvim-jdtls", -- Plugin spécialisé pour Java
    },
    config = function()
      local servers = { "clangd", "ocamllsp", "html", "cssls", "tsserver" }
      local lspconfig = require("lspconfig")

      -- Fonction pour obtenir les capacités LSP
      local function get_capabilities()
        local capabilities = vim.lsp.protocol.make_client_capabilities()

        -- Si blink.cmp est disponible, utilise ses capacités
        local has_blink, blink = pcall(require, "blink.cmp")
        if has_blink then
          capabilities = blink.get_lsp_capabilities(capabilities)
        end

        return capabilities
      end

      -- Configuration commune pour tous les serveurs LSP
      local on_attach = function(client, bufnr)
        -- Activer l'auto-indentation
        vim.bo[bufnr].autoindent = true
        vim.bo[bufnr].smartindent = true
        vim.bo[bufnr].cindent = true

        -- Formatage automatique lors de la sauvegarde si le serveur le supporte
        if client.server_capabilities.documentFormattingProvider then
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormatting", {}),
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
      end

      -- Configuration des serveurs non-Java
      for _, server in ipairs(servers) do
        lspconfig[server].setup({
          on_attach = on_attach,
          capabilities = get_capabilities(),
        })
      end

      -- Configuration spéciale pour Java avec nvim-jdtls
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          local jdtls = require("jdtls")
          local home = os.getenv("HOME")
          local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
          local workspace_path = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

          local config = {
            cmd = {
              "java",
              "-Declipse.application=org.eclipse.jdt.ls.core.id1",
              "-Dosgi.bundles.defaultStartLevel=4",
              "-Declipse.product=org.eclipse.jdt.ls.core.product",
              "-Dlog.protocol=true",
              "-Dlog.level=ALL",
              "-Xmx1g",
              "--add-modules=ALL-SYSTEM",
              "--add-opens",
              "java.base/java.util=ALL-UNNAMED",
              "--add-opens",
              "java.base/java.lang=ALL-UNNAMED",
              "-jar",
              vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
              "-configuration",
              jdtls_path .. "/config_linux",
              "-data",
              workspace_path,
            },
            root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
            settings = {
              java = {
                eclipse = {
                  downloadSources = true,
                },
                configuration = {
                  updateBuildConfiguration = "interactive",
                },
                maven = {
                  downloadSources = true,
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
                },
              },
              signatureHelp = { enabled = true },
              completion = {
                favoriteStaticMembers = {
                  "org.hamcrest.MatcherAssert.assertThat",
                  "org.hamcrest.Matchers.*",
                  "org.hamcrest.CoreMatchers.*",
                  "org.junit.jupiter.api.Assertions.*",
                  "java.util.Objects.requireNonNull",
                  "java.util.Objects.requireNonNullElse",
                  "org.mockito.Mockito.*",
                },
              },
              contentProvider = { preferred = "fernflower" },
              extendedClientCapabilities = jdtls.extendedClientCapabilities,
              sources = {
                organizeImports = {
                  starThreshold = 9999,
                  staticStarThreshold = 9999,
                },
              },
              codeGeneration = {
                toString = {
                  template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                },
                useBlocks = true,
              },
            },
            capabilities = get_capabilities(),
            on_attach = function(client, bufnr)
              on_attach(client, bufnr)
            end,
            init_options = {
              bundles = {},
            },
          }

          jdtls.start_or_attach(config)
        end,
      })
    end,
  },

  -- Plugin spécialisé pour Java
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },

  -- Plugin pour l'auto-indentation avancée
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "cpp", "ocaml", "html", "css", "java", "javascript", "typescript" },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },
}
