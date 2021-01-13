# My dotfiles

These are my dotfiles, targetting macOS. Copied and modified from https://github.com/webpro/dotfiles.

## NB! REPO HAS MOVED

My dotfiles have moved to https://gitlab.com/rick-roche/dotfiles; this repo has been archived.

## Getting Started

These instructions will assist in making use of my configurations.

### Prerequisites

On a sparkling fresh installation of macOS:

```sh
sudo softwareupdate -i -a
xcode-select --install
```

Install the dotfiles with either Git or curl:

### Installing

Clone the repo

```sh
git clone https://github.com/rick-roche/dotfiles.git ~/.dotfiles
source ~/.dotfiles/install.sh
```

## The `dotfiles` command

    $ dotfiles help
    Usage: dotfiles <command>
    
    Commands:
       clean            Clean up caches (brew, npm)
       dock             Apply macOS Dock settings
       edit             Open dotfiles in IDE (code) and Git GUI (stree)
       help             This help message
       macos            Apply macOS system defaults
       test             Run tests
       update           Update packages and pkg managers (OS, brew, npm)

## Customize/extend

You can put your custom settings, such as Git credentials in the `system/.custom` file which will be sourced from `.bash_profile` automatically. This file is in `.gitignore`.

Alternatively, you can have an additional, personal dotfiles repo at `~/.extra`.

* The runcom `.bash_profile` sources all `~/.extra/runcom/*.sh` files.
* The installer (`install.sh`) will run `~/.extra/install.sh`.

## Acknowledgments

* [Your unofficial guide to dotfiles on GitHub](https://dotfiles.github.io)
* [webpro's .files](https://github.com/webpro/dotfiles)
* [Semantic Commit Messages](https://seesparkbox.com/foundry/semantic_commit_messages)
