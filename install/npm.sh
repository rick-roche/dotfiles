if ! is-executable brew -o ! is-executable git; then
  echo "Skipped: npm (missing: brew and/or git)"
  return
fi

brew install nvm

mkdir -p ~/.nvm

#export DOTFILES_BREW_PREFIX_NVM=`brew --prefix nvm`
#set-config "DOTFILES_BREW_PREFIX_NVM" "$DOTFILES_BREW_PREFIX_NVM" "$DOTFILES_CACHE"

#. "${DOTFILES_DIR}/system/.nvm"

export NVM_DIR="$HOME/.nvm"
. "$(brew --prefix nvm)/nvm.sh"

nvm install --lts
nvm use node
nvm run node --version

# Globally install with npm

packages=(
  electron
  nodemon
  npm
  nswag
)

npm install -g "${packages[@]}"
