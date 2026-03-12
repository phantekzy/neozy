# NEOZY: Advanced Engineering Development Environment

NEOZY is a professional Neovim configuration engineered for the rigorous demands of Systems Programming and Web Architecture. It bridges the gap between heavy IDE functionality and low latency minimalist performance.

## Architectural Philosophy

The core architecture is built upon three fundamental pillars:

* Low Latency Execution: Configuration parameters are strictly tuned to ensure rapid startup times and zero lag input processing.
* Contextual Intelligence: A custom built execution engine identifies project structures (Cargo, Maven, Gradle) at runtime to provide isolated and appropriate build commands.
* Ergonomic Precision: Motion and navigation logic are designed to maintain home row efficiency and minimize visual strain through centered cursor positioning.

## Technical Specifications & Performance Tuning

### 1. Engine Core
* Performance Tweak: The updatetime is calibrated to 250ms for rapid LSP diagnostics and Git integration without compromising CPU cycles.
* Redraw Strategy: lazyredraw is utilized to optimize screen updates during complex macro execution.
* Persistent State: Implements a global undo history across sessions stored in a dedicated directory to ensure long term revision persistence.
* Visual Anchors: The scrolloff value of 10 ensures the cursor remains vertically centered, providing 10 lines of context above and below the active line at all times.

### 2. Intelligent Dashboard (Alpha NVIM)
The startup environment provides automated telemetry and session management:
* Session Resumption: Dynamically tracks and displays the five most recent files for instant access.
* Telemetry Data: Real time calculation and display of loaded plugins and exact startup latency in milliseconds.
* Automated Logic: Time sensitive system logic based on the local host clock.

### 3. Smart Run Engine (F5 Contextual Logic)
The smart_run function is a specialized Lua implementation that provides language aware execution:
* C: Automated compilation with gcc, linking the math library, and executing the output.
* Rust: Intelligent detection of Cargo.toml. Executes cargo run if present; otherwise utilizes rustc for standalone files.
* Java: Multi tier build tool detection for Maven and Gradle, with a fallback to standard JVM execution.
* PHP: Direct script execution via the CLI runtime.
* Process Isolation: All execution commands are dispatched to persistent floating terminal instances via ToggleTerm to preserve buffer cleanliness.

## Development Toolchain

### LSP & Tool Management
The configuration utilizes a unified stack for automated binary management and language intelligence:
* Systems Engineering: Full integration for clangd, rust_analyzer, and jdtls.
* Web Architecture: Optimized support for typescript tools, intelephense, tailwindcss, and eslint.
* Asynchronous Formatting: Conform.nvim manages BufWritePre hooks for prettierd, rustfmt, and google java format, ensuring non blocking saves.

### Syntax & UI Design
* Transparency Engine: A custom Lua loop modifies UI highlights to enable terminal compositor transparency for Normal, SignColumn, and LineNr.
* Lualine & Bufferline: Minimalist telemetry tracking using a dynamic mode_color table to shift UI indicators based on Vim mode. Bufferline is configured with separator_style set to none for a seamless interface.

## Technical Keymap Manifest

### Navigation & Motion
* Tab / Shift Tab: Buffer Cycle for instant navigation between open project files.
* n / N: Search Next/Prev includes zzzv to lock search results to screen center.
* Ctrl + d / Ctrl + u: Half page Jump with automatic centering to maintain visual focus.
* Ctrl + h/j/k/l: Window Nav for seamless directional jumps between split panes.

### Advanced Editing
* Leader + p: Visual Smart Paste replaces text using the black hole register to retain clipboard data.
* Leader + d: Normal/Visual Silent Delete deletes without overwriting the current yank register.
* Alt + j / Alt + k: Normal/Visual Line Bubbling moves lines or blocks with automated indentation logic.
* Ctrl + d: Normal/Visual Multicursor triggers multicursors.nvim for parallel editing.

### System Commands
* F5: Execute Smart Run Engine.
* Ctrl + n: Toggle Neo tree File Explorer.
* Leader + 1 through 4: Access Persistent Floating Terminals.
* Leader + ca: Trigger LSP Code Actions.
* Leader + ff: Telescope Fuzzy File Finder.

## Installation & Deployment

### Linux Environment
git clone https://github.com/phantekzy/neozy.git ~/.config/nvim

### Windows Environment
git clone https://github.com/phantekzy/neozy.git $HOME\AppData\Local\nvim

* A Nerd Font is strictly required for the rendering of status line components and file system iconography.

Maintained by Maini Lotfi (Phantekzy)
