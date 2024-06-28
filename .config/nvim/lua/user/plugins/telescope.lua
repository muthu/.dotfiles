return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        local actions = require('telescope.actions')
        require('telescope').setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-_>"] = actions.select_horizontal,
                        ["<C-\\>"] = actions.select_vertical,
                    },
                    n = {
                        ["<C-_>"] = actions.select_horizontal,
                        ["<C-\\>"] = actions.select_vertical,
                    }
                },
                pickers = {
                    find_files = {
                        -- find command used is ripgrep by default i think?
                        -- find_command = {'fd', '-H', '-i'},
                        layout_config = {
                            horizontal = {width = 0.9}
                        },
                    }
                },
                extensions = {
                    media_files = {
                        filetypes = {"png", "webp", "jpg", "jpeg"},
                    }
                }
            }
        })

        local builtin = require('telescope.builtin')
        local opts = {noremap = true, silent = true}
        local keymap = vim.keymap.set

        keymap('n', '<leader>ff', builtin.find_files, {})
        keymap('n', '<leader>ks', builtin.live_grep, {})
    end
}
