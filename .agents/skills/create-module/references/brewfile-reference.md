# Brewfile Reference — Syntax and Conventions

This document covers Brewfile format, conventions, and best practices used throughout the dotfiles repository.

---

## Brewfile Basics

A Brewfile is a text file that declares dependencies for Homebrew to install. It's processed by `brew bundle --file=<path>`.

### Minimal Brewfile

```makefile
tap "homebrew/core"
brew "curl"
```

### Empty Brewfile (if no dependencies)

```makefile
# No dependencies for this module
```

---

## Brewfile Format

### General Rules

1. **Taps must come first**: Declare all taps before brew/cask entries
2. **One entry per line**: Each package is a single line
3. **No comments or blank lines between entries** (comments at start are OK)
4. **Quote the package name**: `brew "name"`, `tap "name/tap"`
5. **No version pinning** in the main Brewfile (versions go in `Brewfile.lock.json`)

### Order of Entries

```makefile
# 1. Taps (always first)
tap "homebrew/core"
tap "homebrew/bundle"

# 2. Brew packages (CLI tools)
brew "bash"
brew "curl"
brew "git"

# 3. Casks (GUI apps)
cask "visual-studio-code"
cask "docker"
```

---

## Tap Format

A tap is a repository of formulae; taps are declared before brew/cask entries.

### Standard Taps

```makefile
tap "homebrew/core"      # Main Homebrew repository (usually optional)
tap "homebrew/bundle"    # Homebrew bundle support
tap "homebrew/cask"      # GUI applications (usually implicit)
```

### Third-Party Taps

```makefile
tap "user/repository"    # e.g., "aws/tap" for AWS CLI
```

### Syntax

```makefile
tap "tap-name"
tap "tap-name", "https://github.com/user/repo.git"  # With custom URL
```

---

## Brew Format

Brew packages are command-line tools and libraries.

### Syntax

```makefile
brew "package-name"
brew "package-name", args: ["--with-option"]  # With options (rare)
```

### Examples

```makefile
brew "bash"
brew "coreutils"
brew "curl"
brew "diff-so-fancy"
brew "git"
brew "jq"
brew "gnu-sed"
brew "openssl"
brew "rsync"
brew "shellcheck"
brew "stow"
brew "tree"
brew "wget"
```

---

## Cask Format

Casks are GUI applications and larger tools.

### Syntax

```makefile
cask "app-name"
cask "app-name", args: { appdir: "/Applications" }  # With options (rare)
```

### Examples

```makefile
cask "visual-studio-code"
cask "docker"
cask "iterm2"
cask "vlc"
```

### Finding Cask Names

```bash
brew search visual-studio-code
# Returns available cask names
```

---

## Complete Examples

### Simple Brewfile (Dependencies Only)

```makefile
tap "homebrew/core"
brew "bash"
brew "curl"
```

### Module with CLI Tools and Apps

```makefile
tap "homebrew/core"
tap "homebrew/bundle"

brew "git"
brew "jq"
brew "curl"
cask "visual-studio-code"
cask "docker"
```

### Large Module with Many Dependencies

```makefile
tap "homebrew/core"
tap "homebrew/bundle"
tap "aws/tap"

brew "bash"
brew "curl"
brew "coreutils"
brew "diff-so-fancy"
brew "gnu-sed"
brew "grep"
brew "jq"
brew "openssl"
brew "rclone"
brew "rsync"
brew "shellcheck"
brew "stow"
brew "tree"
brew "wget"
```

---

## Real Examples from Repository

### modules/base-cli/Brewfile

```makefile
tap "homebrew/bundle"
tap "homebrew/core"

brew "bash"
brew "curl"
brew "coreutils"
brew "diff-so-fancy"
brew "gnu-sed"
brew "grep"
brew "jq"
brew "openssl"
brew "rclone"
brew "rsync"
brew "shellcheck"
brew "stow"
brew "tree"
brew "thefuck"
brew "unzip"
brew "wget"
```

**Purpose**: Provides essential command-line tools used across all machines.

---

### modules/aws/Brewfile

```makefile
tap "aws/tap"

brew "aws-cli"
brew "aws-vault"
```

**Purpose**: AWS-specific CLI tools.

---

### modules/zsh/Brewfile

```makefile
tap "homebrew/core"

brew "zsh"
brew "zsh-completions"
```

