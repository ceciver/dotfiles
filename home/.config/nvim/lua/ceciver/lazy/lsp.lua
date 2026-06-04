return {
    "neovim/nvim-lspconfig",
    commit = "1759ea68fbbb1303192020d3e59936189359e0ed",
    dependencies = {
        {
            "williamboman/mason.nvim",
            commit = "c43eeb5614a09dc17c03a7fb49de2e05de203924",
        },
        {
            "williamboman/mason-lspconfig.nvim",
            commit = "2b3d247fce06f53934174f5dfe0362c42d65c00c",
        },
        {
            "hrsh7th/cmp-nvim-lsp",
            commit = "5af77f54de1b16c34b23cba810150689a3a90312",
        },
        {
            "hrsh7th/cmp-buffer",
            commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa",
        },
        {
            "hrsh7th/cmp-path",
            commit = "91ff86cd9c29299a64f968ebb45846c485725f23",
        },
        {
            "hrsh7th/cmp-cmdline",
            commit = "8ee981b4a91f536f52add291594e89fb6645e451",
        },
        {
            "hrsh7th/nvim-cmp",
            commit = "538e37ba87284942c1d76ed38dd497e54e65b891",
        },
        {
            "L3MON4D3/LuaSnip",
            commit = "8ae1dedd988eb56441b7858bd1e8554dfadaa46d",
        },
        {
            "saadparwaiz1/cmp_luasnip",
            commit = "05a9ab28b53f71d1aece421ef32fee2cb857a843",
        },
        {
            "j-hui/fidget.nvim",
            commit = "1d1042d418ee8cb70d68f1e38db639844331c093",
        },
    },
    config = function()
        local cmp = require("cmp")
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "clangd",
                "lua_ls",
                "pyright",
                "gopls",
                "rust_analyzer",
                "tsserver",
            },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                    })
                end,

                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" },
                                },
                                workspace = {
                                    checkThirdParty = false,
                                },
                            },
                        },
                    })
                end,

                ["clangd"] = function()
                    local clangd_capabilities = vim.tbl_deep_extend("force", {}, capabilities)
                    clangd_capabilities.offsetEncoding = { "utf-16" }

                    require("lspconfig").clangd.setup({
                        capabilities = clangd_capabilities,
                        cmd = {
                            vim.fn.stdpath("data") .. "/mason/bin/clangd",
                            "--background-index",
                            "--clang-tidy",
                            "--completion-style=detailed",
                            "--header-insertion=iwyu",
                            "--query-driver=/usr/bin/clang*,/usr/bin/gcc*,/usr/bin/g++*",
                        },
                    })
                end,
            },
        })

        local has_words_before = function()
            local cursor = vim.api.nvim_win_get_cursor(0)
            local line = cursor[1]
            local col = cursor[2]

            if col == 0 then
                return false
            end

            local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
            return text:sub(col, col):match("%s") == nil
        end

        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        local cmp_insert = { behavior = cmp.SelectBehavior.Insert }
        local luasnip = require("luasnip")
        cmp.setup({
            preselect = cmp.PreselectMode.None,
            completion = {
                completeopt = "menu,menuone,noselect",
            },
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item(cmp_insert)
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item(cmp_insert)
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
            }, {
                { name = "buffer" },
                { name = "path" },
            }),
        })

        vim.diagnostic.config({
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end,
}
