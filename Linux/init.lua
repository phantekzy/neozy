-- Phantekzy Neovim Config (2026)
-- JavaScript / TypeScript / React / PHP / Web Stack/C/RUST/JAVA

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Core options
local opt = vim.opt
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.wrap = false
opt.showmode = false
opt.signcolumn = "yes"
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.smartindent = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.cursorlineopt = "line"
opt.list = true
opt.listchars = { space = "·", tab = "→ " }

-- Plugins
require("lazy").setup({

	-- Core dependencies
	{ "nvim-lua/plenary.nvim", lazy = true },
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- TOGGLETERM
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				size = 20,
				open_mapping = [[<C-\>]],
				direction = "float",
				shade_terminals = false,
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

	-- Buffer line
	{
		"akinsho/bufferline.nvim",
		event = "BufWinEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("bufferline").setup({
				options = {
					separator_style = "none",
					show_buffer_close_icons = false,
					show_close_icon = false,
				},
				highlights = {
					fill = { bg = "NONE" },
					background = { bg = "NONE", fg = "#888888" },
					buffer_visible = { bg = "NONE", fg = "#aaaaaa" },
					buffer_selected = { bg = "NONE", fg = "#ffffff", bold = true },
				},
			})
		end,
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		event = "VimEnter",
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
								return " " .. m
							end,
							color = function()
								return mode_color[vim.fn.mode()] or { fg = "#ffffff" }
							end,
						},
					},
					lualine_b = { { "branch", icon = "" } },
					lualine_c = { "filename" },
					lualine_x = { "filetype", "encoding" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},

	-- File explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = "Neotree",
		dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
		config = function()
			require("neo-tree").setup({
				filesystem = { filtered_items = { visible = true, hide_dotfiles = false } },
				window = { width = 31 },
			})
		end,
	},

	-- Editing helpers
	{ "numToStr/Comment.nvim", event = "BufReadPre", config = true },
	{ "windwp/nvim-autopairs", event = "InsertEnter", config = true },

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			indent = { char = "│", highlight = "Comment" },
			scope = { enabled = true, show_start = true, show_end = true },
		},
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					layout_strategy = "horizontal",
					sorting_strategy = "ascending",
					path_display = { "truncate" },
					file_ignore_patterns = { "node_modules", ".git/" },
				},
				pickers = { find_files = { hidden = true } },
			})
		end,
	},

	-- Telescope UI-Select
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = { ["ui-select"] = { require("telescope.themes").get_dropdown({}) } },
			})
			require("telescope").load_extension("ui-select")
		end,
	},

	-- Treesitter
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
				},
				highlight = { enable = true },
				indent = { enable = true },
				auto_install = true,
			})
		end,
	},

	-- Mason + LSP
	{ "williamboman/mason.nvim", config = true },
	{ "williamboman/mason-lspconfig.nvim" },
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"intelephense",
					"prettierd",
					"jdtls",
					"clangd",
				},
				auto_update = true,
				run_on_start = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp", "pmizio/typescript-tools.nvim" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(_, bufnr)
				local map = function(mode, lhs, rhs)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
				end

				-- SMOOTH JUMP (Like Ctrl+Click)
				map("n", "gd", function()
					local ft = vim.bo.filetype
					if ft:match("typescript") or ft:match("javascript") then
						vim.cmd("TSToolsGoToSourceDefinition")
					else
						vim.lsp.buf.definition()
					end
					-- Only center the screen, don't touch Neotree
					vim.cmd("normal! zz")
				end)

				map("n", "K", vim.lsp.buf.hover)
				map("n", "<leader>ca", vim.lsp.buf.code_action)
				map("n", "<leader>rn", vim.lsp.buf.rename)
			end

			require("mason-lspconfig").setup({
				ensure_installed = {
					"intelephense",
					"lua_ls",
					"html",
					"cssls",
					"jsonls",
					"jdtls",
				},
			})

			-- PHP
			vim.lsp.config("intelephense", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = { intelephense = { telemetry = { enabled = false } } },
			})
			vim.lsp.enable("intelephense")

			-- OTHER LANGUAGES (C, Rust, Java, etc.)
			local servers = { "html", "cssls", "jsonls", "lua_ls", "rust_analyzer", "jdtls", "clangd" }
			for _, s in ipairs(servers) do
				vim.lsp.config(s, { capabilities = capabilities, on_attach = on_attach })
				vim.lsp.enable(s)
			end

			-- TYPESCRIPT / JAVASCRIPT
			require("typescript-tools").setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					tsserver_file_preferences = {
						includeCompletionsForImportStatements = true,
						importModuleSpecifierPreference = "non-relative",
					},
				},
			})
		end,
	},

	-- Completion
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
				snippet = {
					expand = function(a)
						luasnip.lsp_expand(a.body)
					end,
				},
				mapping = {
					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({ select = true })
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-Space>"] = cmp.mapping.complete(),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
				},
				sources = { { name = "nvim_lsp" }, { name = "luasnip" }, { name = "buffer" }, { name = "path" } },
				window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
				completion = { autocomplete = false, completeopt = "menu,menuone,noinsert" },
				experimental = { ghost_text = true },
			})
		end,
	},

	-- Formatter
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
				format_on_save = { lsp_fallback = true, timeout_ms = 500 },
			})
			vim.keymap.set("n", "<leader>f", function()
				require("conform").format({ async = true })
			end)
		end,
	},

	-- Multi-cursor
	{
		"smoka7/multicursors.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvimtools/hydra.nvim" },
		opts = {},
		keys = {
			{
				"<C-d>",
				function()
					require("multicursors").start()
				end,
				mode = { "n", "v" },
			},
		},
	},

	-- Theme
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

