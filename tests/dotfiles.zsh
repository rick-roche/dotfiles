#!/usr/bin/env zsh
emulate -R zsh
setopt errexit nounset pipefail

repo=$(cd "$(dirname "$0")/.." && pwd -P)
tmp=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-test.XXXXXXXX")
trap 'rm -rf -- "$tmp"' EXIT

fail() {
    print -u2 "FAIL: $*"
    exit 1
}

home="$tmp/home"
dotfiles="$home/.dotfiles"
mkdir -p "$dotfiles/bin" "$dotfiles/settings" "$dotfiles/modules/example" "$tmp/bin"
cp "$repo/bin/"{_bootstrap.zsh,_functions.zsh,dotfiles,dotfiles-setup,dotfiles-reset} "$dotfiles/bin/"
chmod +x "$dotfiles/bin/"*
cat >"$dotfiles/settings/_$(uname -n)-setup.zsh" <<'SETTINGS'
export DOTFILES_PERSONALITY=test
export DOTFILES_MODULES=(example)
SETTINGS
cat >"$dotfiles/modules/example/_setup.zsh" <<'HOOK'
print -r -- "${DOTFILES_MODULE_DIR:-}" > "$HOME/setup-module-dir"
HOOK
chmod +x "$dotfiles/modules/example/_setup.zsh"

# Setup hooks must receive their actual module directory when sourced by setup.
HOME="$home" "$dotfiles/bin/dotfiles-setup" >/dev/null 2>&1 || [[ $? -eq 2 ]]
[[ "$(<"$home/setup-module-dir")" == "$dotfiles/modules/example" ]] || fail 'setup did not expose the selected module directory'

# Reject misspelled/nonexistent modules from a personality before dispatch.
cat >"$dotfiles/settings/_$(uname -n)-setup.zsh" <<'SETTINGS'
export DOTFILES_PERSONALITY=test
export DOTFILES_MODULES=(missing-module)
SETTINGS
if HOME="$home" "$dotfiles/bin/dotfiles-setup" >"$tmp/invalid-module.log" 2>&1; then
    fail 'setup accepted an unknown configured module'
fi
grep -q 'Invalid or unknown module in settings: missing-module' "$tmp/invalid-module.log" || fail 'invalid module was not identified'

cat >"$dotfiles/settings/_$(uname -n)-setup.zsh" <<'SETTINGS'
export DOTFILES_PERSONALITY=test
export DOTFILES_MODULES=(example)
SETTINGS

# Unknown commands must fail rather than returning success.
if HOME="$home" "$dotfiles/bin/dotfiles" unknown >/dev/null 2>&1; then
    fail 'unknown command returned success'
fi

# Reset must require --force before invoking any package manager operations.
cat >"$tmp/bin/brew" <<'BREW'
#!/bin/sh
echo "$*" >> "$BREW_LOG"
BREW
chmod +x "$tmp/bin/brew"
export PATH="$tmp/bin:$PATH" BREW_LOG="$tmp/brew.log"
if HOME="$home" "$dotfiles/bin/dotfiles" reset >/dev/null 2>&1; then
    fail 'reset without --force returned success'
fi
[[ ! -e "$BREW_LOG" ]] || fail 'reset without --force invoked Homebrew'
HOME="$home" "$dotfiles/bin/dotfiles" reset --force >/dev/null
[[ $(grep -c '^uninstall ' "$BREW_LOG") -eq 2 ]] || fail 'forced reset did not uninstall formulae and casks'
grep -q '^cleanup -s$' "$BREW_LOG" || fail 'forced reset did not clean up Homebrew'

print 'dotfiles smoke tests passed'
