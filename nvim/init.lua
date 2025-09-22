vim.cmd('colorscheme habamax')
vim.g.mapleader = ","
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.colorcolumn = "80"
vim.opt.number = true
vim.opt.cursorline = true

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

-- Auto-install lazy.nvim if not present
if not vim.uv.fs_stat(lazypath) then
  print('Installing lazy.nvim....')
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
  print('Done.')
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {"github/copilot.vim" },
  {"nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate"},
{
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  -- Optional dependencies
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
},
{
  "johmsalas/text-case.nvim",
  -- Switch case of variable. gau toUpper, gal toLowwer, gas toSnake, gad toDash, gac toCamel
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("textcase").setup({})
    require("telescope").load_extension("textcase")
  end,
  keys = {
    "ga", -- Default invocation prefix
    { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
  },
  cmd = {
    -- NOTE: The Subs command name can be customized via the option "substitute_command_name"
    "Subs",
    "TextCaseOpenTelescope",
    "TextCaseOpenTelescopeQuickChange",
    "TextCaseOpenTelescopeLSPChange",
    "TextCaseStartReplacingCommand",
  },
  -- available after the first executing of it or after a keymap of text-case.nvim has been used.
  lazy = false,
},
  {'folke/tokyonight.nvim'}, -- Theme
  {'neovim/nvim-lspconfig'}, -- More LSP stuff
  {'echasnovski/mini.nvim', version = '*' },
   {'ray-x/lsp_signature.nvim',
    event = "VeryLazy",
    opts = {},
    config = function(_, opts) require'lsp_signature'.setup(opts) end
  },

  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
-- or                              , branch = '0.1.x',
-- Fuzzy finder ,ff find file, ,fg find with grep in all files ,fb find in buffers
      dependencies = { 'nvim-lua/plenary.nvim' }
    }
})
vim.opt.termguicolors = true
vim.cmd.colorscheme('tokyonight')

-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'


-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}


    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gq', '<cmd>cclose<cr>', opts) -- Close the reference window
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.goto_next({severity=vim.diagnostic.severity.ERROR, wrap = true})<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

-- Setting up autocomplete / LSP
-- gd gD go to (definition), gr go to reference ctrl+o back in jumpstack,
-- ctrl+space autocomplete, <F3> autoformat <F4> code actions

-- Setting up LSP
vim.lsp.enable('bashls')
vim.lsp.enable('jsonls')
vim.lsp.enable('clangd')
vim.lsp.enable('gopls')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('mesonlsp')
vim.lsp.enable('marksman')
-- Spelling
vim.lsp.enable('typos_lsp')

-- Grammar (MD and comments)
vim.lsp.enable('harper_ls')


vim.lsp.config('clangd', {capabilities = {
  offsetEncoding = { "utf-16" },
  cmd = {
    "clangd",
    "--background-index",
    "--suggest-missing-includes",
    "--cross-file-rename",
  },
}})
vim.lsp.config('harper_ls', {
  settings = {
    ["harper-ls"] = {
      userDictPath = "~/dict.txt",
      fileDictPath = "~/.harper/",
    }
  },
})

-- Enable alt+hjkl to move line / selection
require('mini.move').setup() 
-- File browser
require("oil").setup()

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- Matching white space at end of line
vim.cmd.match('ExtraWhitespace /\\s\\+$/')
vim.cmd.highlight('ExtraWhitespace ctermbg=red guibg=red')

require('search')
vim.keymap.set('n', '<leader>g', '<cmd>lua require("search").search()<CR>', {noremap = true, silent = true})

-- Enable autocomplete
--

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

vim.keymap.set('i', '<c-space>', function()
  vim.lsp.completion.get()
end)


vim.diagnostic.config({
  -- Use the default configuration
  virtual_lines = true

  -- Alternatively, customize specific options
  -- virtual_lines = {
  --  -- Only show virtual line diagnostics for the current cursor line
  --  current_line = true,
  -- },
})
