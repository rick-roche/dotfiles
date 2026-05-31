# AGENTS.md

This file provides context and guidance for AI agents working with the dotfiles repository.

## Project Overview

A modular macOS dotfiles repository using **zsh** as the primary shell. The goal is to provide a repeatable, version-controlled approach to setting up and maintaining macOS machines with personalized configurations.

Repository: <https://github.com/rick-roche/dotfiles>
Installation: `git clone https://github.com/rick-roche/dotfiles.git ~/.dotfiles`

## Repository Structure

```
.dotfiles/
├── bin/                    # Executable commands (dispatcher + helpers)
├── modules/                # Feature modules (each is optional)
├── settings/               # Personality/machine-specific configuration files
├── .agents/                # AI skill definitions
├── AGENTS.md               # This file
├── README.md               # Human documentation
├── setup.zsh               # Initial setup helper
└── test.sh                 # Manual test helpers
```

## Module System

Each module in `modules/<name>/` is optional and self-contained:

- **Structure**: One directory per module (e.g., `modules/git/`, `modules/node/`)
- **Activation**: Declared in `settings/_<personality>-setup.zsh` via the `DOTFILES_MODULES` array
- **Execution**: The `dotfiles` dispatcher iterates over `DOTFILES_MODULES` for setup, update, cleanup, and info commands
- **Fallback**: If a hook script is missing (e.g., `_setup.zsh`), the system calls `module_brew_bundle` to install from Brewfile

### Optional Hook Scripts (per module)

| Hook            | Phase   | Purpose                                                                 |
|-----------------|---------|-------------------------------------------------------------------------|
| `_setup.zsh`    | setup   | Install dependencies, symlink config files, run one-time initialization |
| `_update.zsh`   | update  | Update dependencies and configurations                                  |
| `_cleanup.zsh`  | cleanup | Remove module-specific artifacts                                        |
| `_info.zsh`     | info    | Display module information and status                                   |
| `_zshrc.zsh`    | login   | Shell aliases and functions (sourced by `.zshrc`)                       |
| `_zprofile.zsh` | login   | Environment variables (sourced by `.zprofile`)                          |

Each hook script must start with:
```zsh
#!/bin/zsh
# shellcheck shell=bash
. "$DOTFILES_HOME/bin/_bootstrap.zsh"
```

### Standard Files (per module)

- **Brewfile**: Dependencies (homebrew packages and casks); processed by `brew bundle --file=<path>`
- **Brewfile.lock.json**: Generated automatically on first `brew bundle` run; ignore in initial creation
- **config/** or similar: Configuration files to symlink into `$XDG_CONFIG_HOME` or `$HOME`

## Personality System

Machines are configured via **personality files** in `settings/`:

- **Naming**: `_<computer-name>-setup.zsh` (e.g., `_orko-setup.zsh`, `_work-setup.zsh`)
- **Content**: Exports `DOTFILES_PERSONALITY`, module-specific environment variables (e.g., `GPG_KEY`, `EMAIL_ADDRESS`), and `DOTFILES_MODULES` array
- **Pattern**: Extend the base personality and append additional modules:
  ```zsh
  . "$DOTFILES_HOME/settings/_base-setup.zsh"
  export DOTFILES_PERSONALITY=orko
  DOTFILES_MODULES+=(aws azure docker)
  ```
- **Selection**: Automatic (looks for `_<hostname>-setup.zsh`; falls back to `_base-setup.zsh`)

## Code Style & Conventions

### Shell Scripts

- **Shebang**: `#!/bin/zsh` (even though shell target is bash)
- **Linting**: All scripts pass `shellcheck --shell=bash` with no errors
- **Imports**: Always source bootstrap at the top: `. "$DOTFILES_HOME/bin/_bootstrap.zsh"`
- **Logging**: Use `logging_status`, `logging_info`, `logging_debug`, `logging_error` (defined in `_bootstrap.zsh`)
- **Colors**: `${DOTFILES_GREEN}`, `${DOTFILES_RED}`, `${DOTFILES_NOCOLOUR}` for colorized output
- **Errors**: Call `logging_error "message"` to exit with code 1

### Symlinks & Config Files

- **Tool**: Use `stow` to symlink directory trees (e.g., config/, runcom/)
- **Path**: Link into `$XDG_CONFIG_HOME` (~/.config) or `$HOME` as appropriate
- **Example**: `stow -R -d "$DIR" -t "$HOME" runcom` (recurse, replace, specify source dir and target)

### Brewfile Format

```makefile
tap "homebrew/core"
brew "bash"
brew "curl"
cask "visual-studio-code"
```

Order: declare taps first, then brew packages, then casks. Avoid lock files in source control.

## The `dotfiles` Command

Installed by setup; primary entry point for all module operations.

```bash
dotfiles                 # Show usage
dotfiles info            # Display machine setup (personality, modules, paths)
dotfiles setup           # Run initial setup (install all modules in DOTFILES_MODULES)
dotfiles update          # Update all modules
dotfiles cleanup         # Run cleanup scripts for all modules
dotfiles align [--dry-run]  # Align installed packages to Brewfiles
dotfiles reset [--force]    # Full uninstall (brew uninstall all, cleanup scripts)
```

## Testing & Validation

### Manual Tests

Run `./test.sh` for smoke tests (CPU architecture checks, etc.).

### Linting

All hook scripts must pass `shellcheck --shell=bash`:
```bash
shellcheck --shell=bash modules/*/_.*.zsh bin/_*.zsh
```

### Dry-Run Setup

Test a setup without installing:
```bash
DOTFILES_DRY_RUN=1 dotfiles setup
```

## Conventions & Patterns

### Variable Naming

- **Module name**: lowercase with hyphens (e.g., `base-cli`, `raspberry-pi`)
- **Environment exports**: UPPERCASE with underscores (e.g., `DOTFILES_VERBOSE`, `DOTFILES_MODULES`)
- **Local variables**: lowercase with underscores; prefix with underscore if private (e.g., `_module_name`)

### File Ownership

- **One personality file per machine**: `settings/_<hostname>-setup.zsh` (tracked in git)
- **No secrets in git**: Use conditional includes for sensitive data; see git/.gitconfig example
- **Machine-specific config**: Lives in personality file, not in hook scripts

### Error Handling

- **Fail fast**: Scripts exit on errors (set `+e` only when necessary)
- **No silent failures**: Always log before exiting
- **Confirmation**: No interactive prompts in setup/update/cleanup (log and proceed or fail)

## Scope

### In Scope

- Creating new modules for dotfiles
- Updating module Brewfiles and hook scripts
- Adding new personalities (machine configurations)
- Extending the `dotfiles` dispatcher with new commands
- Improving bootstrap functions and logging

### Out of Scope

- Modifying or overriding user's local machine configuration
- Running sudo commands without explicit user confirmation
- Installing packages outside of Brewfile/Homebrew
- Creating or modifying user credentials or secrets

## AI Agent Skills

The `.agents/` directory contains Agent Skills for common workflows:

- **create-module**: Scaffold a new dotfiles module with proper structure, Brewfile, and hook scripts

See [.agents/README.md](.agents/README.md) for details.

## More Information

- [README.md](README.md) — Human-focused documentation and installation instructions
- [Your unofficial guide to dotfiles on GitHub](https://dotfiles.github.io)
- [Conventional Commits](https://www.conventionalcommits.org/)
