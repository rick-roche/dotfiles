# Hook Scripts — Patterns and Boilerplate

This document provides detailed patterns, boilerplate templates, and real examples for each hook script type.

---

## Overview

Hook scripts are optional shell scripts that run at different phases of the module lifecycle:

| Hook | Phase | When | Typical Use |
|------|-------|------|-------------|
| `_setup.zsh` | Initialize | First time (manual or via `dotfiles setup`) | Install packages, symlink config, download files |
| `_update.zsh` | Update | Via `dotfiles update` | Update packages and refresh configurations |
| `_cleanup.zsh` | Cleanup | Via `dotfiles cleanup` | Remove symlinks, delete generated files |
| `_info.zsh` | Info | Via `dotfiles info` | Display module status and configuration |
| `_zshrc.zsh` | Login | Every shell login | Aliases, functions, shell options |
| `_zprofile.zsh` | Login | Once at shell startup | Environment variables, PATH exports |

---

## General Patterns

### Every Hook Script Must Start With

```zsh
#!/bin/zsh
# shellcheck shell=bash

. "$DOTFILES_HOME/bin/_bootstrap.zsh"
```

**Why:**
- Shebang tells the system to use zsh
- `# shellcheck shell=bash` tells the linter the target is bash (for portability)
- Sourcing `_bootstrap.zsh` provides logging functions and environment variables

### Available Functions (from _bootstrap.zsh)

```zsh
logging_status "message"    # Green status message (always shown)
logging_info "message"      # Info message (shown if DOTFILES_VERBOSE>=1)
logging_debug "message"     # Debug message (shown if DOTFILES_VERBOSE=2)
logging_error "message"     # Error message; exits with code 1
```

**Example**:
```zsh
logging_status "Installing packages..."
module_brew_bundle "my-module"
logging_status "Setup complete"
```

### Available Variables

```zsh
$DOTFILES_HOME        # Path to .dotfiles repo (~/.dotfiles)
$DOTFILES_PERSONALITY # Current personality (e.g., "base", "orko")
$DOTFILES_MODULES     # Array of active modules
$XDG_CONFIG_HOME      # Config directory (~/.config)
$EMAIL_ADDRESS        # User email (from personality file)
$GPG_KEY              # GPG key ID (from personality file)
```

### Typical Pattern: Get Module Directory

```zsh
DIR=$(dirname "$0")          # Directory of this script
MODULE_NAME=$(basename "$DIR")  # Module name
```

---

## _setup.zsh

**Purpose**: Run once at setup time to install dependencies, initialize, and symlink configuration files.

**When to create**: Almost always. Even simple modules should have this to call `module_brew_bundle`.

### Minimal Boilerplate

```zsh
#!/bin/zsh
# shellcheck shell=bash

. "$DOTFILES_HOME/bin/_bootstrap.zsh"
DIR=$(dirname "$0")

# Install dependencies from Brewfile
module_brew_bundle "$(basename "$DIR")"

logging_status "Setup complete"
```

---

### Common Patterns

#### Pattern 1: Install + Symlink Config Files

```zsh
#!/bin/zsh
# shellcheck shell=bash

. "$DOTFILES_HOME/bin/_bootstrap.zsh"
DIR=$(dirname "$0")

# Install packages
module_brew_bundle "$(basename "$DIR")"

# Symlink config files
mkdir -p "$XDG_CONFIG_HOME"
stow -R -d "$DIR" -t "$XDG_CONFIG_HOME" config

logging_status "Setup complete"
```

**How it works**:
- `stow -R` means "recurse" and "replace"
- `-d "$DIR"` specifies the source directory
- `-t "$XDG_CONFIG_HOME"` specifies the target directory
- `config` is the subdirectory within `$DIR/config/`

**Example**: `modules/zsh/config/starship/starship.toml` → `~/.config/starship/starship.toml`

---

#### Pattern 2: Install + Symlink Multiple Directories

