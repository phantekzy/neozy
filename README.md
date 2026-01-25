cat << 'EOF' > README.md
# Neozy : High-Performance Dual-Environment Config

Neozy is my personal Neovim configuration, built to handle a high-stakes development workflow that switches between **Systems Engineering (Linux)** and **Web Architecture (Windows)**. I designed this setup to be modular, fast, and project-intelligent.

## The Dual-OS Philosophy

Unlike "all-in-one" configs that bloat your editor, Neozy is strategically split:

* **Linux (Kali Profile):** This is the "Full Power" mode. It is configured to initialize heavy-duty Language Servers (LSP) for **Rust, Java, and C**. The F5 Smart Run logic is integrated with systems-level build tools like Cargo, Maven, and custom Rust binary detection.
* **Windows (Web Profile):** This is the "Lean" mode. I use Windows exclusively for Web Development (JS/TS, React, PHP). To keep performance at 100%, this profile strips out the systems-level overhead, focusing on high-speed formatting and frontend diagnostics.

## Deep Dive: Plugin Architecture

### 1. The Execution Engine (ToggleTerm + Custom F5)
At the heart of this config is a custom `smart_run()` Lua function. It understands project context:
* **Manifest Detection:** It uses `vim.fn.findfile` to look for `Cargo.toml`, `mvnw`, or `gradlew`.
* **Rust Binary Intelligence:** Specifically designed to handle `src/bin/` structures. It automatically detects individual `.rs` binaries and executes `cargo run --bin` for the current file.
* **Persistent Terminals:** It utilizes `ToggleTerm` to manage 4 independent terminal instances. These are "floating" terminals with a forced black background (`#000000`) for maximum contrast against the transparent editor.

### 2. Language Server Protocol (LSP) & Mason
I use a "Managed LSP" approach to ensure environment stability:
* **Intelephense:** Tailored for professional PHP development with telemetry disabled.
* **Typescript-Tools:** Replaces the standard `tsserver` for faster React and TS performance.
* **Mason-Tool-Installer:** Ensures formatters (`prettierd`, `rustfmt`, `google-java-format`) and LSPs are automatically updated.

### 3. Visual & UI Optimization
* **Transparency Engine:** A custom Lua loop iterates through UI highlights (`Normal`, `SignColumn`, `LineNr`, etc.) and sets the alpha-channel to `NONE`, allowing terminal blur to show through the **TokyoNight** theme.
* **Lualine:** Stripped of unnecessary icons. Uses a dynamic `mode_color` table to change UI color based on Insert, Visual, or Normal mode.
* **Bufferline:** Seamless, tab-less look using `separator_style = "none"`.

### 4. Code Intelligence
* **Treesitter:** `auto_install = true` for immediate high-accuracy syntax highlighting on new languages.
* **Conform.nvim:** Asynchronous formatting on save via `BufWritePre` to prevent UI freezing.
* **Multi-Cursors:** Parallel editing via `multicursors.nvim` (mapped to `Ctrl-D`).

## Keymaps Overview (Technical)

| Key | Context | Action |
| :--- | :--- | :--- |
| **F5** | Normal | `smart_run()` (Contextual Build/Exec + **Rust Bin Support**) |
| **<Leader>1-4** | Normal | `ToggleTerm` (Persistent Instance 1-4) |
| **<C-n>** | Normal | `Neotree toggle` (File Explorer) |
| **<Tab>** | Normal | `BufferLineCycleNext` (Next Tab) |
| **<S-Tab>** | Normal | `BufferLineCyclePrev` (Previous Tab) |
| **<Leader>f** | Normal | `conform.format()` (Auto-format) |
| **<Leader>ca** | LSP | `vim.lsp.buf.code_action` |
| **<Leader>x** | Normal | `bdelete` (Close Buffer) |
| **<Esc>** | Terminal | Exit Terminal Mode (`<C-\><C-n>`) |

## Installation & Setup

1. **Clone:** `git clone https://github.com/phantekzy/neozy.git`
2. **Linux Deploy:** Copy `Linux/init.lua` to `~/.config/nvim/init.lua`
3. **Windows Deploy:** Copy `Windows/init.lua` to `~/AppData/Local/nvim/init.lua`

**Note:** Ensure you have a **Nerd Font** installed to render the icons correctly in the status line and file explorer.
EOF
