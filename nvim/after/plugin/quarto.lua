vim.g.slime_target = "tmux"
vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
vim.g.slime_dont_ask_default = 1

local quarto = require('quarto')

quarto.setup({
  lspFeatures = {
    languages = { 'r', 'python' },
    chunks = 'all',
    diagnostics = {
      enabled = true,
      triggers = { "BufWritePost" },
    },
    completion = {
      enabled = true,
    },
  },
  codeRunner = {
    enabled = true,
    default_method = 'slime',
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "quarto",
  callback = function()
    quarto.activate()
  end,
})

vim.keymap.set("n", "<leader>qp", quarto.quartoPreview, { desc = "Quarto preview" })
local quarto_preview_job = nil

vim.keymap.set("n", "<leader>qpf", function()
  if quarto_preview_job then
    vim.fn.jobstop(quarto_preview_job)
    quarto_preview_job = nil
    vim.notify("Quarto preview stopped", vim.log.levels.INFO)
    return
  end

  local file = vim.api.nvim_buf_get_name(0)
  vim.notify("Quarto preview: " .. vim.fn.fnamemodify(file, ":t"), vim.log.levels.INFO)

  quarto_preview_job = vim.fn.jobstart({ "quarto", "preview", file }, {
    on_stderr = function(_, data)
      for _, line in ipairs(data) do
        if line ~= "" then
          vim.schedule(function() vim.notify(line, vim.log.levels.WARN) end)
        end
      end
    end,
    on_exit = function(_, code)
      vim.schedule(function()
        if code ~= 0 then
          vim.notify("Quarto preview exited with code " .. code, vim.log.levels.ERROR)
        else
          vim.notify("Quarto preview finished", vim.log.levels.INFO)
        end
        quarto_preview_job = nil
      end)
    end,
  })
end, { desc = "Quarto preview current file (background, toggle)" })
vim.keymap.set("n", "<leader>qr", quarto.quartoClosePreview, { desc = "Quarto close preview" })
vim.keymap.set("n", "<leader>rc", require('quarto.runner').run_cell, { desc = "Run cell" })
vim.keymap.set("n", "<leader>ra", require('quarto.runner').run_above, { desc = "Run cell and above" })
vim.keymap.set("n", "<leader>rA", require('quarto.runner').run_all, { desc = "Run all cells" })
