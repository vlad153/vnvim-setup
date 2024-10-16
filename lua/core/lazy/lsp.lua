return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
--            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "j-hui/fidget.nvim",
        },

        config = function()
            local cmp = require('cmp')
            local cmp_lsp = require("cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities())

            require("fidget").setup({})
            require("mason").setup({
                "cspell",
            })
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "clangd",
                    "rust_analyzer",
                },
                handlers = {
                    function(server_name) -- default handler (optional)
                        require("lspconfig")[server_name].setup {
                            capabilities = capabilities
                        }
                    end,

                    ["lua_ls"] = function()
                        local lspconfig = require("lspconfig")
                        lspconfig.lua_ls.setup {
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    runtime = { version = "Lua 5.1" },
                                    diagnostics = {
                                        globals = { "vim", "it", "describe", "before_each", "after_each" },
                                    }
                                }
                            }
                        }
                    end,

                    ["clangd"] = function ()
                        local lspconfig = require("lspconfig")

                        lspconfig.clangd.setup {
                            capabilities = capabilities,
                            cmd = {
                                "clangd",
                                "--enable-config",
                                "--offset-encoding=utf-16",
                            }
                        }
                    end
                }
            })

            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- For luasnip users.
                }, {
                    { name = 'buffer' },
                    { name = 'path' },
                    { name = 'cmdline' },
                })
            })

            vim.diagnostic.config({
                -- update_in_insert = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })
        end
    },

    {
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
          "williamboman/mason.nvim",
          "nvimtools/none-ls.nvim",
        },
        config = function()
            require("mason-null-ls").setup({
                handlers = {},
            })
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        keys = {
            { "<leader>cn", "<cmd>NullLsInfo<cr>", desc = "NullLs Info" },
        },
        dependencies = { "mason.nvim", "davidmh/cspell.nvim" },
        event = { "BufReadPre", "BufNewFile" },
        opts = function()
            local cspell_config = {
                config_file_preferred_name = "cspell.json",
                find_json = function (_)
                    local path_to_cspell_config = vim.fn.expand('$HOME/.config/nvim/cspell.json')
                    return path_to_cspell_config
                end
            }

            local cspell = require("cspell")

            local ok, null_ls = pcall(require, "null-ls")
            if not ok then
                return
            end

            local sources = {
                cspell.diagnostics.with({config=cspell_config}),
                cspell.code_actions.with({config=cspell_config}),
            }

            null_ls.setup({
                sources=sources
            })
            vim.diagnostic.config({virtual_text=true})
        end,
    },
}
