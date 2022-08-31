local opt = vim.opt

-- Splits
opt.splitbelow = true                 -- Horizional split to the bottom
opt.splitright = true                 -- Vertical split to the right

-- Indent
opt.autoindent = true                 -- Carry indent over to new lines
opt.tabstop = 2                       -- Replace tabs with 2 spaces
opt.shiftwidth = 2                    -- Use 2 spaces when inserting tabs
opt.expandtab = true                  -- Expand tab to spaces

-- Scroll
-- TODO: update these
opt.scrolljump = 5                    -- Scroll five lines at a time vertically
opt.sidescroll = 10                   -- Minumum columns to scroll horizontally

-- Search
opt.hlsearch = true                   -- Highlight search hits
opt.incsearch = true                  -- Enable incremental search
opt.ignorecase = true                 -- Case-insensitive search
opt.smartcase = true                  -- Except if the query has uppercase (doesn't apply for * command)

-- Display
opt.background = "dark"               -- Dark mode
opt.termguicolors = true              -- Enable 24-bit true colors
opt.cursorline = true                 -- Highlight current line
opt.ruler = true                      -- Display line and column number of the cursor
opt.number = false                    -- Hide line numbers
opt.showmatch = true                  -- Flash matching brackets on insertion
opt.matchtime = 4                     -- Duration for opt.showmatch (in units of 100 ms)

-- Misc
opt.shortmess = opt.shortmess + "a"   -- Abbreviate error messages
opt.shortmess = opt.shortmess + "A"   -- Ignore warning when swap file exists
opt.hidden = true                     -- Allow hidden buffers
opt.clipboard = "unnamed"             -- Use system clipboard
-- TODO: autoread false?
