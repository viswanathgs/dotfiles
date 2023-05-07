local opt = vim.opt

-- Split
opt.splitbelow = true                 -- Horizional split to the bottom
opt.splitright = true                 -- Vertical split to the right

-- Indent
opt.autoindent = true                 -- Carry indent over to new lines
opt.breakindent = true                -- Indent wrapped lines
opt.expandtab = true                  -- Expand tab to spaces
opt.tabstop = 2                       -- Replace tabs with 2 spaces
opt.shiftwidth = 2                    -- Use 2 spaces when inserting tabs

-- Scroll
opt.scrolljump = 1                    -- Num lines to scroll up/down when going off screen with j/k
opt.scrolloff = 3                     -- Num lines of context to show when scrolling up/down
opt.sidescroll = 10                   -- Num columns to scroll left/right when going off screen 
opt.sidescrolloff = 5                 -- Num columns of context to show when scrolling left/right

-- Search
opt.hlsearch = true                   -- Highlight search hits
opt.incsearch = true                  -- Enable incremental search
opt.ignorecase = true                 -- Case-insensitive search
opt.smartcase = true                  -- Except if the query has uppercase (doesn't apply for * command)
opt.inccommand = "nosplit"            -- Show the effects of substitute (:%s) incrementally

-- Display
opt.background = "dark"               -- Dark mode
opt.termguicolors = true              -- Enable 24-bit true colors
opt.cursorline = true                 -- Highlight current line
opt.ruler = true                      -- Display line and column number of the cursor
opt.number = false                    -- Hide line numbers
opt.showmatch = true                  -- Flash matching brackets on insertion
opt.matchtime = 4                     -- Duration for opt.showmatch (in units of 100 ms)

-- Misc
opt.belloff = "all"                   -- Silence bell for all events
opt.clipboard = "unnamed"             -- Use system clipboard
opt.hidden = true                     -- Allow hidden buffers
opt.mouse = "a"                       -- Enable mouse support in all modes
opt.shortmess = opt.shortmess + "a"   -- Abbreviate error messages
opt.shortmess = opt.shortmess + "A"   -- Ignore warning when swap file exists
