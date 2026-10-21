#!/usr/bin/env zsh
emulate -R zsh
setopt errexit nounset pipefail

repo=$(cd "$(dirname "$0")/.." && pwd -P)
tmp=$(mktemp -d "${TMPDIR:-/tmp}/zsh-local-test.XXXXXXXX")
trap 'rm -rf -- "$tmp"' EXIT

fail() {
    print -u2 "FAIL: $*"
    exit 1
}

home="$tmp/home"
dotfiles="$home/.dotfiles"
mkdir -p "$dotfiles/bin" "$dotfiles/settings" "$dotfiles/modules/zsh/runcom" "$home/.oh-my-zsh" "$tmp/bin"
cp "$repo/bin/"{_bootstrap.zsh,_functions.zsh} "$dotfiles/bin/"
cp "$repo/modules/zsh/runcom/.zshrc" "$dotfiles/modules/zsh/runcom/.zshrc"
cat >"$dotfiles/settings/_$(uname -n)-setup.zsh" <<'SETTINGS'
export DOTFILES_PERSONALITY=test
export DOTFILES_MODULES=()
SETTINGS
cat >"$home/.oh-my-zsh/oh-my-zsh.sh" <<'OHMYZSH'
# Test stub.
OHMYZSH
cat >"$tmp/bin/starship" <<'STARSHIP'
#!/bin/sh
printf ':'
STARSHIP
chmod +x "$tmp/bin/starship"
export PATH="$tmp/bin:$PATH" HOME="$home"

local_config="$dotfiles/.zshrc.local"
[[ ! -e "$local_config" ]] || fail 'fixture unexpectedly has a local config'

cat >"$local_config" <<'LOCAL'
alias machine_local_test='printf local-alias-loaded'
LOCAL

output=$(zsh -c 'source "$HOME/.dotfiles/modules/zsh/runcom/.zshrc"; alias machine_local_test' 2>&1 || true)
[[ "$output" == *"printf local-alias-loaded"* ]] || fail 'repo-local zsh config was not sourced'

git -C "$repo" check-ignore -q .zshrc.local || fail '.zshrc.local is not ignored by Git'

print 'zsh local config smoke test passed'
