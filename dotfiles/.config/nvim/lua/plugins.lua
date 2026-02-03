require("Comment").setup { mappings = false }
local comment = require "Comment.ft"
comment.beancount = ";%s"
comment.gn = "#%s"

require("nvim-surround").setup {}

vim.g.startuptime_exe_path = "nvim"
require("bigfile").setup {}

local lint = require "lint"
lint.linters_by_ft = { sh = { "shellcheck" }, python = { "ruff" } }
local lint_group = vim.api.nvim_create_augroup("lint_group", {})
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    group = lint_group,
    callback = function() lint.try_lint() end,
})

-- stylua: ignore
require("treesitter-context").setup { patterns = { python = { "if", "elif" } } }
