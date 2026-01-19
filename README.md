# Neozy : High-Performance Dual-Environment Config

Neozy is my personal Neovim configuration, built to handle a high-stakes development workflow that switches between **Systems Engineering (Linux)** and **Web Architecture (Windows)**. I designed this setup to be modular, fast, and project-intelligent, and I am sharing it for developers who need a setup that adapts to their OS environment.

## The Dual-OS Philosophy

Unlike "all-in-one" configs that bloat your editor, PhantekNvim is strategically split:

* **Linux (Kali Profile):** This is the "Full Power" mode. It is configured to initialize heavy-duty Language Servers (LSP) for **Rust, Java, and C**. The F5 Smart Run logic is integrated with systems-level build tools like Cargo and Maven.
* **Windows (Web Profile):** This is the "Lean" mode. I use Windows exclusively for Web Development (JS/TS, React, PHP). To keep performance at 100%, this profile strips out the systems-level overhead, focusing on high-speed formatting and frontend diagnostics.

## Deep Dive: Plugin Architecture

### 1. The Execution Engine (ToggleTerm + Custom F5)
At the heart of this config is a custom `smart_run()` Lua function. It doesn't just "run" a file; it understands the project context:
* **Manifest Detection:** It uses `vim.fn.findfile` to look for `Cargo.toml`, `mvnw`, or `gradlew`.
* **Persistent Terminals:** It utilizes `ToggleTerm` to manage 4 independent terminal instances. These are "floating" terminals with a forced black background (`#000000`) for maximum contrast against the transparent editor.

### 2. Language Server Protocol (LSP) & Mason
I use a "Managed LSP" approach to ensure environment stability:
* **Intelephense:** Tailored for professional PHP development with telemetry disabled.
* **Typescript-Tools:** Replaces the standard `tsserver` for faster React and TS performance.
* **Mason-Tool-Installer:** This ensures that every time I open Neovim, my formatters (`prettierd`, `rustfmt`, `google-java-format`) and LSPs are automatically updated to the latest versions.

### 3. Visual & UI Optimization
* **Transparency Engine:** A custom Lua loop iterates through UI highlights (`Normal`, `SignColumn`, `LineNr`, etc.) and sets the alpha-channel to `NONE`. This allows the terminal's blur and background to show through the **TokyoNight** theme.
* **Lualine:** The status line is stripped of unnecessary icons. It uses a dynamic `mode_color` table to change the UI color based on whether you are in Insert, Visual, or Normal mode.
* **Bufferline:** Configured with `separator_style = "none"` to create a seamless, tab-less look that emphasizes the active file.

### 4. Code Intelligence
* **Treesitter:** Configured with `auto_install = true` to ensure that any new language I open is immediately parsed for high-accuracy syntax highlighting.
* **Conform.nvim:** Handles asynchronous formatting. It is hooked into `BufWritePre` so that files are formatted on save without freezing the UI.
* **Multi-Cursors:** Integrated via `multicursors.nvim` (mapped to `Ctrl-D`), allowing for parallel editing across large blocks of code.

## Keymaps Overview (Technical)

| Key | Context | Internal Command |
| :--- | :--- | :--- |
| **F5** | Normal | `smart_run()` (Contextual Build/Exec) |
| **<Leader>1-4** | Normal | `ToggleTerm` (Persistent Instance 1-4) |
| **<Leader>ca** | LSP | `vim.lsp.buf.code_action` |
| **<Tab>** | Buffer | `BufferLineCycleNext` |
| **<C-n>** | Explorer | `Neotree toggle` |
| **<Leader>f** | Format | `conform.format()` |

## Installation & Setup

This repository contains two primary versions. Choose the one that matches your current OS:

1.  **Clone:** `git clone https://github.com/phantekzy/neozy.git`
2.  **Linux Deploy:** Copy `Linux/init.lua` to `~/.config/nvim/init.lua`
3.  **Windows Deploy:** Copy `Windows/init.lua` to `~/AppData/Local/nvim/init.lua`

**Note:** Ensure you have a **Nerd Font** installed to render the icons correctly in the status line and file explorer.
EOF
