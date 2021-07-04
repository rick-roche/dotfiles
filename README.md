# My dotfiles

These are my dotfiles, targetting macOS. Copied and modified from https://github.com/webpro/dotfiles.

## Installation

On a sparkling fresh installation of macOS:

```bash
sudo softwareupdate -i -a
xcode-select --install
```

The Xcode Command Line Tools includes `git` and `make` (not available on stock macOS). Now there are two options:

1. Install this repo with `curl` available:

```bash
bash -c "`curl -fsSL https://raw.githubusercontent.com/rick-roche/dotfiles/main/remote-install.sh`"
```

This will clone or download, this repo to `~/.dotfiles` depending on the availability of `git`, `curl` or `wget`.

1. Alternatively, clone manually into the desired location:

```bash
git clone https://github.com/rick-roche/dotfiles.git ~/.dotfiles
```

Use the [Makefile](./Makefile) to install everything, and symlink [runcom](./runcom) and [config](./config) (using [stow](https://www.gnu.org/software/stow/)):

Update the [`Makefile`](./Makefile) to customise what tooling and packages you want to install by updating the line below

```bash
# Update this to reference the tooling you would like to include
packages: dev-tooling azure-tooling docker-tooling dotnet-tooling golang-tooling k8s-tooling node-tooling node-packages
```

You will also need to update the [.bash_profile](./runcom/.bash_profile) if you have not installed dotnet, golang, kubernetes or node tooling.
```bash
for DOTFILE in "$DOTFILES_DIR"/system/dev/.{dotnet,golang,gpg,kube,node}; do
```

```bash
cd ~/.dotfiles
make
```

The installation process in the Makefile is tested on every push and every week in this
[GitHub Action](https://github.com/webpro/dotfiles/actions).

## Post-Installation

- `dotfiles dock` (set [Dock items](./macos/dock.sh))
- `dotfiles macos` (set [macOS defaults](./macos/defaults.sh))

## The `dotfiles` command

```bash
$ dotfiles help
Usage: dotfiles <command>

Commands:
    clean            Clean up caches (brew, npm, gem, rvm)
    dock             Apply macOS Dock settings
    edit             Open dotfiles in IDE (code) and Git GUI (stree)
    help             This help message
    macos            Apply macOS system defaults
    test             Run tests
    update           Update packages and pkg managers (OS, brew, npm, gem)
```

## Customise

You can put your custom settings, such as Git credentials in the `system/.custom` file which will be sourced from
`.bash_profile` automatically. This file is in `.gitignore`.

Alternatively, you can have an additional, personal dotfiles repo at `~/.extra`. The runcom `.bash_profile` sources all
`~/.extra/runcom/*.sh` files.
## Acknowledgments

* [Your unofficial guide to dotfiles on GitHub](https://dotfiles.github.io)
* [webpro's .files](https://github.com/webpro/dotfiles)
* [Semantic Commit Messages](https://seesparkbox.com/foundry/semantic_commit_messages)
