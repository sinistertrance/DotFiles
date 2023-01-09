-- Built-in actions
local transform_mod = require'telescope.actions.mt'.transform_mod
local telescope =  require'telescope'
local pickers = require'telescope.pickers'
local previewers = require'telescope.previewers'
local finders = require'telescope.finders'

--keybinds
local builtin = require('telescope.builtin')
vim.g.mapleader = " "
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

require'telescope'.setup({
    defaults = {
        file_sorter = require'telescope.sorters'.get_fuzzy_file,
        color_devicons = true,

        file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
        grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
        qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

        layout_config = {
            width = 0.75,
            prompt_position = "bottom",
            preview_cutoff = 120,
        },

    mappings = {
    },

    pickers = {
        find_files = {
            theme = "dropdown",
        },
    },
    prompt_prefix = '  ',
    selection_caret = '  ',
    entry_prefix = '   ',
    path_display = { 'truncate' },

    file_ignore_patterns = {
        'dist',
        'target',
        'Downloads',
        'node_modules',
        'pack/plugins',
    },
  },
})
