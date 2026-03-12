# NEOZY: Advanced Engineering Development Environment (2026)

NEOZY is a professional-grade Neovim configuration engineered for the rigorous demands of Systems Programming and Web Architecture. It bridges the gap between heavy-duty IDE functionality and low-latency, minimalist performance.

---

## I. Architectural Core & Performance

The core architecture is built upon three fundamental pillars designed for maximum developer throughput.

### System Performance Tuning
| Feature | Parameter | Technical Impact |
| :--- | :--- | :--- |
| **Startup Latency** | < 20ms | Optimized plugin loading via `lazy.nvim` and byte-compiled Lua. |
| **Input Response** | `updatetime = 250ms` | Reduced delay for LSP diagnostics and Git gutter updates. |
| **Visual Anchors** | `scrolloff = 10` | Cursor remains vertically centered for constant context. |
| **Revision History** | `undofile = true` | Global persistent undo history stored at `~/.vim/undodir`. |

---

## II. Smart Run Engine (F5 Contextual Logic)

The proprietary `smart_run` function provides language-aware execution by identifying project manifests at runtime.

| Language | Detection Logic | Execution Pipeline |
| :--- | :--- | :--- |
| **C** | `.c` Extension | `gcc %:p -o %:t:r -lm && ./%:t:r` |
| **Rust (Cargo)** | `Cargo.toml` | `cargo run` (Includes binary detection for `src/bin`) |
| **Rust (Solo)** | `.rs` Extension | `rustc %:p -o %:t:r && ./%:t:r` |
| **Java (Maven)** | `mvnw` | `./mvnw spring-boot:run` |
| **Java (Gradle)** | `gradlew` | `./gradlew run` |
| **PHP** | `.php` Extension | `php %:p` |

---

## III. Toolchain & LSP Manifest

Managed via a unified stack for automated binary lifecycle management.

### Language Intelligence
* **Systems:** `clangd` (C), `rust_analyzer` (Rust), `jdtls` (Java).
* **Web:** `typescript-tools` (TS/JS), `intelephense` (PHP), `tailwindcss`, `eslint`.
* **Completion:** `nvim-cmp` with `LuaSnip` integration for high-speed snippet expansion.

### Automated Formatting (Conform.nvim)
| Filetype | Formatter | Hook |
| :--- | :--- | :--- |
| JS / TS / Web | `prettierd` | On Save (Async) |
| Rust | `rustfmt` | On Save (Async) |
| Java | `google-java-format` | On Save (Async) |
| C | `clang-format` | On Save (Async) |

---

## IV. Technical Keymap Manifest

### Navigation & Ergonomics
| Command | Mode | Action | Benefit |
| :--- | :--- | :--- | :--- |
| **Tab / S-Tab** | Normal | Buffer Cycle | Rapid context switching between project files. |
| **n / N** | Normal | Search Next | Integrated `zzzv` for forced center-screen locking. |
| **Ctrl + d / u** | Normal | Scroll | Half-page jump with automatic vertical centering. |
| **Ctrl + h/j/k/l**| Normal | Window Nav | Seamless directional jumps between split panes. |

### Surgical Editing
| Command | Mode | Action | Benefit |
| :--- | :--- | :--- | :--- |
| **Leader + p** | Visual | Smart Paste | Replaces text using the black-hole register (`"_dP`). |
| **Leader + d** | N / V | Silent Delete | Deletes without overwriting the yank register. |
| **Alt + j / k** | N / V | Line Bubbling | Moves blocks with automated indentation logic. |
| **Ctrl + d** | N / V | Multicursor | Parallel editing across multiple matching tokens. |

---

## V. UI & Transparency Engine

NEOZY utilizes a custom transparency loop to support terminal blur and compositor effects.

* **Transparency:** Automatically clears background highlights for `Normal`, `SignColumn`, and `LineNr`.
* **Telemetry:** The Alpha dashboard calculates real-time plugin load counts and startup speed.
* **Notifications:** `Noice.nvim` and `Nvim-notify` provide a professional, structured command palette.

---

## VI. Installation & Deployment

### Systems Environment (Linux/Unix)
```bash
git clone [https://github.com/phantekzy/neozy.git](https://github.com/phantekzy/neozy.git) ~/.config/nvim