```zsh
#!/bin/zsh
# shellcheck shell=bash

. "$DOTFILES_HOME/bin/_bootstrap.zsh"
DIR=$(dirname "$0")

module_brew_bundle "$(basename "$DIR")"

# Symlink config files
stow -R -d "$DIR" -t "$XDG_CONFIG_HOME" config

# Symlink home directory dotfiles
stow -R -d "$DIR" -t "$HOME" runcom

logging_status "Setup complete"
```

---

#### Pattern 3: Install + Substitute Template

```zsh
#!/bin/zsh
# shellcheck shell=bash

. "$DOTFILES_HOME/bin/_bootstrap.zsh"
DIR=$(dirname "$0")

# Create directories
mkdir -p "$DIR/git"

# Substitute variables into config template
sed "s/EMAILADDRESS/$EMAIL_ADDRESS/g" "$DIR/config.template" >"$DIR/git/config"
sed -i "s/GPGKEY/$GPG_KEY/g" "$DIR/git/config"
cp "$DIR/ignore" "$DIR/git/ignore"

# Symlink config
mkdir -p "$XDG_CONFIG_HOME"
ln -s -f "$DIR/git" "$XDG_CONFIG_HOME"

# Install packages
module_brew_bundle "$(basename "$DIR")"

logging_status "Setup complete"
```

**Real example**: `modules/git/_setup.zsh` (see below)

---

#### Pattern 4: Conditional Installation

```zsh
#!/bin/zsh
# shellcheck shell=bash

. "$DOTFILES_HOME/bin/_bootstrap.zsh"
DIR=$(dirname "$0")

# Check if tool is already installed
if command -v node &> /dev/null; then
    logging_info "Node.js already installed"
else
    logging_status "Installing Node.js"
    module_brew_bundle "$(basename "$DIR")"
fi

logging_status "Setup complete"
```

---

### Real Examples from Repository

#### Example 1: git/_setup.zsh

```zsh
#!/bin/zsh
# shellcheck shell=bash

DIR=$(dirname "$0")
. "$DOTFILES_HOME/bin/_bootstrap.zsh"

mkdir -p "$DOTFILES_HOME/modules/git/git"

sed "s/EMAILADDRESS/$EMAIL_ADDRESS/g" "$DIR/config.template" >"$DIR/git/config"
sed -i "s/GPGKEY/$GPG_KEY/g" "$DIR/git/config"
cp "$DIR/ignore" "$DIR/git/ignore"

# Link the config
mkdir -p "$XDG_CONFIG_HOME"
ln -s -f "$DIR/git" "$XDG_CONFIG_HOME"

module_brew_bundle "$(basename "$DIR")"
```

**What it does**:
1. Creates `modules/git/git/` directory
2. Substitutes email and GPG key into git config
3. Copies gitignore rules
4. Symlinks config to `~/.config/git`
5. Installs packages from Brewfile

---

#### Example 2: zsh/_setup.zsh

```zsh
#!/bin/zsh
# shellcheck shell=bash

. "$DOTFILES_HOME/bin/_bootstrap.zsh"
DIR=$(dirname "$0")

# Install oh-my-zsh
if [ -d "$ZSH" ]; then
    "$ZSH"/tools/upgrade.sh
else
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

module_brew_bundle "$(basename "$DIR")"

# Install fonts
curl -o "$HOME/Library/Fonts/MesloLGS NF Regular.ttf" -fsSL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
curl -o "$HOME/Library/Fonts/MesloLGS NF Bold.ttf" -fsSL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf

# Link config files
rm -rf ~/.zshrc ~/.zprofile
stow -R -d "$DIR" -t "$HOME" runcom
stow -R -d "$DIR" -t "$XDG_CONFIG_HOME" starship
```

**What it does**:
1. Installs or upgrades oh-my-zsh
2. Installs packages from Brewfile
3. Downloads fonts
4. Symlinks config files using stow

---

## _update.zsh

**Purpose**: Update dependencies and refresh configurations.

