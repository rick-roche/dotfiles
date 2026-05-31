---
name: create-module
description: Scaffold a new dotfiles module with proper directory structure, Brewfile, hook scripts, and registration in personality files. Use when creating a new module from scratch or extending the dotfiles with new functionality.
---

# Create a New Dotfiles Module

This skill guides you through creating a well-structured dotfiles module that follows the repository conventions and integrates seamlessly with the module system.

## Overview

A module is a self-contained directory in `modules/<name>/` that manages a specific feature or application. The skill covers:

1. **Naming** your module
2. **Creating** the directory structure
3. **Writing** a Brewfile for dependencies
4. **Choosing** which hook scripts you need
5. **Registering** the module in a personality file
6. **Testing** the module

---

## Step 1: Choose a Module Name

Module names must be:
- Lowercase letters, numbers, and hyphens only
- Descriptive and concise (e.g., `base-cli`, `raspberry-pi`, `dev`)
- **Not** existing module names in `modules/`

Examples: `my-tool`, `dev-utils`, `custom-config`

---

## Step 2: Create the Module Directory

Create the directory structure:

```bash
mkdir -p "$HOME/.dotfiles/modules/<name>"
```

**Quick scaffold:**
```bash
./.agents/skills/create-module/scripts/create-module.zsh <name>
```

This creates the directory and stub files automatically.

---

## Step 3: Create a Brewfile

Every module should have a `Brewfile` listing its dependencies. See [brewfile-reference.md](references/brewfile-reference.md) for syntax details.

**Minimal example** (`modules/<name>/Brewfile`):
```makefile
tap "homebrew/core"
brew "git"
cask "visual-studio-code"
```

**Empty Brewfile** (if no dependencies):
```makefile
# No dependencies for this module
```

---

## Step 4: Decide Which Hook Scripts You Need

Modules can include optional hook scripts that run at different phases. See [hook-scripts.md](references/hook-scripts.md) for detailed patterns and examples.

### Quick Reference

| Hook            | When to use                                                  |
|-----------------|--------------------------------------------------------------|
| `_setup.zsh`    | Install dependencies, symlink files, one-time initialization |
| `_update.zsh`   | Update dependencies and refresh configurations               |
| `_cleanup.zsh`  | Remove module artifacts when cleaning up                     |
| `_info.zsh`     | Display module status or configuration                       |
| `_zshrc.zsh`    | Shell aliases and functions (sourced on every shell login)   |
| `_zprofile.zsh` | Environment variables (sourced once at shell startup)        |

**Common patterns:**
- **Simple dependency module**: Just Brewfile (fallback to `module_brew_bundle`)
- **With initialization**: `_setup.zsh` + Brewfile
- **With shell integration**: `_setup.zsh` + `_zshrc.zsh` + Brewfile
- **With config files**: `_setup.zsh` (uses `stow`) + Brewfile

---

## Step 5: Create Hook Scripts (if needed)

Each hook script must start with:

```zsh
#!/bin/zsh
# shellcheck shell=bash

. "$DOTFILES_HOME/bin/_bootstrap.zsh"
```

Then add your logic. See [hook-scripts.md](references/hook-scripts.md) for boilerplate templates and working examples from the repository.

### Typical `_setup.zsh` Pattern

```zsh
#!/bin/zsh
# shellcheck shell=bash

. "$DOTFILES_HOME/bin/_bootstrap.zsh"
DIR=$(dirname "$0")

# Install dependencies from Brewfile
module_brew_bundle "$(basename "$DIR")"

# Optional: symlink config files using stow
stow -R -d "$DIR" -t "$HOME" config

logging_status "Module setup complete"
```

---

## Step 6: Register the Module in a Personality File

To activate your module, add it to a personality file in `settings/`:

```zsh
# In settings/_<personality>-setup.zsh (e.g., _base-setup.zsh or _orko-setup.zsh)

export DOTFILES_MODULES=(
    homebrew
    git
    base-cli
    <your-module-name>  # Add here
)
```

Or append to an existing personality:

```zsh
DOTFILES_MODULES+=(<your-module-name>)
```

