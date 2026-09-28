local vault = vim.fn.expand("~/iso/notes")
-- ~/iso is a symlink to /Volumes/iso; match buffers opened through either path.
local vault_md = vim.fn.join({ vault .. "/*.md", vim.fn.resolve(vault) .. "/*.md" }, ",")

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  event = {
    "BufReadPre " .. vault_md,
    "BufNewFile " .. vault_md,
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "iso",
        path = vault,
      },
    },
    picker = {
      name = "snacks.picker",
    },
    ui = {
      enable = true,
    },
    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
    },
    -- Timestamp-based IDs with slugified title
    note_id_func = function(title)
      local suffix = title and title ~= "" and title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          or (function()
            local s = ""
            for _ = 1, 6 do
              s = s .. string.char(math.random(97, 122))
            end
            return s
          end)()
      return tostring(os.time()) .. "-" .. suffix
    end,
    new_notes_location = "notes_subdir",
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
    attachments = {
      folder = "assets/imgs",
    },
    legacy_commands = false,
  },
  keys = {
    { "<leader>on", "<cmd>Obsidian new<cr>",          desc = "New Note" },
    { "<leader>oo", "<cmd>Obsidian quick_switch<cr>", desc = "Open Note" },
    { "<leader>os", "<cmd>Obsidian search<cr>",       desc = "Search Notes" },
    { "<leader>ob", "<cmd>Obsidian backlinks<cr>",    desc = "Backlinks" },
    { "<leader>ot", "<cmd>Obsidian tags<cr>",         desc = "Tags" },
    { "<leader>oL", "<cmd>Obsidian links<cr>",        desc = "Note Links" },
    { "<leader>or", "<cmd>Obsidian rename<cr>",       desc = "Rename Note" },
    { "<leader>oi", "<cmd>Obsidian template<cr>",     desc = "Insert Template" },
    { "<leader>op", "<cmd>Obsidian paste_img<cr>",    desc = "Paste Image" },
    { "<leader>ow", "<cmd>Obsidian workspace<cr>",    desc = "Switch Workspace" },
    { "<leader>od", "<cmd>Obsidian today<cr>",        desc = "Today's Daily Note" },
    { "<leader>oy", "<cmd>Obsidian yesterday<cr>",    desc = "Yesterday's Daily Note" },
    { "<leader>oY", "<cmd>Obsidian tomorrow<cr>",     desc = "Tomorrow's Daily Note" },
    -- `:` rather than <cmd> so the visual range is passed through.
    { "<leader>oe", ":Obsidian extract_note<cr>",     mode = "v", desc = "Extract to Note" },
    { "<leader>ol", ":Obsidian link_new<cr>",         mode = "v", desc = "Link to New Note" },
  },
}
