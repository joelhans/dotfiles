-- Suppress treesitter highlighter errors (Neovim bug with rapid edits)
local original_set_extmark = vim.api.nvim_buf_set_extmark
vim.api.nvim_buf_set_extmark = function(...)
  local ok, result = pcall(original_set_extmark, ...)
  if ok then return result end
  return 0
end

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=0")
vim.cmd("set shiftwidth=2")
vim.cmd("set textwidth=80")
vim.cmd("set linebreak")
vim.cmd("set formatoptions-=t")
vim.cmd("set number")
vim.cmd("set clipboard+=unnamedplus")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Source init.lua
vim.keymap.set('n', '<Leader>sv', ':source $MYVIMRC<CR>')
-- Unmap space in visual mode
vim.keymap.set('v', ' ', '')
-- Copy to system clipboard
vim.keymap.set({ 'n', 'v' }, "<leader>c", [["+y]])
-- Ctrl-A to copy all
vim.keymap.set({ 'n', 'v' }, '<C-a>', '<esc>gg0VG<CR>')

-- NvimTree helpers and keymaps
vim.keymap.set("n", "<leader>e", function()
  require("nvim-tree.api").tree.toggle()
end, { desc = "Toggle NvimTree" })
vim.keymap.set("n", "<leader>ec", function()
  require("nvim-tree.api").tree.collapse_all()
end, { desc = "Collapse NvimTree" })

-- Dynamic width for NvimTree based on current UI width
local function calc_nvimtree_width()
  local cols = vim.o.columns
  local w = math.floor(cols * 0.22)  -- 22% of UI width; tweak as needed
  if w < 24 then w = 24 end          -- minimum width
  if w > 48 then w = 48 end          -- maximum width
  return w
end

local plugins = {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "vim", "javascript", "html", "lua", "vimdoc", "query", "markdown", "markdown_inline" },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = {
          enable = true,
          disable = {
            "markdown", -- indentation at bullet points is worse
          },
        },
      })
    end,
  },
  {
    "davidmh/mdx.nvim",
    dependencies = {"nvim-treesitter/nvim-treesitter"}
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local function my_on_attach(bufnr)
        local api = require("nvim-tree.api")
        -- bring in default mappings first, then override with ours
        api.config.mappings.default_on_attach(bufnr)
        local opts = { buffer = bufnr, silent = true, nowait = true, desc = "Resize NvimTree window" }
        vim.keymap.set("n", ">", function()
          vim.cmd("vertical resize +" .. vim.v.count1)
        end, opts)
        vim.keymap.set("n", "<", function()
          vim.cmd("vertical resize -" .. vim.v.count1)
        end, opts)
      end

      require("nvim-tree").setup {
        view = {
          -- width can be a function on recent nvim-tree versions
          width = calc_nvimtree_width,
        },
        on_attach = my_on_attach,
      }
    end,
  }
}

local opts = {}

require("lazy").setup(plugins, opts)

local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})



require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"

-- Functions to always open nvim-tree on nvim open, and close when there are no
-- more buffers.
local function open_nvim_tree()
  local api = require("nvim-tree.api")
  api.tree.open()
  api.tree.resize(calc_nvimtree_width())
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- Auto-resize NvimTree when UI size or window layout changes
vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
  callback = function()
    local ok, api = pcall(require, "nvim-tree.api")
    if not ok then return end
    if api.tree.is_visible() then
      api.tree.resize(calc_nvimtree_width())
    end
  end,
})

-- Force spaces (no tabs) for MDX files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "mdx", "markdown.mdx" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Buffer-local < and > to resize side/auxiliary panes (keeps indent in normal files)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "query", "tsplayground", "help", "man" },
  callback = function(ev)
    local buf = ev.buf
    local opts = { buffer = buf, silent = true, nowait = true }
    vim.keymap.set("n", ">", function()
      vim.cmd("vertical resize +" .. vim.v.count1)
    end, vim.tbl_extend("force", opts, { desc = "Widen window by count" }))
    vim.keymap.set("n", "<", function()
      vim.cmd("vertical resize -" .. vim.v.count1)
    end, vim.tbl_extend("force", opts, { desc = "Narrow window by count" }))
  end,
})
