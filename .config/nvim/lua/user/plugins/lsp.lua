return {
    "neovim/nvim-lspconfig",

    dependencies = {
        "williamboman/mason.nvim",
    },

    config = function()
        local M = {}

        local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        if not status_cmp_ok then
            return
        end

        M.capabilities = vim.lsp.protocol.make_client_capabilities()
        M.capabilities.textDocument.completion.completionItem.snippetSupport = true
        M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

        M.setup = function()
        -- local signs = {
        --
        -- 	{ name = "DiagnosticSignError", text = "" },
        -- 	{ name = "DiagnosticSignWarn", text = "" },
        -- 	{ name = "DiagnosticSignHint", text = "" },
        -- 	{ name = "DiagnosticSignInfo", text = "" },
        -- }
        --
        -- for _, sign in ipairs(signs) do
        -- 	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
        -- end

        -- local config = {
        -- 	virtual_text = false, -- disable virtual text
        -- 	signs = {
        -- 		active = signs, -- show signs
        -- 	},
        -- 	update_in_insert = true,
        -- 	underline = true,
        -- 	severity_sort = true,
        -- 	float = {
        -- 		focusable = true,
        -- 		style = "minimal",
        -- 		border = "rounded",
        -- 		source = "always",
        -- 		header = "",
        -- 		prefix = "",
        -- 	},
        -- }
        --
        -- vim.diagnostic.config(config)
        --
        -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        -- 	border = "rounded",
        -- })
        --
        -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        -- 	border = "rounded",
        -- })
        end

        local function lsp_keymaps(bufnr)
            --local opts = { noremap = true, silent = true }
            --local keymap = vim.api.nvim_buf_set_keymap

            -- above keymap does not take reference to function so use below format
            --These keymaps was taken from tjdevries video
            --https://www.youtube.com/watch?v=puWgHa7k3SY&t=3541s

            local keymap = vim.keymap.set
            local opts = { noremap = true, silent = true, buffer = bufnr }
            keymap("n", "K", vim.lsp.buf.hover, opts)
            keymap("n", "gd", vim.lsp.buf.definition, opts)
            keymap("n", "gi", vim.lsp.buf.implementation, opts)
            keymap("n", "<leader>dn", vim.diagnostic.goto_next, opts)
            keymap("n", "<leader>dp", vim.diagnostic.goto_prev, opts)
            keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
            keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            keymap("n", "<leader>sr", vim.lsp.buf.references, opts)

            -- keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
            -- keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
            -- keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
            -- keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
            -- keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
            -- keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
            -- keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)
            -- keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
            -- keymap(bufnr, "n", "<leader>lI", "<cmd>LspInstallInfo<cr>", opts)
            -- keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
            -- keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
            -- keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
            -- keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
            -- keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
            -- keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
        end

        M.on_attach = function(client, bufnr)
            -- if client.name == "tsserver" then
            -- 	client.server_capabilities.documentFormattingProvider = false
            -- end
            --
            -- if client.name == "sumneko_lua" then
            -- 	client.server_capabilities.documentFormattingProvider = false
            -- end

            lsp_keymaps(bufnr)

            --plugin for automatic highlighting of word under cursor use if needed
            -- local status_ok, illuminate = pcall(require, "illuminate")
            -- if not status_ok then
            -- 	return
            -- end
            -- illuminate.on_attach(client)
        end

        local servers = {
            "lua_ls",
            "clangd",
            "pyright",
            "yamlls",
            "gopls",
        }

        -- add any mason settings if needed
        local settings = {

        }

        require("mason").setup(settings)

        local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
        if not lspconfig_status_ok then
            return
        end

        local opts = {}

        for _, server in pairs(servers) do
            opts = {
                -- on_attach = require("user.lsp.lspconfig").on_attach,
                -- capabilities = require("user.lsp.lspconfig").capabilities,
                on_attach = M.on_attach,
                capabilities = M.capabilities,
            }

            server = vim.split(server, "@")[1]

            local require_ok, conf_opts = pcall(require, "user.plugins.servers." .. server)
            if require_ok then
                opts = vim.tbl_deep_extend("force", conf_opts, opts)
            end

            lspconfig[server].setup(opts)
        end
    end,
}
