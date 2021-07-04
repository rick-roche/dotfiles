SHELL = /bin/bash
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
OS := $(shell bin/is-supported bin/is-macos macos linux)
PATH := $(DOTFILES_DIR)/bin:$(PATH)
NVM_DIR := $(HOME)/.nvm

export XDG_CONFIG_HOME = $(HOME)/.config
export STOW_DIR = $(DOTFILES_DIR)
export ACCEPT_EULA=Y

EXTENSION_DIR = $(DOTFILES_DIR)/extension
EXTENSION_REPO = https://dotfiles-exension/
EXTENSION_CA = ext.pem

.PHONY: test

all: $(OS)

# add extension if required
macos: sudo core-macos base packages link

core-macos: brew bash git

stow-macos: brew
	is-executable stow || brew install stow

sudo:
ifndef GITHUB_ACTION
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
endif

link: stow-$(OS)
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	mkdir -p $(XDG_CONFIG_HOME)
	stow -t $(HOME) runcom
	stow -t $(XDG_CONFIG_HOME) config

unlink: stow-$(OS)
	stow --delete -t $(HOME) runcom
	stow --delete -t $(XDG_CONFIG_HOME) config
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

bash: BASH=/usr/local/bin/bash
bash: SHELLS=/private/etc/shells
bash: brew
	brew install bash bash-completion@2 pcre
	sudo append $(BASH) $(SHELLS)
	chsh -s $(BASH);

git: brew
	brew install git git-extras

# Brewfile, Caskfile
base: base-packages base-apps

base-packages: brew
	brew bundle --file=$(DOTFILES_DIR)/install/brew/Brewfile

base-apps: brew
	brew bundle --file=$(DOTFILES_DIR)/install/brew/Caskfile || true
	xattr -d -r com.apple.quarantine ~/Library/QuickLook

# Fine tune these
packages: dev-tooling azure-tooling docker-tooling dotnet-tooling golang-tooling k8s-tooling node-tooling node-packages

dev-tooling: brew
	brew bundle --file=$(DOTFILES_DIR)/install/brew/Caskfile.dev || true

azure-tooling: brew
	brew bundle --file=$(DOTFILES_DIR)/install/brew/Brewfile.azure
	brew bundle --file=$(DOTFILES_DIR)/install/brew/Caskfile.azure || true

docker-tooling: brew
	brew bundle --file=$(DOTFILES_DIR)/install/brew/Caskfile.docker || true

dotnet-tooling:
	bash $(DOTFILES_DIR)/install/scripts/dotnet.sh

golang-tooling: brew
	brew bundle --file=$(DOTFILES_DIR)/install/brew/Brewfile.golang

k8s-tooling: brew docker-tooling
	mkdir -p $(HOME)/.kube/config/
	brew bundle --file=$(DOTFILES_DIR)/install/brew/Brewfile.k8s

node-tooling:
	if ! [ -d $(NVM_DIR)/.git ]; then git clone https://github.com/creationix/nvm.git $(NVM_DIR); fi
	. $(NVM_DIR)/nvm.sh; nvm install --lts

## Install global npm packages
node-packages: node-tooling
	. $(NVM_DIR)/nvm.sh; NODE_EXTRA_CA_CERTS=$(EXTENSION_DIR)/certs/$(EXTENSION_CA) npm install -g $(shell cat install/npmfile)
	. $(NVM_DIR)/nvm.sh; yarn config set cafile $(EXTENSION_DIR)/certs/$(EXTENSION_CA)

test:
	. $(NVM_DIR)/nvm.sh; bats test

# Fine tune these
extension: clone-extension install-extension-scripts

clone-extension: git
	rm -rf ${EXTENSION_DIR}
	git clone ${EXTENSION_REPO} ${EXTENSION_DIR}

install-extension-scripts: clone-extension
	@for f in $(shell ls ${EXTENSION_DIR}/install/scripts); do \
		bash ${EXTENSION_DIR}/install/scripts/$${f} ${EXTENSION_DIR}; \
	done

install-extension-brew: clone-extension
	@for f in $(shell ls ${EXTENSION_DIR}/install/brew); do \
		brew bundle --file=${EXTENSION_DIR}/install/brew/$${f}; \
	done
