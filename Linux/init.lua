-- ================================================================================================
-- title : Phantekzy Hybrid Speed Config (2026)
-- stack : JS / TS / React / PHP / Web / C / RUST / JAVA
-- blend : Full IDE features + Suckless performance/ergonomics
-- ================================================================================================

-- 1. LEADER KEYS
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 2. SUCKLESS & CORE OPTIONS (Optimized for Speed)
local opt = vim.opt

-- Performance & Engine Fixes
opt.updatetime = 250
opt.timeoutlen = 300
opt.ttimeoutlen = 0
-- FIX 1: opt.lazyredraw was REMOVED in Neovim 0.10. Setting it to any value
-- raises E474 "invalid argument" on startup. The line has been deleted entirely.

-- FIX 2: vim.lsp.set_log_level() was deprecated in Neovim 0.10.
-- vim.lsp.log.set_level() is the correct API, AND the level string must be
-- UPPERCASE — lowercase "off" is silently ignored by the log module.
vim.lsp.log.set_level("OFF")

-- Visuals & Behavior
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.wrap = false
opt.showmode = false
opt.signcolumn = "yes"
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.cursorlineopt = "line"
opt.list = true
opt.listchars = { space = "·", tab = "→ " }
opt.scrolloff = 10    -- Keep 10 lines above/below cursor (Suckless)
opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor
opt.splitbelow = true
opt.splitright = true
opt.ignorecase = true -- Better search
opt.smartcase = true

-- Indentation
opt.expandtab = true
opt.tabstop = 4 -- Kept your 4-space preference
opt.shiftwidth = 4
opt.smartindent = true
opt.autoindent = true

-- Persistent Undo (Suckless)
local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
opt.undofile = true
opt.undodir = undodir

-- 3. BOOTSTRAP LAZY.NVIM
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
opt.rtp:prepend(lazypath)

