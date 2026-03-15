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
                "html-lsp", -- HTML
                "css-lsp", -- CSS
                "jdtls", -- Java
                "typescript-language-server", -- JavaScript/TypeScript
                "eslint_d", -- Linting JS/TS (plus rapide qu'eslint)
                "pyright", -- Python
                "bash-language-server", -- Bash
                "lua-language-server", -- Lua
                "marksman", -- Markdown
                "harper-ls", -- Correcteur orthographique
                "yaml-language-server", -- YAML
                "json-lsp", -- JSON
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mfussenegger/nvim-jdtls", -- Plugin spécialisé pour Java
        },
        config = function()
            local servers = {
                "clangd",
                "ocamllsp",
                "html",
                "cssls",
                "ts_ls",
                "eslint",
                "pyright",
                "bashls",
                "lua_ls",
                "marksman",
                "harper_ls",
                "yamlls",
                "jsonls",
            }
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
                                    typeCheckingMode = "basic",
                                    autoSearchPaths = true,
                                    diagnosticMode = "workspace",
                                    useLibraryCodeForTypes = true,
                                    autoImportCompletions = true,
                                },
                            },
                        },
                    })
                elseif server == "ts_ls" then
                    -- Configuration spécifique pour JavaScript/TypeScript
                    lspconfig[server].setup({
                        on_attach = on_attach,
                        capabilities = get_capabilities(),
                        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
                        settings = {
                            typescript = {
                                inlayHints = {
                                    includeInlayParameterNameHints = "all",
                                    includeInlayFunctionParameterTypeHints = true,
                                },
                            },
                            javascript = {
                                inlayHints = {
                                    includeInlayParameterNameHints = "all",
                                    includeInlayFunctionParameterTypeHints = true,
                                },
                            },
                        },
                    })
                elseif server == "eslint" then
                    -- Configuration spécifique pour ESLint
                    lspconfig[server].setup({
                        on_attach = function(client, bufnr)
                            on_attach(client, bufnr)
                            -- Auto-fix ESLint on save
                            vim.api.nvim_create_autocmd("BufWritePre", {
                                buffer = bufnr,
                                command = "EslintFixAll",
                            })
                        end,
                        capabilities = get_capabilities(),
                    })
                elseif server == "lua_ls" then
                    -- Configuration spécifique pour Lua
                    lspconfig[server].setup({
                        on_attach = on_attach,
                        capabilities = get_capabilities(),
                        settings = {
                            Lua = {
                                runtime = {
                                    version = "LuaJIT",
                                },
                                diagnostics = {
                                    globals = { "vim" }, -- Reconnaît 'vim' comme global
                                },
                                workspace = {
                                    library = vim.api.nvim_get_runtime_file("", true),
                                    checkThirdParty = false,
                                },
                                telemetry = {
                                    enable = false,
                                },
                            },
                        },
                    })
                elseif server == "harper_ls" then
                    -- Configuration pour Harper (correcteur orthographique)
                    lspconfig[server].setup({
                        on_attach = on_attach,
                        capabilities = get_capabilities(),
                        settings = {
                            ["harper-ls"] = {
                                linters = {
                                    spell_check = true,
                                    spelled_numbers = false,
                                    an_a = true,
                                    sentence_capitalization = true,
                                    unclosed_quotes = true,
                                    wrong_quotes = false,
                                    long_sentences = true,
                                    repeated_words = true,
                                    spaces = true,
                                    matcher = true,
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
                "tsx",
                "json",
                "rust",
                "python",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "markdown",
                "markdown_inline",
                "yaml",
                "bash",
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
                    init_selection = "<CR>",
                    node_incremental = "<CR>",
                    scope_incremental = false,
                    node_decremental = "<BS>",
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

    -- Support pour Yacc et Lex (détection de fichiers uniquement)
    {
        "nvim-lua/plenary.nvim",
        lazy = false,
        config = function()
            -- Configuration de la détection des filetypes pour Yacc et Lex
            vim.filetype.add({
                extension = {
                    l = "lex",
                    y = "yacc",
                    lex = "lex",
                    flex = "lex",
                    yacc = "yacc",
                    bison = "yacc",
                },
            })
        end,
    },

    -- Plugins spécialisés pour Python
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap",
            "mfussenegger/nvim-dap-python",
            {
                "nvim-telescope/telescope.nvim",
                branch = "0.1.x",
                dependencies = { "nvim-lua/plenary.nvim" },
            },
        },
        lazy = false,
        config = function()
            require("venv-selector").setup({})
        end,
        keys = {
            { ",v", "<cmd>VenvSelect<cr>" },
        },
    },

    -- Plugin pour le debugging Python
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

    -- Configuration spécifique Python pour l'indentation
    {
        "Vimjas/vim-python-pep8-indent",
        ft = "python",
    },
}
