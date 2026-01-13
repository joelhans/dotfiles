-- Suppress treesitter highlighter errors (Neovim bug with rapid edits)
local original_set_extmark = vim.api.nvim_buf_set_extmark
vim.api.nvim_buf_set_extmark = function(...)
  local ok, result = pcall(original_set_extmark, ...)
  if ok then return result end
  return 0
end

-- Make common editing sensible
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=0")
vim.cmd("set shiftwidth=2")
vim.cmd("set textwidth=80")
vim.cmd("set linebreak")
vim.cmd("set formatoptions-=t")
vim.cmd("set number")
vim.cmd("set clipboard+=unnamedplus")

-- Reduce mapping wait to avoid 1s delay on <leader> key sequences
vim.o.timeout = true
vim.o.timeoutlen = 300

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

-- Make sure to setup `mapleader` and `maplocalleader` before loading lazy.nvim
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

-- Dynamic width state for NvimTree
local user_tree_width_override = nil

-- Dynamic width for NvimTree based on current UI width (or user override)
local function calc_nvimtree_width()
  if user_tree_width_override and user_tree_width_override > 0 then
    return user_tree_width_override
  end
  local cols = vim.o.columns
  local w = math.floor(cols * 0.22)  -- 22% of UI width; tweak as needed
  if w < 24 then w = 24 end          -- minimum width
  if w > 48 then w = 48 end          -- maximum width
  return w
end

-- Helper: safe NvimTree resize via ex-command to match your nvim-tree version
local function nvimtree_safe_resize(w)
  local ok, api = pcall(require, "nvim-tree.api")
  if not ok or not api.tree.is_visible() then return end
  w = tonumber(w)
  if not w or w < 1 then return end
  vim.cmd("NvimTreeResize " .. w)
end

-- NvimTree helpers and keymaps
vim.keymap.set("n", "<leader>e", function()
  require("nvim-tree.api").tree.toggle()
end, { desc = "Toggle NvimTree" })
vim.keymap.set("n", "<leader>ec", function()
  require("nvim-tree.api").tree.collapse_all()
end, { desc = "Collapse NvimTree" })

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
          disable = { "markdown" },
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
        local opts = { buffer = bufnr, silent = true, nowait = true }
        -- Resize NvimTree window and persist user override so it doesn't get reset
        vim.keymap.set("n", ">", function()
          local curw = vim.api.nvim_win_get_width(0)
          user_tree_width_override = curw + vim.v.count1
          nvimtree_safe_resize(user_tree_width_override)
        end, vim.tbl_extend("force", opts, { desc = "NvimTree: widen by count" }))
        vim.keymap.set("n", "<", function()
          local curw = vim.api.nvim_win_get_width(0)
          user_tree_width_override = math.max(1, curw - vim.v.count1)
          nvimtree_safe_resize(user_tree_width_override)
        end, vim.tbl_extend("force", opts, { desc = "NvimTree: narrow by count" }))
        vim.keymap.set("n", "=", function()
          -- Reset to dynamic width (clear override)
          user_tree_width_override = nil
          nvimtree_safe_resize(calc_nvimtree_width())
        end, vim.tbl_extend("force", opts, { desc = "NvimTree: reset width" }))
      end

      require("nvim-tree").setup {
        view = {
          -- width can be a function; we respect user override when set
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

-- Open nvim-tree on startup (VimEnter). Defer with vim.schedule and avoid immediate resize.
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.schedule(function()
      local ok, api = pcall(require, "nvim-tree.api")
      if not ok then return end
      api.tree.open()
    end)
  end,
})

-- Auto-resize NvimTree when the entire UI is resized.
-- Wrap in vim.schedule to avoid window ops during the event callback.
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.schedule(function()
      local ok, api = pcall(require, "nvim-tree.api")
      if not ok then return end
      -- Clear manual override on UI resize so dynamic width reapplies
      user_tree_width_override = nil
      if api.tree.is_visible() then
        nvimtree_safe_resize(calc_nvimtree_width())
      end
    end)
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

-- Cheatsheet popup for custom shortcuts
local function open_shortcuts_popup()
  local lines = {
    "Custom shortcuts (press q or <Esc> to close)",
    "",
    "General",
    "  <leader>sv    Source init.lua (reload config)",
    "  <leader>c     Copy to system clipboard (normal/visual)",
    "  <C-a>         Select all",
    "",
    "Telescope",
    "  <leader>ff    Find files",
    "  <leader>fg    Live grep",
    "",
    "NvimTree",
    "  <leader>e     Toggle tree",
    "  <leader>ec    Collapse all",
    "  In NvimTree buffer:",
    "    >           Widen tree by [count] (default 1)",
    "    <           Narrow tree by [count]",
    "    =           Reset to dynamic width",
    "",
    "Aux panes (help/man/tsplayground/query)",
    "  >           Widen window by [count]",
    "  <           Narrow window by [count]",
  }

  local buf = vim.api.nvim_create_buf(false, true)
  if not buf or buf == 0 then return end
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'help')
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local maxw = 0
  for _, l in ipairs(lines) do
    if #l > maxw then maxw = #l end
  end
  local ui = vim.api.nvim_list_uis()[1]
  local width = math.min(maxw + 4, ui.width - 4)
  local height = math.min(#lines + 2, ui.height - 4)
  local row = math.floor((ui.height - height) / 2)
  local col = math.floor((ui.width - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    style = 'minimal',
    border = 'rounded',
    width = width,
    height = height,
    row = row,
    col = col,
  })

  -- Close helpers
  local function close_popup()
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end
  vim.keymap.set('n', 'q', close_popup, { buffer = buf, nowait = true, silent = true })
  vim.keymap.set('n', '<Esc>', close_popup, { buffer = buf, nowait = true, silent = true })
end

vim.keymap.set('n', '<leader>?', open_shortcuts_popup, { desc = 'Show custom shortcuts' })
