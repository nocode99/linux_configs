require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    disable = function(lang, bufnr)
      if lang == "javascript" then
        return vim.api.nvim_buf_line_count(bufnr) > 10000
      end
      return vim.api.nvim_buf_line_count(bufnr) > 50000
    end,
  },
  indent = {
    enable = true,
    disable = function(lang, bufnr)
      if lang == "python" then
        return true
      end
      return vim.api.nvim_buf_line_count(bufnr) > 10000
    end,

  },
  autotag = {
    enable = true,
  },
  ensure_installed = {
    "bash",
    "bibtex",
    "c",
    "comment",
    "cpp",
    "css",
    "dockerfile",
    "dot",
    "gdscript",
    "go",
    "gomod",
    "graphql",
    "hcl",
    "html",
    "java",
    "javascript",
    "jsdoc",
    "json",
    "json5",
    "jsonc",
    "julia",
    "kotlin",
    "latex",
    "ledger",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "mermaid",
    "ocaml",
    "php",
    "prisma",
    "python",
    "query",
    "r",
    "regex",
    "rst",
    "ruby",
    "rust",
    "svelte",
    "terraform",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "yaml",
  },
})
