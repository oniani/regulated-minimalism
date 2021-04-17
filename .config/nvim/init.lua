--
-- Author: David Oniani
--
--  _       _ _     _
-- (_)_ __ (_) |_  | |_   _  __ _
-- | | '_ \| | __| | | | | |/ _` |
-- | | | | | | |_ _| | |_| | (_| |
-- |_|_| |_|_|\__(_)_|\__,_|\__,_|
--

-- List of lua modules
local filenames = {
    -- Plugin-independent, general settings
    "autocmds",
    "general",
    "mappings",

    -- Packer and plugins
    "settings.packer",
    "settings.colorscheme",
    "settings.fzf",
    "settings.statusline",
    "settings.treesitter",
    "settings.indentblankline",

    -- Language server and relates settings
    "settings.lsp.compe",
    "settings.lsp.lsp",
    "settings.lsp.signs"
}

-- Iterate and set up all of the lua modules
for _, filename in ipairs(filenames) do
    require(filename)
end
