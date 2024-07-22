-- general settings
vim.cmd.colorscheme "catppuccin-frappe"
vim.g.mapleader = " "
vim.wo.relativenumber = true

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- LSP settings
vim.g.coq_settings = { auto_start = 'shut-up' }
local coq = require "coq"

-- Function to get root directory
local function get_root_dir(fname, patterns)
  local dir = vim.fs.dirname(fname)
  for _, pattern in ipairs(patterns) do
    local match = vim.fn.globpath(dir, pattern)
    if match ~= "" then
      return dir
    end
  end
  return nil
end

-- Function to start LSP
local function start_lsp(server_name, cmd, patterns)
  return function(args)
    local root_dir = get_root_dir(vim.api.nvim_buf_get_name(args.buf), patterns)
    if root_dir then
      vim.lsp.start(coq.lsp_ensure_capabilities({
        name = server_name,
        cmd = cmd,
        root_dir = root_dir,
      }))
    end
  end
end

-- Create autocommands for different file types
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = start_lsp('pyright', {'pyright-langserver', '--stdio'}, {'setup.py', 'pyproject.toml'})
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {'javascript', 'typescript'},
  callback = start_lsp('tsserver', {'typescript-language-server', '--stdio'}, {'package.json', 'tsconfig.json'})
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = start_lsp('gopls', {'gopls'}, {'go.mod'})
})

-- Enable signature completion
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if vim.tbl_contains({ 'null-ls' }, client.name) then  -- blacklist lsp
      return
    end
    require("lsp_signature").on_attach({
      -- ... setup options here ...
    }, bufnr)
  end,
})

-- Formatting
vim.api.nvim_set_keymap('n', '<leader>qf', '<cmd>lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })
