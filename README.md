# My dotfiles

These are my dotfiles, targetting macOS, with the ability to setup any of my machines. The goal is to provide a repeatable, modular approach to setting up and maintaining a macOS installation with [zsh](https://www.zsh.org/) as the primary shell. In the past these dotfiles used [bash](https://www.gnu.org/software/bash/) as the primary shell.

## Installation

On a sparkling fresh installation of macOS:

```bash
sudo softwareupdate -i -a
xcode-select --install
```

The Xcode Command Line Tools includes `git` and `make` (not available on stock macOS).

Next clone this repo into the desired location:

```bash
git clone https://github.com/rick-roche/dotfiles.git ~/.dotfiles
```

### Personality

* Setup your computer name using `~/.dotfiles/bin/dotfiles-setup-name <computer name>`. E.g. `~/.dotfiles/bin/dotfiles-setup-name orko`
* In `~/.dotfiles/settings/` create a personality file for the computer name using the convention `_<computer name>-setup.zsh`. E.g. `_orko-setup.zsh`
* Define the modules you want to install in the setup E.g.

```zsh
. $DOTFILES_HOME/settings/_base-setup.zsh

export DOTFILES_PERSONALITY=orko

DOTFILES_MODULES+=(
    aws
    azure
    dev
    docker
    dotnet
    golang
    java
    node
    media
)
```

### Setup

Execute `~/.dotfiles/bin/dotfiles-setup` to run the initial setup of your machine using the defined personality.

## The `dotfiles` command

The dotfiles setup adds the `dotfiles` command to your path. Usage for the command can be seen by simply running `dotfiles` in your terminal.

- `dotfiles` - Print usage information
- `dotfiles info` - Displays the setup of the machine on which this command is run
- `dotfiles setup` - Use this to setup a new machine
- `dotfiles update` - Use this to update all your modules

## Customise

TODO

## Acknowledgments

* [Your unofficial guide to dotfiles on GitHub](https://dotfiles.github.io)
* [Conventional Commit Messages](https://www.conventionalcommits.org/)
* [Graeme Lockleys' dotfiles](https://github.com/graeme-lockley/dotfiles)
* [Oh My Zsh](https://ohmyz.sh/)
* [webpro's .files](https://github.com/webpro/dotfiles)
