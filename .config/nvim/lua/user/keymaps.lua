-- assign a shorter name for the api function call keymap
--local keymap = vim.api.nvim_set_keymap

--latest api function for keymap
local keymap = vim.keymap.set
-- keymap function takes four arguments keymap(mode, new binding, old binding, options)
-- Modes 
--      "n" : normal mode
--      "i" : insert mode
--      "v" : visual mode
--      "x" : visual block mode
--      "t" : term mode
--      "c" " command mode

-- Options
--      noremap : no recurse maps basically it says dont recursively keep replacing the keybindings, for example if b is replaced by a and there is a keybinding for b dont replace it and leave it as b.
--      silent : dont display any message when replaced with the new keybinding
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- complementary keybindings 
-- cprev is for quickfix list
-- bprev is for buffers
keymap("n", "[q", ":cprev<CR>", opts)
keymap("n", "]q", ":cnext<CR>", opts)
keymap("n", "[b", ":bprev<CR>", opts)
keymap("n", "]b", ":bnext<CR>", opts)

-- -- changing esc to jj in insert mode
-- using <C-[> now
-- keymap("i", "jj", "<Esc>", opts)

-- changing leader key to space
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Save and select all using command key
--keymap("n", "<C-a>", "ggVG", opts)
--keymap("n", "<C-s>", ":w<CR>", opts)

-- Better window management
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Better movement while scrolling
keymap("n", "<C-d>", "<C-d>zz", opts);
keymap("n", "<C-u>", "<C-u>zz", opts);

-- yanking and pasting to clipboard mainly use it for leetcode, modify when necessay
keymap({"n", "v"}, "<Leader>y", "\"+y", opts);
keymap({"n", "v"}, "<Leader>p", "\"+p", opts);

-- in insert move forward by one character. Added this because lsp inserts () in function call and tab does not work to cross over the ')'
keymap("i", "<C-f>", "<Esc>la", opts);

-- Visual mode
--keymap("n", ";", ":echo 'helloworld'<CR>", opts)
-- when text is selected in visual mode and indented, the selected text is released. This keymap prevents it
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Dont know what this does so going to comment it
--keymap("v", "<Leader>j", ":m '>+1<CR>gv=gv", opts)
--keymap("v", "<Leader>k", ":m '<-2<CR>gv=gv", opts)

-- move text up and down
-- in visual mode after pasting a selected text, the text which was replaced is copied into register which is not I like so to keep the previously copied text use this keymap
--keymap("v", "p", '"_dP', opts)
-- above keymap is unnecessary as this functionality is automatically provided by P

-- telescope keymaps
--keymap("n", "<leader>f", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
--local builtin = require('telescope.builtin')
--keymap("n", "<leader>f", "<cmd>lua require'telescope.builtin'.find_files()<cr>", opts)
--keymap("n", "<leader>ff", builtin.find_files, opts)
--keymap("n", "<leader>fs", builtin.live_grep, opts)
-- uncomment it if you start using it
--keymap("n", "<leader>ds", builtin.lsp_document_symbols, opts)

--keymap("n", "<c-t>", "<cmd>Telescope live_grep<cr>", opts)


-- End of file