-- 4. PLUGINS (Your Exact Loadout)
require("lazy").setup({
    -- Core dependencies
    { "nvim-lua/plenary.nvim",       lazy = true },
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- UI Enhancements
    { "stevearc/dressing.nvim",      event = "VeryLazy", opts = {} },
    { "rcarriga/nvim-notify",        event = "VeryLazy", opts = { background_colour = "#000000", timeout = 3000 } },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    -- FIX 3: "vim.lsp.util.set_autocmds" is NOT a valid noice
                    -- override key — it never existed, so noice silently skipped
                    -- it, leaving LSP hover and signature docs without markdown
                    -- rendering. The correct key is "stylize_markdown".
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = false,
                lsp_doc_border = false,
            },
        },
        dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    },

    -- DASHBOARD
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            local function get_greeting()
                local hour = tonumber(os.date("%H"))
                if hour < 12 then
                    return " 󰖙  Good Morning, Phantekzy "
                elseif hour < 18 then
                    return " 󰖙  Good Afternoon, Phantekzy "
                else
                    return " 󰖔  Good Evening, Phantekzy "
                end
            end

            local function get_recent_files()
                local files = {}
                for _, file in ipairs(vim.v.oldfiles) do
                    if #files < 5 then
                        local name = vim.fn.fnamemodify(file, ":t")
                        table.insert(files, {
                            type = "button",
                            val = "󰈚  " .. name,
                            on_press = function()
                                vim.cmd("e " .. file)
                            end,
                            opts = { hl = "Comment", width = 38, position = "center" },
                        })
                    end
                end
                return { type = "group", val = files }
            end

            dashboard.section.header.val = {
                [[        __                          __             __                          ]],
                [[       /\ \                        /\ \__         /\ \                         ]],
                [[ _____ \ \ \___       __       ___ \ \ ,_\     __ \ \ \/'\    ____     __  __  ]],
                [[/\ '__`\\ \  _ `\   /'__`\   /' _ `\\ \ \/   /'__`\\ \ , <  /\_ ,`\ /\ \/\ \ ]],
                [[\ \ \L\ \\ \ \ \ \ /\ \L\.\_ /\ \/\ \\ \ \_ /\  __/ \ \ \\`\\/_/  /_\ \ \_\ \]],
                [[ \ \ ,__/ \ \_\ \_\\ \__/.\_\\ \_\ \_\\ \__\\ \____\ \ \_\ \_\/\____\\/`____ \]],
                [[  \ \ \/   \/_/\/_/ \/__/\/_/ \/_/\/_/ \/__/ \/____/  \/_/\/_/\/____/ `/___/> \]],
                [[   \ \_\                                                                 /\___/]],
                [[    \/_/                                                                 \/__/ ]],
            }
            dashboard.section.header.opts.hl = "Function"

            local function button(key, txt, conf)
                local b = dashboard.button(key, txt, conf)
                b.opts.hl = "String"
                b.opts.hl_shortcut = "Keyword"
                b.opts.width = 38
                return b
            end

            dashboard.section.buttons.val = {
                button("f", "󰍉  FIND PROJECT FILES", ":Telescope find_files <CR>"),
                button("r", "󰋚  BROWSE ALL RECENT ", ":Telescope oldfiles <CR>"),
                button("g", "󰱽  GLOBAL TEXT SEARCH", ":Telescope live_grep <CR>"),
                button("c", "󰒓  CORE SYSTEM CONFIG", ":e $MYVIMRC <CR>"),
                button("q", "󰩈  EXIT NEOTERMINAL  ", ":qa<CR>"),
            }

            local function get_footer()
                local stats = require("lazy").stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                return {
                    " ",
                    "󰸗  " .. os.date("%A, %B %d") .. "  |  " .. get_greeting(),
                    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
                    "    NVIM v"
                    .. vim.version().major
                    .. "."
                    .. vim.version().minor
                    .. "  |  󰚀  PLUGINS: "
                    .. stats.loaded
                    .. "/"
                    .. stats.count
                    .. "  |  ⚡ "
                    .. ms
                    .. "ms",
                    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
                }
            end

            dashboard.section.footer.val = get_footer()
            dashboard.section.footer.opts.hl = "Comment"

            dashboard.opts.layout = {
                { type = "padding", val = 6 },
                dashboard.section.header,
                { type = "padding", val = 2 },
                dashboard.section.buttons,
                { type = "padding", val = 1 },
                {
                    type = "text",
                    val = "── RECENT SESSIONS ──",
                    opts = { hl = "Special", position = "center" },
                },
                { type = "padding", val = 1 },
                get_recent_files(),
                { type = "padding", val = 2 },
                dashboard.section.footer,
            }

            alpha.setup(dashboard.opts)

            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyVimStarted",
                callback = function()
                    dashboard.section.footer.val = get_footer()
                    pcall(vim.cmd, "AlphaRedraw")
                end,
            })
        end,
    },

    -- TOGGLETERM
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        cmd = { "ToggleTerm", "TermExec" },
        keys = {
            { "<leader>1", ":1ToggleTerm<CR>",    silent = true,           desc = "Terminal 1" },
            { "<leader>2", ":2ToggleTerm<CR>",    silent = true,           desc = "Terminal 2" },
            { "<leader>3", ":3ToggleTerm<CR>",    silent = true,           desc = "Terminal 3" },
            { "<leader>4", ":4ToggleTerm<CR>",    silent = true,           desc = "Terminal 4" },
            { [[<C-\>]],   "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
        },
        config = function()
            require("toggleterm").setup({
                size = 20,
                open_mapping = [[<C-\>]],
                direction = "float",
                shade_terminals = false,
                on_open = function(term)
                    vim.api.nvim_buf_set_name(term.bufnr, "Phantekzy Terminal " .. term.id)
                end,
                start_in_insert = true,
                insert_mappings = true,
                terminal_mappings = true,
                persist_size = true,
                close_on_exit = false,
                float_opts = { border = "curved", winblend = 0 },
            })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#000000" })
            vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#000000", fg = "#ffffff" })
        end,
    },

    -- BUFFERLINE & LUALINE
    {
        "akinsho/bufferline.nvim",
        event = "BufWinEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("bufferline").setup({
                options = { separator_style = "none", show_buffer_close_icons = false, show_close_icon = false },
                highlights = {
                    fill = { bg = "NONE" },
                    background = { bg = "NONE", fg = "#888888" },
                    buffer_visible = { bg = "NONE", fg = "#aaaaaa" },
                    buffer_selected = { bg = "NONE", fg = "#ffffff", bold = true },
                },
            })
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            local mode_color = {
                n = { fg = "#00afff", bg = "NONE" },
                i = { fg = "#00ff00", bg = "NONE" },
                v = { fg = "#bb00ff", bg = "NONE" },
                c = { fg = "#ffaa00", bg = "NONE" },
                R = { fg = "#ff0000", bg = "NONE" },
            }
            require("lualine").setup({
                options = { globalstatus = true, section_separators = "", component_separators = "" },
                sections = {
                    lualine_a = {
                        {
                            "mode",
                            fmt = function(m)
                                return " " .. m
                            end,
                            color = function()
                                return mode_color[vim.fn.mode()] or { fg = "#ffffff" }
                            end,
                        },
                    },
                    lualine_b = { { "branch", icon = "" } },
                    lualine_c = { "filename" },
                    lualine_x = { "filetype", "encoding" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },

    -- NEO-TREE
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        keys = { { "<C-n>", ":Neotree toggle<CR>", silent = true, desc = "Toggle NeoTree" } },
        dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
        config = function()
            require("neo-tree").setup({
                enable_diagnostics = false,
                filesystem = {
                    use_libuv_file_watcher = false,
                    filtered_items = { visible = true, hide_dotfiles = false },
                },
                window = { width = 31 },
            })
        end,
    },

    -- EDITING HELPERS & TELESCOPE
    { "numToStr/Comment.nvim",  event = "BufReadPre",  config = true },
    { "windwp/nvim-autopairs",  event = "InsertEnter", config = true },
    { "windwp/nvim-ts-autotag", event = "InsertEnter", opts = {} },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            indent = { char = "│", highlight = "Comment" },
            scope = { enabled = true, show_start = true, show_end = true },
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        keys = {
            { "<leader>ff", ":Telescope find_files<CR>", silent = true },
            { "<leader>fg", ":Telescope live_grep<CR>",  silent = true },
            { "<leader>fb", ":Telescope buffers<CR>",    silent = true },
            { "<leader>fh", ":Telescope help_tags<CR>",  silent = true },
        },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = {
                    layout_strategy = "horizontal",
                    sorting_strategy = "ascending",
                    path_display = { "truncate" },
                    file_ignore_patterns = { "node_modules", ".git/", "vendor/" },
                },
                pickers = { find_files = { hidden = true } },
            })
        end,
    },

    -- TREESITTER, MASON, LSP, CMP & FORMATTING
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua",
                    "javascript",
                    "typescript",
                    "tsx",
                    "html",
                    "css",
                    "json",
                    "php",
                    "rust",
                    "java",
                    "c",
                },
                -- Neovim 0.11 has a node:range() nil bug in its injection query
                -- engine. HTML triggers it on every re-render when <script> or
                -- <style> tags are present. The error is content-triggered so a
                -- pcall-on-attach can never catch it. Static disable list is the
                -- only reliable opt-out. The companion FileType autocmd in
                -- section 7 covers the case where Neovim's own filetype machinery
                -- calls vim.treesitter.start() independently of nvim-treesitter.
                highlight = {
                    enable = true,
                    disable = { "html" },
                },
                indent = { enable = true },
                auto_install = true,
            })
        end,
    },

    -- FIX 4: mason-lspconfig v2 REMOVED the `handlers` field from setup().
    -- The entire LSP block has been refactored:
    --   • vim.lsp.config("*", {...}) sets global capabilities + on_attach for ALL
    --     servers — this is the Neovim 0.11 replacement for the old default handler.
    --   • automatic_enable replaces per-server handler suppression:
    --       exclude ts_ls/tsserver  → typescript-tools handles TypeScript
    --       exclude jdtls           → needs dedicated nvim-jdtls per-project setup;
    --                                  the generic lspconfig handler silently breaks
    --                                  Java, so we keep it out of auto-enable.
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "pmizio/typescript-tools.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "intelephense",
                    "prettierd",
                    "jdtls",
                    "clangd",
                    "tailwindcss-language-server",
                    "eslint-lsp",
                },
                auto_update = true,
            })

            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local on_attach = function(_, bufnr)
                local map = function(mode, lhs, rhs)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
                end
                map("n", "gd", function()
                    local ft = vim.bo.filetype
                    if ft:match("typescript") or ft:match("javascript") then
                        vim.cmd("TSToolsGoToSourceDefinition")
                    else
                        vim.lsp.buf.definition()
                    end
                    vim.cmd("normal! zz")
                end)
                map("n", "K", vim.lsp.buf.hover)
                map("n", "<leader>ca", vim.lsp.buf.code_action)
                map("n", "<leader>rn", vim.lsp.buf.rename)
            end

            -- Neovim 0.11 global LSP config — replaces the old default handler.
            -- All auto-enabled servers inherit these capabilities and on_attach.
            vim.lsp.config("*", {
                capabilities = capabilities,
                on_attach = on_attach,
            })

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "html",
                    "cssls",
                    "jsonls",
                    "lua_ls",
                    "rust_analyzer",
                    "clangd",
                    "tailwindcss",
                    "eslint",
                    "intelephense",
                    "pyright",
                    -- jdtls intentionally NOT here — installed via mason-tool-installer
                    -- above but must not be auto-started (see FIX 4 comment).
                },
                -- mason-lspconfig v2: automatic_enable replaces handlers.
                -- exclude list prevents auto-starting those specific servers.
                automatic_enable = {
                    exclude = { "ts_ls", "tsserver", "jdtls" },
                },
            })

            -- TypeScript / JavaScript: typescript-tools replaces ts_ls / tsserver
            require("typescript-tools").setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = { publish_diagnostic_on = "insert_leave", tsserver_max_memory = 2048 },
            })
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            require("luasnip.loaders.from_vscode").lazy_load()
            cmp.setup({
                performance = { debounce = 60, fetching_timeout = 200 },
                snippet = {
                    expand = function(a)
                        luasnip.lsp_expand(a.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                }),
                sources = { { name = "nvim_lsp" }, { name = "luasnip" }, { name = "buffer" }, { name = "path" } },
                window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
            })
        end,
    },

    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    javascript = { "prettierd" },
                    typescript = { "prettierd" },
                    html = { "prettierd" },
                    css = { "prettierd" },
                    json = { "prettierd" },
                    rust = { "rustfmt" },
                    java = { "google-java-format" },
                    c = { "clang-format" },
                },
                -- FIX 5: `lsp_fallback = true` was removed in conform.nvim v7+.
                -- The replacement key is `lsp_format = "fallback"` — identical
                -- semantics: run conform formatters first; fall back to LSP if
                -- no formatter is configured for the current filetype.
                format_on_save = { lsp_format = "fallback", timeout_ms = 500 },
            })
        end,
    },

    {
        "smoka7/multicursors.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvimtools/hydra.nvim" },
        opts = {},
        keys = {
            {
                -- FIX 6: was <C-d> in mode {"n","v"}, which collides with the
                -- centered half-page-down map set in section 7 below. Because
                -- section 7 runs after plugin spec keys are registered, its map
                -- always overwrites this one — multicursors was silently dead in
                -- normal mode. Changed to <leader>mc (mnemonic: MultiCursor).
                "<leader>mc",
                function()
                    require("multicursors").start()
                end,
                mode = { "n", "v" },
                desc = "Start Multicursor",
            },
        },
    },

    -- THEME
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                style = "night",
                transparent = true,
                styles = { sidebars = "transparent", floats = "transparent" },
            })
            vim.cmd([[colorscheme tokyonight]])
        end,
    },
})

-- 5. TRANSPARENCY
local function transparent()
    local groups = {
        "Normal",
        "NormalNC",
        "SignColumn",
        "StatusLine",
        "StatusLineNC",
        "VertSplit",
        "LineNr",
        "CursorLineNr",
        "BufferLineFill",
        "BufferLineBackground",
    }
    for _, g in ipairs(groups) do
        pcall(vim.api.nvim_set_hl, 0, g, { fg = "#bfbfbf", bg = "NONE" })
    end
    vim.api.nvim_set_hl(0, "Visual", { bg = "#333333", fg = "#ffffff" })
    vim.api.nvim_set_hl(0, "TermCursor", { fg = "#000000", bg = "#ffffff" })
end
transparent()

-- 6. SMART RUN LOGIC (F5)
local function smart_run()
    local bufnr = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(bufnr)
    if vim.bo.buftype ~= "" or filename == "" then
        vim.notify("Please phantekzy, open a file!", vim.log.levels.WARN, { title = "System" })
        return
    end
    if vim.bo.modified then
        vim.cmd("w")
    end

    local ft = vim.bo.filetype
    local cmd = ""
    if ft == "c" then
        cmd = [[clear && echo "--- PHANTEKZY COMPILING C ---" && echo "" && gcc %:p -o %:t:r -lm && ./%:t:r]]
    elseif ft == "php" then
        cmd = [[clear && echo "--- PHANTEKZY RUNNING PHP ---" && echo "" && php %:p]]
    elseif ft == "rust" then
        cmd = vim.fn.findfile("Cargo.toml", ".;") ~= ""
            and [[clear && echo "--- PHANTEKZY CARGO RUN ---" && echo "" && cargo run]]
            or [[clear && echo "--- PHANTEKZY RUSTC RUN ---" && echo "" && rustc %:p -o %:t:r && ./%:t:r]]
    elseif ft == "java" then
        if vim.fn.findfile("mvnw", ".;") ~= "" then
            cmd = [[clear && echo "--- PHANTEKZY MAVEN RUN ---" && echo "" && ./mvnw spring-boot:run]]
        elseif vim.fn.findfile("gradlew", ".;") ~= "" then
            cmd = [[clear && echo "--- PHANTEKZY GRADLE RUN ---" && echo "" && ./gradlew run]]
        else
            cmd = [[clear && echo "--- PHANTEKZY JAVA RUN ---" && echo "" && java %]]
        end
    end

    if cmd ~= "" then
        vim.cmd("TermExec cmd='" .. cmd .. "' direction=float")
    else
        vim.cmd("ToggleTerm direction=float")
    end
end
vim.keymap.set("n", "<F5>", smart_run, { silent = true })
vim.keymap.set("t", "<esc>", [[<C-\><C-n>]])

-- Diagnostics
vim.diagnostic.config({
    virtual_text = { prefix = "●", spacing = 2 },
    signs = true,
    underline = true,
    update_in_insert = false,
})
-- FIX 7: vim.diagnostic.goto_prev / goto_next were deprecated in Neovim 0.11.
-- Replaced with vim.diagnostic.jump({ count = N }): positive = forward,
-- negative = backward. Behavior is identical to the old functions.
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float)

-- ================================================================================================
-- 7. MERGED SUCKLESS KEYMAPS & AUTOCMDS (The Secret Sauce)
-- ================================================================================================

local map = vim.keymap.set

-- Buffer Navigation
map("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true })
map("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true })

-- Clear Highlights
map("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Better Yanking & Pasting
map("n", "Y", "y$", { desc = "Yank to end of line" })
map("x", "<leader>p", '"_dP', { desc = "Paste without yanking (replaces text cleanly)" })
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking to clipboard" })

-- Centered Navigation (Game Changer)
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Window Navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Move Lines Up/Down (Alt+j / Alt+k)
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better Indenting in Visual Mode
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Copy Full File Path
map("n", "<leader>pa", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    print("Copied file path: ", path)
end, { desc = "Copy File Path" })

-- Autocommand: Highlight yanked text (Suckless Visual Cue)
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("UserConfig", {}),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Belt-and-suspenders for the Neovim 0.11 HTML range() nil bug.
-- The disable list in the treesitter config stops nvim-treesitter from
-- enabling the highlighter, but Neovim 0.11's own filetype machinery can
-- independently call vim.treesitter.start() for HTML. vim.schedule() defers
-- the stop until after ALL FileType handlers have fired, so we always win
-- regardless of plugin registration order.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "html",
    callback = function(args)
        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(args.buf) then
                vim.treesitter.stop(args.buf)
            end
        end)
    end,
})
