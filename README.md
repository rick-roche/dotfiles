# My dotfiles

Configuration files that I don't want to lose; currently not managed by any tool but are useful to me. I mainly use a Windows development machine with gitbash as my command line.

## Getting Started

These instructions will assist in making use of my configurations.

### Prerequisites

None yet. Hopefully these will be managed with a tool someday.

### Installing

Clone the repo

```
git clone https://github.com/rick-roche/dotfiles.git ~/.dotfiles
```

#### editorconfig
* `.editorconfig` - place this file in the root of your project directory to have consistent formatting

```sh
cp ~/.dotfiles/editorconfig/.editorconfig .
```

#### git
* `.gitconfig` - place this file in `~/.gitconfig` to replace your git settings. *Use your own name :)*

```sh
cp ~/.dotfiles/git/.gitconfig ~/.gitconfig
```

* `.gitignore` - place this file in the root of your project directory to ignore files I don't want in version control

```sh
cp ~/.dotfiles/git/.gitignore .
```

#### vscode
* `settings.json` - to use my user settings, specifically for windows place in `%APPDATA%\Code\User\settings.json`

## Acknowledgments

* [Your unofficial guide to dotfiles on GitHub](https://dotfiles.github.io)
* [Semantic Commit Messages](https://seesparkbox.com/foundry/semantic_commit_messages)