return {
    "hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
        "quangnguyen30192/cmp-nvim-ultisnips",
	},
    lazy = false,
    config = function()
        -- Below code does not work for ultisnips and use the print statement for debugging any other plugin as well

        -- local snip_status_ok, ultisnips = pcall(require, "UltiSnips")
        -- print(vim.inspect(snip_status_ok))
        -- if not snip_status_ok then
        --     print(vim.inspect(ultisnips))
        --     return
        -- end

        local cmp_status_ok, cmp = pcall(require, "cmp")
        if not cmp_status_ok then
            return
        end


        -- only if you add this supertab works
        local t = function(str)
            return vim.api.nvim_replace_termcodes(str, true, true, true)
        end

        -- needed for supertab taken from cmp-ultisnips plugin github
        local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")

        cmp.setup {
            snippet = {
                expand = function(args)
                    --luasnip.lsp_expand(args.body) -- For `luasnip` users.
                    vim.fn["UltiSnips#Anon"](args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },

            -- -- if i uncomment below no matter the value autocompletion is disabled
            -- completion = {
            --     autocomplete = true
            -- },
            mapping = {
                -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#super-tab-like-mapping refer to this for ultisnips + cmp mapping config

                -- use C-k and C-j to scroll between items in the list, can also use C-n and C-p
                -- keymap for scrolling through the autocomplete menu
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<C-n>"] = cmp.mapping.select_next_item(),

                --keymap for scrolling through the documentation menu inside the autocomplete menu
                --["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
                --["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),

                --autocomplete present full menu
                --["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),    


                -- toggle autocomplete menu
                ["<C-Space>"] = cmp.mapping({
                    i = function()
                        if cmp.visible() then
                            cmp.abort()
                        else
                            cmp.complete()
                        end
                    end,
                    -- c = function()
                    --     if cmp.visible() then
                    --         cmp.close()
                    --     else
                    --         cmp.complete()
                    --     end
                    -- end,
                }),

                -- overrides cmp completion to perform snippet expansion, while this works this automatically selects the next item on the cmp list as well which I dont want.
                -- so I used cmp_ultisnips_mappings.compose to create my own function which does what i want
                -- created using reference from https://github.com/quangnguyen30192/cmp-nvim-ultisnips/tree/main
                -- ["<Tab>"] = cmp.mapping(
                --     function(fallback)
                --         cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
                --     end,
                --     { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
                -- ),
                -- ["<S-Tab>"] = cmp.mapping(
                --     function(fallback)
                --         cmp_ultisnips_mappings.jump_backwards(fallback)
                --     end,
                --     { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
                -- ),

                ["<Tab>"] = cmp.mapping(
                function(fallback)
                    cmp_ultisnips_mappings.compose { "expand", "jump_forwards" }(fallback)
                end,
                { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
                ),

                ["<S-Tab>"] = cmp.mapping(
                function(fallback)
                    cmp_ultisnips_mappings.compose { "jump_backwards" }(fallback)
                end,
                { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
                ),
                -- supertab functionality use at your own risk. Snippet and lsp were not functionally smoothly with this setup.
                -- ["<Tab>"] = cmp.mapping({
                --     -- c is for command mode i.e. after you type ':'. For now use the native version
                --     -- if needed later upgrade to cmp-cmdline
                --
                --     -- c = function()
                --     --     if cmp.visible() then
                --     --         cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                --     --     else
                --     --         cmp.complete()
                --     --     end
                --     -- end,
                --     i = function(fallback)
                --         if cmp.visible() then
                --             cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                --         elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                --             cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
                --             --return vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
                --             --vim.api.nvim_feedkeys(":<Tab>", 'm', true)
                --         else
                --             fallback()
                --         end
                --     end,
                --     s = function(fallback)
                --         if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                --             cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
                --             --return vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
                --             --vim.api.nvim_feedkeys(":<Tab>", 'm', true)
                --         else
                --             fallback()
                --         end
                --     end
                -- }),
                -- ["<S-Tab>"] = cmp.mapping({
                --     -- c = function()
                --     --     if cmp.visible() then
                --     --         cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                --     --     else
                --     --         cmp.complete()
                --     --     end
                --     -- end,
                --     i = function(fallback)
                --         if cmp.visible() then
                --             cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                --         elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                --             cmp_ultisnips_mappings.jump_backwards(fallback)
                --             --return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
                --         else
                --             fallback()
                --         end
                --     end,
                --     s = function(fallback)
                --         if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                --             cmp_ultisnips_mappings.jump_backwards(fallback)
                --             --return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
                --         else
                --             fallback()
                --         end
                --     end
                -- }),

                --["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
                --keymap to close the autocomplete menu
                -- ["<C-e>"] = cmp.mapping {
                --   i = cmp.mapping.abort(),
                --   c = cmp.mapping.close(),
                -- },

                --keymap to complete the selected item from autocomplete menu
                -- Accept currently selected item. If none selected, `select` first item.
                -- Set `select` to `false` to only confirm explicitly selected items.
                ["<CR>"] = cmp.mapping.confirm { select = false },

            },
            sources = {
                { name = "nvim_lsp" },
                { name = "ultisnips" },
                { name = "buffer" },
                { name = "path" },
            },
            -- formatting = {
            --   fields = { "kind", "abbr", "menu" },
            --   format = function(entry, vim_item)
            --     -- Kind icons
            --     --vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            --     
            --     vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            --     vim_item.menu = ({
            --       ultisnips = "[Snippet]",
            --       buffer = "[Buffer]",
            --       --path = "[Path]",
            --     })[entry.source.name]
            --     return vim_item
            --   end,
            -- },
            -- sources = {
            --   { name = "ultisnips" },
            --   { name = "buffer" },
            --   --{ name = "path" },
            -- },
            confirm_opts = {
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
            },
            -- window = {
            --   documentation = cmp.config.window.bordered(),
            -- },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
                -- documentation = {
                --     border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                -- },
            },
            experimental = {
                ghost_text = false,
                native_menu = false,
            },
        }
    end
}
