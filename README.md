# NEOZY: High-Performance Dual-Environment Neovim


```text
      __                        __      __                        
     /\ \                      /\ \__  /\ \                       
 ____\ \ \___      __      ___ \ \ ,_\ \ \ \___      __   ____  __  __ 
/\ '__`\ \  _ `\  /'__`\  /' _ `\ \ \/  \ \  _ `\  /'__`\/\_ ,`\/\ \/\ \
\ \ \L\ \ \ \ \ \/\ \L\.\_/\ \/\ \ \ \_  \ \ \ \ \/\  __/\/_/  /_\ \ \_\ \
 \ \ ,__/\ \_\ \_\ \__/.\_\ \_\ \_\ \__\  \ \_\ \_\ \____\/\____\\/`____ \
  \ \ \/  \/_/\/_/\/__/\/_/\/_/\/_/\/__/   \/_/\/_/\/____/\/____/ `/___/> \
   \ \_\                                                              /\___/
    \/_/                                                              \/__/

```
NEOZY is a specialized Neovim configuration engineered for a high-stakes workflow that bridges Systems Engineering (Linux) and Web Architecture (Windows). It is designed to be modular, project-intelligent, and performance-first.

---

## The Dual-Environment Philosophy

Neozy utilizes a split-profile architecture to maintain maximum speed across different operating systems:

### Linux Profile (Systems Mode)
Optimized for Kali/Linux environments. This profile initializes a heavy-duty backend suite:
* **LSP Integration:** Full support for Rust (rust-analyzer), Java (jdtls), and C (clangd).
* **Build Intelligence:** Integrated with Cargo, Maven, and Gradle.
* **Smart Execution:** The F5 engine detects systems-level build tools and manages local binaries.

### Windows Profile (Web Mode)
Optimized for frontend and backend web development (JS/TS, React, PHP):
* **Performance:** Strips systems-level overhead for 100% UI responsiveness.
* **Frontend Diagnostics:** High-speed formatting and real-time linting via Prettier and Typescript-Tools.
* **Lean Architecture:** Focuses on high-speed buffer switching and frontend telemetry.

---

## Technical Deep Dive

### 1. Smart Run Engine (F5 Contextual Execution)
The configuration features a custom Lua-based execution engine that detects project context at runtime:
* **Manifest Discovery:** Uses `vim.fn.findfile` to identify `Cargo.toml`, `mvnw`, or `gradlew`.
* **Rust Binary Intelligence:** Specifically handles `src/bin/*.rs` structures. If a file is within the `bin` directory, it automatically executes `cargo run --bin [filename]`.
* **Isolated Terminals:** Leverages `ToggleTerm` to manage 4 persistent, floating instances with a forced black (`#000000`) background for maximum contrast.

### 2. LSP & Code Intelligence
* **Managed LSP:** Mason-controlled lifecycle for Intelephense (PHP), Typescript-Tools (React/TS), and more.
* **Asynchronous Formatting:** `Conform.nvim` handles `BufWritePre` hooks to ensure zero UI freezing during formatting.
* **Treesitter:** Configured for `auto_install` to provide immediate, high-accuracy syntax highlighting.

### 3. UI Optimization
* **Transparency Engine:** A custom Lua loop modifies UI highlights (`Normal`, `SignColumn`, `LineNr`) to set alpha-channels to `NONE`, enabling terminal blur effects.
* **Lualine:** Minimalist status bar using a dynamic `mode_color` table that shifts UI colors based on Vim mode.
* **Bufferline:** A seamless, tab-less interface using `separator_style = "none"`.

---

## Technical Keymaps

| Key | Mode | Action |
| :--- | :--- | :--- |
| **F5** | Normal | Smart Run (Rust Bin / Maven / Gradle / GCC) |
| **Leader 1-4** | Normal | ToggleTerm Persistent Instance 1-4 |
| **Ctrl + N** | Normal | Neotree Toggle (File Explorer) |
| **Tab / S-Tab** | Normal | Buffer Cycling (Next/Previous) |
| **Leader + f** | Normal | Conform.nvim Asynchronous Format |
| **Leader + ca** | LSP | Code Action |
| **Esc** | Terminal | Escape Terminal Mode to Normal |

---

## Installation

1. **Clone the repository:**
   `git clone https://github.com/phantekzy/neozy.git`

2. **Deploy Linux Profile:**
   `cp Linux/init.lua ~/.config/nvim/init.lua`

3. **Deploy Windows Profile:**
   `copy Windows/init.lua %LocalAppData%\nvim\init.lua`

*Note: A Nerd Font is required for status line and file explorer icon rendering.*

---
**Maintained by Phantekzy**
