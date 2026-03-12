local actions = require("telescope.actions")
local telescope = require("telescope")

telescope.setup({
  defaults = {
    -- Use ripgrep, search hidden files, exclude .git
    vimgrep_arguments = {
      "rg", "--color=never", "--no-heading", "--with-filename",
      "--line-number", "--column", "--smart-case",
      "--hidden", "--glob", "!**/.git/*",
    },
  },
  pickers = {
    find_files = {
      -- Use fd, include hidden files, respect .gitignore
      find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
    },
    buffers = {
      show_all_buffers = true,
      sort_lastused = true,
      mappings = {
        i = { ["<c-d>"] = actions.delete_buffer + actions.move_to_top },
      },
    },
  },
})

-- Load fzf extension for better sorting
telescope.load_extension("fzf")
telescope.load_extension("zotero")
