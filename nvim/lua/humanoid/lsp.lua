-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
    debounce_text_changes = 150,
}

-- C/C++ lsp
require'lspconfig'.clangd.setup {
  on_attach = on_attach,
  flags = lsp_flags,
  cmd = {
   "clangd", "--background-index",
  },
  filetypes = { "c", "cpp", "objc", "objcpp" },
}

-- Python lsp
require'lspconfig'.pyright.setup {
  on_attach = on_attach,
  flags = lsp_flags,
  cmd = {
    "pyright-langserver", "--stdio"
  },
  filetypes = { "python", "py" },
  python = {
    analysis = {
      autoSearchPaths = true,
      diagnosticMode = "workspace",
      useLibraryCodeForTypes = true
    }
  }
}

-- Rust lsp
require'lspconfig'.rust_analyzer.setup{
  on_attach = on_attach,
  flags = lsp_flags,
  cmd = { "rust-analyzer" },
    filetypes = { "rust", "rs"},
    settings = {
        ["rust-analyzer"] = {
            inlayHints = {
                typeHints = true
            },
            cargo = {
                allFeatures = true
            },
            checkOnSave = {
                  command = "clippy"
            },
            diagnostic = {
                enable = true
            },
        },
    }, 
}

-- Go lsp
require'lspconfig'.gopls.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    cmd = { "gopls" },
    filetypes = { "go", "gomod ", "gowork", "gotmpi" },
    single_file_support = true
}

-- Javascript & Typescript
require'lspconfig'.tsserver.setup{
    on_attach = on_attach,
    flags = lsp_flags,
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    single_file_support = true
}

-- Lua lsp 
require'lspconfig'.sumneko_lua.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    single_file_support = true,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        --library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

-- HTML lsp
-- Enabling broadcast snippet capabilities
--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.html.setup {
    capabilities = capabilities;
    on_attach = on_attach,
    flags = lsp_flags,
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html", "js" },
    single_file_support = true,
    init_options = {
    configurationSection = { "html", "css", "javascript" },
    embeddedLanguages = {
        css = true,
        javascript = true
    },
    provideFormatter = true
  }
}

-- Lsp Completion or The Suggestion thingy 
local cmp = require'cmp'
require("luasnip.loaders.from_vscode").lazy_load()

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<TAB>'] = cmp.mapping.confirm({ select = true }),
    }),
    window = {
       completion = cmp.config.window.bordered(),
       documentation = cmp.config.window.bordered(),
    },
    sources = cmp.config.sources({
       { name = 'nvim_lsp_signature_help' },
       { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
       { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })
