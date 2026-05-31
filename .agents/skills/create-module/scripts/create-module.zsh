#!/bin/zsh
# shellcheck shell=bash

# create-module.zsh — Scaffold a new dotfiles module
#
# Usage: create-module.zsh <module-name>
# Example: create-module.zsh my-tool

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Determine DOTFILES_HOME
if [[ -z "$DOTFILES_HOME" ]]; then
    DOTFILES_HOME="$HOME/.dotfiles"
fi

# Validate arguments
if [[ $# -ne 1 ]]; then
    echo "Usage: create-module.zsh <module-name>"
    echo "Example: create-module.zsh my-tool"
    exit 1
fi

MODULE_NAME="$1"

# Validate module name
# Rules:
# - Lowercase letters, numbers, and hyphens only
# - Must not start or end with a hyphen
# - Must not contain consecutive hyphens
if ! [[ "$MODULE_NAME" =~ ^[a-z0-9]([a-z0-9-]*[a-z0-9])?$ ]]; then
    echo -e "${RED}Error:${NC} Invalid module name: $MODULE_NAME"
    echo "Module names must:"
    echo "  - Contain only lowercase letters, numbers, and hyphens"
    echo "  - Not start or end with a hyphen"
    echo "  - Not contain consecutive hyphens"
    exit 1
fi

# Check if module already exists
MODULE_DIR="$DOTFILES_HOME/modules/$MODULE_NAME"
if [[ -d "$MODULE_DIR" ]]; then
    echo -e "${RED}Error:${NC} Module already exists: $MODULE_DIR"
    exit 1
fi

# Create module directory
echo -e "${GREEN}Creating module:${NC} $MODULE_NAME"
mkdir -p "$MODULE_DIR"

# Create Brewfile (empty stub)
cat > "$MODULE_DIR/Brewfile" <<'EOF'
tap "homebrew/core"

# Add dependencies here
# brew "package-name"
# cask "app-name"
EOF

echo -e "${GREEN}✓${NC} Created: Brewfile"

# Create _setup.zsh stub
cat > "$MODULE_DIR/_setup.zsh" <<'EOF'
#!/bin/zsh
# shellcheck shell=bash

. "$DOTFILES_HOME/bin/_bootstrap.zsh"
DIR=$(dirname "$0")

logging_status "Setting up $(basename "$DIR")"

# Install dependencies from Brewfile
module_brew_bundle "$(basename "$DIR")"

# TODO: Add initialization logic here
# Examples:
#   - Symlink config files: stow -R -d "$DIR" -t "$XDG_CONFIG_HOME" config
#   - Substitute templates: sed "s/PLACEHOLDER/$VALUE/g" template > output
#   - Download files: curl -o ~/file https://example.com/file

logging_status "Setup complete"
EOF

chmod +x "$MODULE_DIR/_setup.zsh"
echo -e "${GREEN}✓${NC} Created: _setup.zsh (executable)"

# Print next steps
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Edit the Brewfile to declare dependencies:"
echo "   $MODULE_DIR/Brewfile"
echo ""
echo "2. Edit _setup.zsh if you need initialization logic"
echo ""
echo "3. Register the module in a personality file:"
echo "   Edit: $DOTFILES_HOME/settings/_<personality>-setup.zsh"
echo "   Add: DOTFILES_MODULES+=($MODULE_NAME)"
echo ""
echo "4. Test the setup:"
echo "   $DOTFILES_HOME/bin/dotfiles setup"
echo ""
echo "5. Validate with shellcheck:"
echo "   shellcheck --shell=bash $MODULE_DIR/*.zsh"
echo ""
echo -e "${GREEN}Module $MODULE_NAME created successfully!${NC}"