**When to create**: When your module has packages to update, or if setup does initialization that needs refreshing.

### Minimal Boilerplate

```zsh
#!/bin/zsh
# shellcheck shell=bash

. "$DOTFILES_HOME/bin/_bootstrap.zsh"
DIR=$(dirname "$0")

module_brew_bundle "$(basename "$DIR")"

logging_status "Update complete"
```

---

### Common Patterns

#### Pattern 1: Update Packages Only

```zsh
#!/bin/zsh
# shellcheck shell=bash

. "$DOTFILES_HOME/bin/_bootstrap.zsh"

module_brew_bundle "$(basename "$(dirname "$0")")"
```

---

#### Pattern 2: Update + Refresh Configuration

```zsh
#!/bin/zsh
# shellcheck shell=bash

. "$DOTFILES_HOME/bin/_bootstrap.zsh"
DIR=$(dirname "$0")

# Update packages
module_brew_bundle "$(basename "$DIR")"

# Refresh symlinks
stow -R -d "$DIR" -t "$XDG_CONFIG_HOME" config

logging_status "Update complete"
```

---

### Real Example from Repository

#### zsh/_update.zsh

```zsh
#!/bin/zsh
# shellcheck shell=bash

. "$DOTFILES_HOME/bin/_bootstrap.zsh"

logging_info "Updating zsh packages"
module_brew_bundle "$(basename "$(dirname "$0")")"
```

---

## _cleanup.zsh

**Purpose**: Remove module-specific artifacts when cleaning up.

**When to create**: If your module creates symlinks, generates files, or installs tools that should be removed.

### Minimal Boilerplate

```zsh
#!/bin/zsh
# shellcheck shell=bash

. "$DOTFILES_HOME/bin/_bootstrap.zsh"
DIR=$(dirname "$0")

# Remove symlinks or generated files
rm -f "$XDG_CONFIG_HOME/my-module"

logging_status "Cleanup complete"
```

---

### Common Patterns

#### Pattern 1: Remove Symlinks

```zsh
#!/bin/zsh
# shellcheck shell=bash

. "$DOTFILES_HOME/bin/_bootstrap.zsh"

rm -f "$XDG_CONFIG_HOME/my-module"
rm -f "$HOME/.myrc"

logging_status "Cleanup complete"
```

---

#### Pattern 2: Remove Generated Files

```zsh
#!/bin/zsh
# shellcheck shell=bash

. "$DOTFILES_HOME/bin/_bootstrap.zsh"
DIR=$(dirname "$0")

# Remove symlinks
rm -f "$XDG_CONFIG_HOME/app-name"

# Remove generated files
rm -rf "$DIR/generated/"
rm -rf "$HOME/.cache/my-module/"

logging_status "Cleanup complete"
```

---

## _info.zsh

**Purpose**: Display module status and configuration.

**When to create**: For modules you want to monitor or troubleshoot (optional).

### Minimal Boilerplate

```zsh
#!/bin/zsh
# shellcheck shell=bash

. "$DOTFILES_HOME/bin/_bootstrap.zsh"

echo "Module: $(basename "$(dirname "$0")")"
echo "Status: OK"
```

---

### Common Patterns

#### Pattern 1: Display Installed Packages

```zsh
#!/bin/zsh
# shellcheck shell=bash

. "$DOTFILES_HOME/bin/_bootstrap.zsh"

MODULE_NAME=$(basename "$(dirname "$0")")
echo "Module: $MODULE_NAME"
echo "Installed:"
brew list --formula | grep -E "package1|package2"
```

---

## _zshrc.zsh (Shell Aliases & Functions)

**Purpose**: Provide aliases and functions available in every shell.

**When to create**: When your module needs shell integrations (aliases, functions, completions).

**Important**: Does NOT source `_bootstrap.zsh`. It's a shell extension file.

### Minimal Boilerplate

```zsh
#!/bin/zsh
# shellcheck shell=bash

alias myalias="command --option"
```

---

### Common Patterns

