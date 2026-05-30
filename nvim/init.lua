vim.pack.add {
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/stevearc/oil.nvim',
    'https://github.com/y9san9/y9nika.nvim',
    'https://github.com/brenoprata10/nvim-highlight-colors',
    'https://github.com/folke/tokyonight.nvim',    
    'https://github.com/EdenEast/nightfox.nvim',
    'https://github.com/joshdick/onedark.vim', 
    'https://github.com/dracula/vim',          
    'https://github.com/arcticicestudio/nord-vim',
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/ej-shafran/compile-mode.nvim',
}

vim.cmd.packadd('cfilter')
vim.cmd.packadd('nvim.undotree')
vim.cmd.packadd('nvim.difftool')


vim.g.mapleader = ' '
vim.opt.clipboard = "unnamedplus"
vim.opt.autochdir = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
--vim.opt.colorcolumn = '80'
--vim.opt.textwidth = 80
vim.opt.completeopt = 'menu,menuone,fuzzy,noinsert'
vim.opt.swapfile = false
vim.opt.confirm = true
vim.opt.linebreak = true
vim.opt.termguicolors = true
vim.opt.wildoptions:append { 'fuzzy' }
vim.opt.path:append { '**' }
vim.opt.smoothscroll = true
vim.opt.grepprg = 'rg --vimgrep --no-messages --smart-case'
vim.opt.statusline = '[%n] %<%f %h%w%m%r%=%-14.(%l,%c%V%) %P'

vim.g.compile_mode = {
     default_command = {
       python = "python3 %",
       lua = "lua %",
       javascript = "bun %",
       typescript = "bun %",
       c = "cc -Wall -Wextra -o %:r % && ./%:r",
       cpp = "cc -std=c++23 -o %:r % && ./%:r",
       java = "javac % && java %:r",
       go = "go run %",
     },
    baleia_setup = false,
    directory_change_matchers = {},
    error_threshold = require("compile-mode").level.WARNING,
    auto_jump_to_first_error = true,
    error_locus_highlight = 500,
    use_diagnostics = false,
    recompile_no_fail = true,
    ask_about_save = true,
    ask_to_interrupt = false,
    buffer_name = "*compilation*",
    time_format = "%a %b %e %H:%M:%S",
    environment = nil,
    clear_environment = false,
    input_word_completion = true,
    hidden_buffer = false,
    focus_compilation_buffer = false,
    auto_scroll = false,
    use_circular_error_navigation = false,
    debug = false,
    use_pseudo_terminal = false,
}


map = vim.keymap.set 

map("n", "<leader>w", ":write<CR>")
map("n", "<leader>q", ":quit<CR>")
map("n", "<leader>Q", ":quit!<CR>")
--map("n", "<leader>e", ":Oil<CR>")
map("n", "<C-z>", ":buffers<CR>")
map("n", "<C-x>", ":buffer")
map("i", "<A-,>", "<ESC>")
map({"n", "i"}, "<A-h>", ":below term<CR>i")
map("n", "<leader>v", ":edit $MYVIMRC<CR>")
map("n", "<leader>ff", ":find ")
map("n", "<leader>fg", ":Grep ")
map("n", "<leader>r", ":make!<CR>")
map("n", "<leader>R", ":set makeprg=")
map("n", "<leader>x", ":copen<CR>")
map("n", "<leader>c", ":!ctags -R .<CR>")
map({"n", "i"}, "<A-a>", ":below Compile<CR>" )
vim.cmd.colorscheme('nightfox')

-- disable mouse popup yet keep mouse enabled
vim.cmd [[
  aunmenu PopUp
  autocmd! nvim.popupmenu
]]

-- Only highlight with treesitter
vim.cmd('syntax on')

require("nvim-highlight-colors").setup {
    render = 'virtual',
    virtual_symbol = '⚫︎',
    virtual_symbol_suffix = '',
}
require('oil').setup {
    keymaps = { ['<C-h>'] = false },
    columns = { 'size', 'mtime' },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
}

-- Keymaps

vim.keymap.set('n', '<leader><leader>', ':Oil<CR>', { silent = true })

vim.keymap.set('n', '<leader>a', function()
    vim.cmd('$argadd %')
    vim.cmd('argdedup')
end)
vim.keymap.set('n', '<C-h>', function() vim.cmd('silent! 1argument') end)
vim.keymap.set('n', '<C-j>', function() vim.cmd('silent! 2argument') end)
vim.keymap.set('n', '<C-k>', function() vim.cmd('silent! 3argument') end)
vim.keymap.set('n', '<C-n>', function() vim.cmd('silent! 4argument') end)
vim.keymap.set('n', '<C-m>', function() vim.cmd('silent! 5argument') end)

-- Autocommands

vim.api.nvim_create_autocmd('FileType', {
    callback = function() pcall(vim.treesitter.start) end,
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        vim.o.signcolumn = 'yes:1'
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method('textDocument/completion') then
            vim.o.complete = 'o,.,w,b,u'
            vim.o.completeopt = 'menu,menuone,popup,noinsert'
            vim.lsp.completion.enable(true, client.id, args.buf)
        end
    end
})

vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function() vim.highlight.on_yank() end,
})
