local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    
    -- Package Manager
    use 'wbthomason/packer.nvim'
    
    -- LspConfig 
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'

    -- Cmp Plugins
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'L3MON4D3/LuaSnip'
    use 'rafamadriz/friendly-snippets'
    use 'saadparwaiz1/cmp_luasnip'
    use 'windwp/nvim-autopairs'

    -- Telescope 
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-lua/plenary.nvim'
    
    -- TreeSitter
    use 'nvim-treesitter/nvim-treesitter'
    
    -- File Explorer & DevIcons
    use 'nvim-tree/nvim-web-devicons'
    use 'nvim-tree/nvim-tree.lua'
    
    -- Lua line
    use 'nvim-lualine/lualine.nvim'

    -- ColorSchemes
    use 'sinistertrance/moonlight.nvim'

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end) 