#### Pattern 1: Simple Aliases

```zsh
#!/bin/zsh
# shellcheck shell=bash

alias ga="git add"
alias gc="git commit"
alias gs="git status"
alias gd="git diff"
```

---

#### Pattern 2: Aliases with Functions

```zsh
#!/bin/zsh
# shellcheck shell=bash

alias reload="exec zsh"
alias chx="find . -name '*.sh' -exec chmod +x {} \;"

# Function to find and open a file
myfind() {
    find . -name "$1" -type f
}
```

---

#### Pattern 3: Shell Initialization

```zsh
#!/bin/zsh
# shellcheck shell=bash

eval "$(thefuck --alias)"
eval "$(starship init zsh)"
```

---

### Real Example from Repository

#### base-cli/_zshrc.zsh

```zsh
#!/bin/zsh
# shellcheck shell=bash

alias chx="find . -name '*.sh' -exec chmod +x {} \;"
alias chxz="find . -name '*.zsh' -exec chmod +x {} \;"
alias reload="exec zsh"

eval "$(thefuck --alias)"

export PATH="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"
```

---

## _zprofile.zsh (Environment Variables)

**Purpose**: Set environment variables and PATH exports.

**When to create**: When your module needs to modify `$PATH` or set global environment variables.

**Important**: Does NOT source `_bootstrap.zsh`. It's a shell extension file, sourced once at startup.

### Minimal Boilerplate

```zsh
#!/bin/zsh
# shellcheck shell=bash

export VAR_NAME="value"
export PATH="/some/path:$PATH"
```

---

### Common Patterns

#### Pattern 1: Add to PATH

```zsh
#!/bin/zsh
# shellcheck shell=bash

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"
```

---

#### Pattern 2: Set Language/Version Variables

```zsh
#!/bin/zsh
# shellcheck shell=bash

export JAVA_HOME="/usr/libexec/java_home"
export GOROOT="/usr/local/go"
export PYTHONPATH="$HOME/.local/lib/python3.11"
```

---

#### Pattern 3: Enable Features

```zsh
#!/bin/zsh
# shellcheck shell=bash

export HISTSIZE=10000
export SAVEHIST=10000
export EDITOR=vim
```

---

## Validation Checklist

Before committing hook scripts:

- [ ] Shebang: `#!/bin/zsh`
- [ ] Linting comment: `# shellcheck shell=bash`
- [ ] Bootstrap sourced: `. "$DOTFILES_HOME/bin/_bootstrap.zsh"` (except `_zshrc.zsh`, `_zprofile.zsh`)
- [ ] No syntax errors: `shellcheck --shell=bash modules/<name>/*.zsh`
- [ ] Logging used for status/errors (not `echo`)
- [ ] Variables quoted: `"$VAR"` not `$VAR`
- [ ] Tested manually: Run script and verify behavior

---

## Common Mistakes

| Mistake | Issue | Fix |
|---------|-------|-----|
| Forgetting shebang | Script won't execute | Add `#!/bin/zsh` at top |
| Not sourcing `_bootstrap.zsh` | Logging functions unavailable | Add `. "$DOTFILES_HOME/bin/_bootstrap.zsh"` |
| Using `echo` instead of logging | Output not formatted; hard to parse | Use `logging_status`, `logging_info`, etc. |
| Unquoted variables | Word splitting and glob expansion errors | Quote all variables: `"$VAR"` |
| Missing `/bin/bash` for shellcheck | Linter treats as zsh, misses bash bugs | Add comment: `# shellcheck shell=bash` |
| Creating `_zshrc.zsh` that sources bootstrap | Massive slowdown (bootstrap runs every login) | Remove bootstrap source from `_zshrc.zsh` |

---

## See Also

- [module-anatomy.md](module-anatomy.md) — Complete file structure reference
- [brewfile-reference.md](brewfile-reference.md) — Brewfile syntax and conventions
- [AGENTS.md](../../../../AGENTS.md) — Full repository conventions
