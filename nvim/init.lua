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
  {'VonHeikemen/lsp-zero.nvim', branch = 'v4.x'}, -- LSP integrations
  {'neovim/nvim-lspconfig'}, -- More LSP stuff
  {'hrsh7th/cmp-nvim-lsp'}, -- Agaim
  {'hrsh7th/nvim-cmp',
    commit = 'b356f2c'
  },
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

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if vim.tbl_contains({ 'null-ls' }, client.name) then  -- blacklist lsp
      return
    end
    require("lsp_signature").on_attach({
      -- ... setup options here ...
    }, bufnr)



    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
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
local cmp = require('cmp')
cmp.setup({
  completion = {
    autocomplete = false
  },
  sources = {
    {name = 'nvim_lsp'},
    {name = 'buffer'},
  },
  snippet = {
    expand = function(args)
      -- You need Neovim v0.10 to use vim.snippet
      vim.snippet.expand(args.body)
    end,
  },
    mapping = cmp.mapping.preset.insert({
    -- Confirm completion
    ['<CR>'] = cmp.mapping.confirm({select = true}),

    -- Scroll up and down the documentation window
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),   
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
})

-- Setting up LSP
require('lspconfig').bashls.setup({})
require('lspconfig').jsonls.setup({})
require('lspconfig').clangd.setup({capabilities = {
  offsetEncoding = { "utf-16" },
  cmd = {
    "clangd",
    "--background-index",
    "--suggest-missing-includes",
    "--cross-file-rename",
  },
}})
require('lspconfig').gopls.setup({})
require('lspconfig').rust_analyzer.setup({})
-- Spelling
require('lspconfig').typos_lsp.setup({})
-- Grammar (MD and comments)
require('lspconfig').harper_ls.setup {
  settings = {
    ["harper-ls"] = {
      userDictPath = "~/dict.txt",
      fileDictPath = "~/.harper/",
    }
  },
}
-- Enable alt+hjkl to move line / selection
require('mini.move').setup() 
-- File browser
require("oil").setup()

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

