-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ','


-- stylua: ignore start
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'                                                         -- Package manager
  use { 'tpope/vim-fugitive',                                                          -- Git commands in nvim
    opt = true,
    cmd = { 'Git', 'Gitsigns' },
    config = function()
      require('packages.fugitive');
    end
  }
  use { 'tpope/vim-rhubarb',                                                           -- Fugitive-companion to interact with github
    requires = { 'tpope/vim-fugitive', opt = true },
    -- opt = true,
    cmd = { 'Git', 'Gitsigns' },
    config = function()
      require('packages.rhubarb');
    end
  }
  use { 'lewis6991/gitsigns.nvim',                                                     -- Add git related info in the signs columns and popups
    requires = { 'nvim-lua/plenary.nvim', opt = true },
    -- opt = true,
    cmd = { 'Git', 'Gitsigns' },
    config = function()
      require('packages.Gitsigns');
    end
  }
  use { 'numToStr/Comment.nvim',                                                       -- "gc" to comment visual regions/lines
    opt = false,
    config = function()
      require('packages.comment');
    end
  }
  use { 'nvim-treesitter/nvim-treesitter',                                             -- Highlight, edit, and navigate code
    opt = false,                                                                       -- no lazy load -> always proper highlighting and formatting
    config = function()
      require('packages.treesitter');
    end
  }
  use { 'nvim-treesitter/nvim-treesitter-textobjects',                                 -- Additional textobjects for treesitter
   after = { 'nvim-treesitter' },
  }

  use 'neovim/nvim-lspconfig'                                                          -- Collection of configurations for built-in LSP client
  use 'williamboman/mason.nvim'                                                        -- Manage external editor tooling i.e LSP servers
  use 'williamboman/mason-lspconfig.nvim'                                              -- Automatically install language servers to stdpath
  use { 'hrsh7th/nvim-cmp', requires = { 'hrsh7th/cmp-nvim-lsp' } }                    -- Autocompletion
  use { 'L3MON4D3/LuaSnip', requires = { 'saadparwaiz1/cmp_luasnip' } }                -- Snippet Engine and Snippet Expansion

  use { 'mhartington/formatter.nvim',                                      -- use advanced diagnostics with automated formatting
    config = function()
      require('packages.formatter');
    end
  }

  use { 'Mofiqul/dracula.nvim',                                                        -- use darcula colortheme
    opt = false,
    config = function()
      require('packages.dracula');
    end
  }
  use { 'nvim-lualine/lualine.nvim',                                                   -- Fancier statusline
    opt = false,
    requires = { 'kyazdani42/nvim-web-devicons',
      'Mofiqul/dracula.nvim', opt = true },
    config = function()
      require('packages.LuaLine');
    end
  }
  use { 'lukas-reineke/indent-blankline.nvim',                                         -- Add indentation guides even on blank lines
    opt = false,
    config = function()
      require('packages.indent_blankline');
    end
  }
  use 'tpope/vim-sleuth'                                                               -- Detect tabstop and shiftwidth automatically

  use { 'junegunn/fzf',                                                                -- Install fzf and set base requirements instead of telescope
    requires = { 'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim', }, -- opt = true },
    run = './install --bin',
    opt = true,
    cmd = { 'FZF', 'FzfLua' },
    -- keys = { '<leader>' },
  }
  use { 'ibhagwan/fzf-lua',                                                            -- Fuzzy finder for lua
    requires = { 'kyazdani42/nvim-web-devicons', 'nvim-lua/popup.nvim',                -- popup for nice fzf looks
      'nvim-lua/plenary.nvim', }, -- opt = true },
    opt = true,
    cmd = { 'FZF', 'FzfLua' },
    -- keys = { '<leader>' },
    config = function()
      require('packages.FzfLua');
    end
  }

  use { 'kyazdani42/nvim-tree.lua',                                                    -- Use NerdTree
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    -- opt = true,  -- for lazy loading lua.packages
    cmd = { 'NvimTreeToggle', 'NvimTreeFindFile' },
    config = function()
      -- put settings in seperate files for organisation and overview
      -- folder lua.packages with file for each long settings part
      require('packages.nvim-tree');
    end
  }
  use { 'folke/which-key.nvim',
    opt = false,
    cmd = { 'WhichKey' },
    config = function()
      require('packages.WhichKey');
    end
  }

  if is_bootstrap then
    require('packer').sync()
  end
end)
-- stylua: ignore end

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.numberwidth = 2

-- set min cursor distance from screen border
vim.o.scrolloff = 8

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
-- enable dracula colorscheme
vim.cmd[[colorscheme dracula]]
vim.o.termguicolors = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.o.syntax = true
vim.o.autoindent = true
vim.o.colorcolumn = 90
vim.o.laststatus = 2

vim.o.tabstop = 4

-- set shortcut for disable highlighting noh
vim.api.nvim_set_keymap( "n", "<esc><esc>", ":noh<cr>", {
  noremap = true}
)

-- disable mouse
vim.opt.mouse = ""

-- further display and indentation settings
vim.o.foldlevel = 99
vim.opt.linebreak = true
vim.opt.textwidth = 90
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true


require('additional')
require('mappings')
require('lsp-settings')

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