-- Transparency
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

-- Keymaps
local map = vim.keymap.set
map("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true })
map("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true })
map("n", "<C-n>", ":Neotree toggle<CR>", { silent = true })
map("n", "<leader>ff", ":Telescope find_files<CR>", { silent = true })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { silent = true })
map("n", "<leader>fb", ":Telescope buffers<CR>", { silent = true })
map("n", "<leader>fh", ":Telescope help_tags<CR>", { silent = true })

-- Terminals
map("n", "<leader>1", ":1ToggleTerm<CR>", { silent = true })
map("n", "<leader>2", ":2ToggleTerm<CR>", { silent = true })
map("n", "<leader>3", ":3ToggleTerm<CR>", { silent = true })
map("n", "<leader>4", ":4ToggleTerm<CR>", { silent = true })

-- SMART RUN (F5)
local function smart_run()
	local bufnr = vim.api.nvim_get_current_buf()
	local filename = vim.api.nvim_buf_get_name(bufnr)
	if vim.bo.buftype ~= "" then
		return
	end
	if filename == "" then
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
		local root = vim.fn.findfile("Cargo.toml", ".;")
		if root ~= "" then
			local filepath = vim.fn.expand("%:p")
			-- Detect if file is in src/bin and run the specific binary
			if filepath:match("src/bin/") then
				local bin_name = vim.fn.expand("%:t:r")
				cmd = string.format(
					[[clear && echo "--- PHANTEKZY CARGO BIN RUN (%s) ---" && echo "" && cargo run --bin %s]],
					bin_name,
					bin_name
				)
			else
				cmd = [[clear && echo "--- PHANTEKZY CARGO RUN ---" && echo "" && cargo run]]
			end
		else
			cmd = [[clear && echo "--- PHANTEKZY RUSTC RUN ---" && echo "" && rustc %:p -o %:t:r && ./%:t:r]]
		end
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
map("n", "<F5>", smart_run, { silent = true })
map("t", "<esc>", [[<C-\><C-n>]])

-- Diagnostics
vim.diagnostic.config({ virtual_text = { prefix = "●", spacing = 2 }, signs = true, underline = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#ff5f5f" })
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)
map("n", "<leader>ld", vim.diagnostic.open_float)
map("n", "<leader>lq", vim.diagnostic.setloclist)
