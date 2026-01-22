-- Phantekzy Neovim Config for Windows (2026)
-- JavaScript / TypeScript / React / PHP / Web Stack / JAVA

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Windows Shell Configuration
if vim.fn.has("win32") == 1 then
	vim.opt.shell = "powershell.exe"
	vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
	vim.opt.shellquote = ""
	vim.opt.shellxquote = ""
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
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

	-- Status line (ADVANCED PROGRAMMER VERSION - ONLY SECTION MODIFIED)
	{
		"nvim-lualine/lualine.nvim",
		event = "VimEnter",
		config = function()
			local mode_color = {
				n = { fg = "#00afff" },
				i = { fg = "#00ff00" },
				v = { fg = "#bb00ff" },
				c = { fg = "#ffaa00" },
				R = { fg = "#ff0000" },
			}
			require("lualine").setup({
				options = {
					globalstatus = true,
					theme = "tokyonight",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = { statusline = { "neo-tree", "toggleterm" } },
				},
				sections = {
					lualine_a = {
						{
							"mode",
							fmt = function(m)
								return " " .. m
							end,
							color = function()
								return {
									fg = (mode_color[vim.fn.mode()] or { fg = "#ffffff" }).fg,
									bg = "NONE",
									gui = "bold",
								}
							end,
						},
					},
					lualine_b = {
						{ "branch", icon = "" },
						{ "diff", symbols = { added = " ", modified = " ", removed = " " } },
					},
					lualine_c = {
						{
							function()
								return "󰉖 " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
							end,
							color = { fg = "#565f89", gui = "italic" },
						},
						{
							"filename",
							file_status = true,
							path = 1, -- Shows folder/file.js (Essential for Web Dev)
							symbols = { modified = " ●", readonly = " " },
						},
					},
					lualine_x = {
						{ "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = "󰛨 " } },
						{
							function()
								local clients = vim.lsp.get_active_clients({ bufnr = 0 })
								if #clients == 0 then
									return "󰚦 No LSP"
								end
								local names = {}
								for _, client in ipairs(clients) do
									if client.name ~= "tsserver" then
										table.insert(names, client.name)
									end
								end
								return "󰄭 " .. table.concat(names, "|")
							end,
							color = { fg = "#00afff", gui = "bold" },
						},
					},
					lualine_y = { "filetype", "progress" },
					lualine_z = {
						{ "location", icon = "" },
						{
							function()
								return " " .. os.date("%R")
							end,
						},
					},
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
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
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
				ensure_installed = { "lua", "javascript", "typescript", "tsx", "html", "css", "json", "php", "java" },
				highlight = { enable = true },
				indent = { enable = true },
				auto_install = true,
			})
		end,
	},

	-- Mason + LSP (Fixed for Neovim 0.11 & No Conflicts)
	{ "williamboman/mason.nvim", config = true },
	{ "williamboman/mason-lspconfig.nvim" },
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = { "intelephense", "prettierd", "ts_ls", "jdtls", "google-java-format" },
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

				-- SMOOTH JUMP
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

			require("mason-lspconfig").setup({
				ensure_installed = { "intelephense", "lua_ls", "ts_ls", "html", "cssls", "jsonls", "jdtls" },
			})

			-- Neovim 0.11 style enable (Excluding ts_ls to avoid the duplicate bug)
			local servers = { "html", "cssls", "jsonls", "lua_ls", "jdtls", "eslint", "tailwindcss", "intelephense" }
			for _, s in ipairs(servers) do
				vim.lsp.config(s, { capabilities = capabilities, on_attach = on_attach })
				vim.lsp.enable(s)
			end

			require("typescript-tools").setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					tsserver_file_preferences = {
						includeCompletionsForImportStatements = true,
						importModuleSpecifierPreference = "non-relative",
						includeCompletionsForModuleExports = true,
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
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = true }),

					-- Manually trigger completion
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-l>"] = cmp.mapping.complete(), -- Reliable backup for Windows/Alacritty

					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),

					-- Scroll documentation
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
				}),
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
					java = { "google-java-format" },
				},
				format_on_save = { lsp_fallback = true, timeout_ms = 500 },
			})
			vim.keymap.set("n", "<leader>f", function()
				require("conform").format({ async = true })
			end, { desc = "Format file" })
		end,
	},

	-- Multi-cursor
	{
		"smoka7/multicursors.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvimtools/hydra.nvim" },
		keys = {
			{
				"<C-d>",
				function()
					require("multicursors").start()
				end,
				mode = { "n", "v" },
				desc = "Start multi-cursor editing",
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

-- Transparency Override
local function transparent()
	for _, g in ipairs({
		"Normal",
		"NormalNC",
		"NormalFloat",
		"SignColumn",
		"StatusLine",
		"StatusLineNC",
		"VertSplit",
		"LineNr",
		"CursorLineNr",
		"BufferLineFill",
		"BufferLineBackground",
	}) do
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

-- MULTIPLE TERMINALS MAPPINGS
map("n", "<leader>1", ":1ToggleTerm<CR>", { silent = true, desc = "Terminal 1" })
map("n", "<leader>2", ":2ToggleTerm<CR>", { silent = true, desc = "Terminal 2" })
map("n", "<leader>3", ":3ToggleTerm<CR>", { silent = true, desc = "Terminal 3" })
map("n", "<leader>4", ":4ToggleTerm<CR>", { silent = true, desc = "Terminal 4" })

-- Toggle word wrap
map("n", "<M-w>", function()
	vim.opt.wrap = not vim.opt.wrap:get()
	vim.opt.linebreak = vim.opt.wrap:get()
end, { desc = "Toggle word wrap" })

-- SMART RUN (F5)
local function smart_run()
	local bufnr = vim.api.nvim_get_current_buf()
	local filename = vim.api.nvim_buf_get_name(bufnr)
	local buftype = vim.bo.buftype

	-- Stop E382 by only running on actual files
	if buftype ~= "" then
		return
	end

	if filename == "" then
		vim.notify("Please phantekzy, open a file!", vim.log.levels.WARN, { title = "System" })
		return
	end

	vim.cmd("w")
	local ft = vim.bo.filetype
	local cmd = ""

	if ft == "php" then
		cmd = [[cls; echo "--- PHANTEKZY RUNNING PHP ---"; echo ""; php %:p]]
	elseif ft == "java" then
		if vim.fn.findfile("mvnw.cmd", ".;") ~= "" then
			cmd = [[cls; echo "--- PHANTEKZY MAVEN ---"; .\mvnw spring-boot:run]]
		elseif vim.fn.findfile("gradlew.bat", ".;") ~= "" then
			cmd = [[cls; echo "--- PHANTEKZY GRADLE ---"; .\gradlew run]]
		else
			cmd = [[cls; echo "--- PHANTEKZY JAVA ---"; java %]]
		end
	end

	if cmd ~= "" then
		vim.cmd("TermExec cmd='" .. cmd .. "' direction=float")
	else
		vim.cmd("ToggleTerm direction=float")
	end
end

vim.keymap.set("n", "<F5>", smart_run, { silent = true, desc = "Run PHP/Java or Open Terminal" })
vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Diagnostics
vim.diagnostic.config({
	virtual_text = { prefix = "●", spacing = 2 },
	signs = true,
	underline = true,
	update_in_insert = false,
})

vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#ff5f5f" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#ffaa00" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = "#5fd7ff" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#87d7ff" })

map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Show diagnostic" })