**Purpose**: Zsh and completions.

---

### modules/media/Brewfile

```makefile
tap "homebrew/core"

brew "ffmpeg"
cask "vlc"
```

**Purpose**: Media tools and players.

---

## Brewfile.lock.json

**Purpose**: Lock specific versions of all installed packages and dependencies.

### Important Rules

1. **Auto-generated**: Created by `brew bundle` on first run
2. **Do NOT create manually**: Never edit by hand
3. **Do NOT commit to git**: Add `Brewfile.lock.json` to `.gitignore`
4. **Different per machine**: Lock files vary based on macOS version and installed packages

### Example Lock File Structure

```json
{
  "tap": {
    "homebrew/core": { "revision": "abc123..." },
    "homebrew/bundle": { "revision": "def456..." }
  },
  "brew": {
    "bash": { "version": "5.2.21" },
    "curl": { "version": "8.0.1" }
  },
  "cask": {
    "visual-studio-code": { "version": "1.80.0" }
  }
}
```

### Workflow

1. Create/edit `Brewfile` (no versions)
2. Run `brew bundle --file=Brewfile`
3. `Brewfile.lock.json` is generated automatically
4. Commit `Brewfile`; ignore `Brewfile.lock.json`

---

## Installation & Usage

### Install from Brewfile

```bash
# Install all packages in the Brewfile
brew bundle --file=Brewfile

# Install and show what would be changed
brew bundle --file=Brewfile --verbose

# Dry run (show what would happen, don't install)
brew bundle --file=Brewfile --dry-run
```

### Module-Based Installation

The dotfiles dispatcher calls:

```zsh
module_brew_bundle "<module-name>"
```

Which runs:

```zsh
brew_bundle "$DOTFILES_HOME/modules/<module-name>/Brewfile"
```

---

## Best Practices

### 1. Keep Brewfiles Simple

- Declare dependencies clearly
- One Brewfile per module
- No version constraints (use lock file instead)

### 2. Order Consistently

- Taps first
- Brew packages next
- Casks last

### 3. Use Meaningful Comments (Before Entries)

```makefile
# Core command-line tools
tap "homebrew/core"
brew "bash"
brew "curl"

# Media tools
brew "ffmpeg"
cask "vlc"
```

### 4. Name Packages Correctly

```bash
# Find the correct brew name
brew search <package>

# Find the correct cask name
brew search --cask <app>
```

### 5. Test Before Committing

```bash
# Validate Brewfile syntax
brew bundle --file=<path> --dry-run

# Install and verify
brew bundle --file=<path>
```

---

## Troubleshooting

### "Package not found"

**Problem**: `brew bundle` fails with "Package not found"

**Solution**:
1. Check spelling: `brew search <package>`
2. Verify it's a brew formula (not a cask)
3. Ensure taps are declared (some packages require specific taps)

**Example**:
```bash
# Wrong
brew "aws-cli"

# Right (requires tap)
tap "aws/tap"
brew "aws-cli"
```

---

### "Cask not found"

**Problem**: `brew bundle` fails for a cask

**Solution**:
1. Find the correct cask name: `brew search --cask <app>`
2. Verify the tap is declared (some casks require specific taps)

**Example**:
```bash
# Check for the cask
brew search --cask visual
# Returns: visual-studio-code

# Add to Brewfile
cask "visual-studio-code"
```

---

### "Lock file mismatch"

**Problem**: `Brewfile.lock.json` is out of sync with `Brewfile`

**Solution**:
1. Delete the lock file: `rm Brewfile.lock.json`
2. Reinstall: `brew bundle --file=Brewfile`
3. Lock file is regenerated

---

## Syntax Validation

### Check Brewfile Syntax

```bash
# Dry run (validates and shows what would happen)
brew bundle --file=<path> --dry-run

# Full installation (creates lock file)
brew bundle --file=<path>
```

### No Separate Linter

Brewfile has no separate linter; `brew bundle --dry-run` is the validation tool.

---

## See Also

- [module-anatomy.md](module-anatomy.md) — Complete module structure reference
- [hook-scripts.md](hook-scripts.md) — Patterns for hook scripts
- [AGENTS.md](../../../../AGENTS.md) — Full repository conventions
- [Homebrew Bundle Docs](https://github.com/Homebrew/homebrew-bundle)
