return {
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                python = { "isort", "black" },
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                lua = { "stylua" },
                sh = { "shfmt" },
                bash = { "shfmt" },
                c = { "clang-format" },
                cpp = { "clang-format" },
                java = { "google-java-format" },
                ocaml = { "ocamlformat" },
                yacc = {},
                lex = {},
            },
            formatters = {
                prettier = {
                    prepend_args = { "--tab-width", "4", "--use-tabs", "false" },
                },
                stylua = {
                    prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
                },
                ["clang-format"] = {
                    prepend_args = { "--style={IndentWidth: 4, UseTab: Never}" },
                },
                shfmt = {
                    prepend_args = { "-i", "4" },
                },
                ocamlformat = {
                    prepend_args = { "--indent=4" },
                },
            },
        },
    },
}
