return {
    -- Mason + LSP config
    {
        "mason-org/mason.nvim",
        build = ":MasonUpdate",
        config = true,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = {
                "clangd", -- C/C++
                "ocamllsp", -- OCaml
                "html", -- HTML
                "cssls", -- CSS
                "jdtls", -- Java
                "ts_ls", -- JavaScript / TypeScript (anciennement tsserver)
                "pyright", -- Python (serveur LSP principal)
                -- rust_analyzer géré par rustaceanvim
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mfussenegger/nvim-jdtls", -- Plugin spécialisé pour Java
        },
        config = function()
            local servers = { "clangd", "ocamllsp", "html", "cssls", "ts_ls", "pyright" }
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
                -- Désactiver le formatage LSP (conform.nvim s'en charge)
                client.server_capabilities.documentFormattingProvider = false

                -- Activer l'auto-indentation
                vim.bo[bufnr].autoindent = true
                vim.bo[bufnr].smartindent = true
                vim.bo[bufnr].cindent = true
            end

            -- Configuration des serveurs non-Java et non-Rust (géré par rustaceanvim)
            for _, server in ipairs(servers) do
                if server == "pyright" then
                    -- Configuration spécifique pour Python avec Pyright
                    lspconfig[server].setup({
                        on_attach = on_attach,
                        capabilities = get_capabilities(),
                        settings = {
                            python = {
                                analysis = {
                                    typeCheckingMode = "basic", -- ou "strict" pour plus de vérifications
                                    autoSearchPaths = true,
                                    diagnosticMode = "workspace",
                                    useLibraryCodeForTypes = true,
                                    autoImportCompletions = true,
                                },
                            },
                        },
                    })
                else
                    lspconfig[server].setup({
                        on_attach = on_attach,
                        capabilities = get_capabilities(),
                    })
                end
            end

            -- Configuration spéciale pour Java avec nvim-jdtls
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "java",
                callback = function()
                    local jdtls = require("jdtls")
                    local home = os.getenv("HOME")
                    local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
                    local workspace_path = home
                        .. "/.local/share/eclipse/"
                        .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

                    -- Détection automatique de l'OS
                    local config_os = "config_linux"
                    if vim.fn.has("mac") == 1 then
                        config_os = "config_mac"
                    elseif vim.fn.has("win32") == 1 then
                        config_os = "config_win"
                    end

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
                            jdtls_path .. "/" .. config_os,
                            "-data",
                            workspace_path,
                        },
                        root_dir = require("jdtls.setup").find_root({
                            ".git",
                            "mvnw",
                            "gradlew",
                            "pom.xml",
                            "build.gradle",
                        }),
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
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        main = "nvim-treesitter.configs",
        opts = {
            ensure_installed = {
                "c",
                "cpp",
                "ocaml",
                "html",
                "css",
                "java",
                "javascript",
                "typescript",
                "rust",
                "python",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "markdown",
                "markdown_inline",
                "json",
                "yaml",
            },
            sync_install = false,
            auto_install = true,

            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },

            indent = {
                enable = true,
            },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },

            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["aa"] = "@parameter.outer",
                        ["ia"] = "@parameter.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]]"] = "@class.outer",
                    },
                    goto_next_end = {
                        ["]M"] = "@function.outer",
                        ["]["] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.outer",
                        ["[["] = "@class.outer",
                    },
                    goto_previous_end = {
                        ["[M"] = "@function.outer",
                        ["[]"] = "@class.outer",
                    },
                },
            },
        },
    },

    -- Plugins spécialisés pour Python
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap",
            "mfussenegger/nvim-dap-python",
            { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
        },
        lazy = false,
        config = function()
            require("venv-selector").setup({
                -- Add empty table or your options here
            })
        end,
        keys = {
            { ",v", "<cmd>VenvSelect<cr>" },
        },
    },

    -- Plugin pour le debugging Python (optionnel)
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        config = function()
            local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
            require("dap-python").setup(path)
        end,
    },

    -- Plugin pour l'auto-formatage avec conform.nvim
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>f",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        opts = {
            formatters_by_ft = {
                python = { "isort", "black" }, -- isort pour les imports, black pour le formatage général
                javascript = { "prettier" },
                typescript = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                -- java = { "google-java-format" }, -- Optionnel : décommenter si vous voulez formater Java
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        },
        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },

    -- Configuration spécifique Python pour l'indentation
    {
        "Vimjas/vim-python-pep8-indent",
        ft = "python",
    },
}
