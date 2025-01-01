return {
  "iamcco/markdown-preview.nvim",
  enabled = require("cl.model.config").markdown_preview_enabled,
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
}