---

## Step 7: Test Your Module

### Run Setup

Test the setup phase:

```bash
# Dry run (simulates without installing)
DOTFILES_VERBOSE=1 dotfiles setup

# Or test just your module
cd modules/<name>
bash _setup.zsh
```

### Validate with `shellcheck`

All shell scripts must pass linting:

```bash
shellcheck --shell=bash modules/<name>/*.zsh
```

Fix any warnings before committing.

### Test Updates and Cleanup

If you added `_update.zsh` or `_cleanup.zsh`:

```bash
DOTFILES_VERBOSE=1 dotfiles update
DOTFILES_VERBOSE=1 dotfiles cleanup
```

---

## File Structure Reference

See [module-anatomy.md](references/module-anatomy.md) for a complete breakdown of module files and directories, with real examples from the repository.

---

## Common Patterns & Decisions

### Pattern 1: Dependency-Only Module

**Use case**: Install packages via Homebrew with no special setup.

```
modules/my-tools/
├── Brewfile
└── (optional) Brewfile.lock.json (auto-generated)
```

The `module_brew_bundle` fallback handles installation.

---

### Pattern 2: Setup + Dependencies

**Use case**: Install packages and run initialization (download files, create directories, etc.).

```
modules/my-tools/
├── Brewfile
├── _setup.zsh
└── (optional) Brewfile.lock.json
```

Typically `_setup.zsh` calls `module_brew_bundle` first, then does setup.

---

### Pattern 3: Shell Integration

**Use case**: Add aliases, functions, or environment variables to your shell.

```
modules/my-tools/
├── Brewfile
├── _setup.zsh
└── _zshrc.zsh
```

`_zshrc.zsh` is sourced every time you open a shell; use for aliases and functions.
`_setup.zsh` is run once at setup time; use for installation and initialization.

---

### Pattern 4: Config Files + Symlinks

**Use case**: Manage configuration files (e.g., starship.toml, .config/app/config.json).

```
modules/my-tools/
├── Brewfile
├── _setup.zsh
├── config/
│   └── my-app/
│       └── settings.toml
└── runcom/
    └── .myrc
```

In `_setup.zsh`:
```zsh
stow -R -d "$DIR" -t "$XDG_CONFIG_HOME" config
stow -R -d "$DIR" -t "$HOME" runcom
```

This symlinks `config/my-app/` → `~/.config/my-app/` and `.myrc` → `~/.myrc`.

---

## Troubleshooting

### "Module not found" after adding to personality

**Check:**
1. Did you create the directory `modules/<name>/`?
2. Did you spell the module name correctly in the personality file?
3. Did you run `dotfiles setup` after editing the personality file?

### Setup script fails

**Check:**
1. Run `shellcheck --shell=bash modules/<name>/*.zsh` — fix any lint errors
2. Add `DOTFILES_VERBOSE=1` to see debug output: `DOTFILES_VERBOSE=1 dotfiles setup`
3. Ensure you're sourcing `_bootstrap.zsh` at the top of every hook script

### Brewfile installs fail

**Check:**
1. Run `brew bundle --file=modules/<name>/Brewfile` manually to see the error
2. Verify the Brewfile syntax (see [brewfile-reference.md](references/brewfile-reference.md))
3. Check that homebrew is installed and up-to-date: `brew --version`

---

## Next Steps

- **Review repository conventions** in [AGENTS.md](../../../AGENTS.md)
- **Explore module examples** in `modules/git/`, `modules/zsh/`, `modules/node/`
- **Run the scaffold script** to stub out a new module: `.agents/skills/create-module/scripts/create-module.zsh <name>`
- **Test thoroughly** before committing to ensure all hooks work correctly

---

## See Also

- [module-anatomy.md](references/module-anatomy.md) — Complete file structure and examples
- [hook-scripts.md](references/hook-scripts.md) — Detailed patterns for each hook
- [brewfile-reference.md](references/brewfile-reference.md) — Brewfile syntax and conventions
- [AGENTS.md](../../../AGENTS.md) — Full repository conventions and patterns
