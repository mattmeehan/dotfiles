# dotfiles
My dotfiles based on [wmayner's](https://github.com/wmayner/dotfiles).

## Installation
Clone the repo and run the `install.sh` script.

```bash
cd ~
git clone https://github.com/mattmeehan/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## What's it do?
- Install `homebrew` as well as all of the formulae and casks in `./brew/`
- Install `pyenv` and set up a pyenv-managed global `python` installation
- Install `oh-my-zsh` with the `powerlevel10k` theme
- Install `vscode` extensions and symlink the settings file
- Symlink any *.symlink files in this repo to `$HOME` as dotfiles
- Symlink a `karabiner` configuration

For now, you may have to manually set the `iterm2` color scheme. In `iterm2` -> `cmd+i` (preferences) -> "Colors" -> "Colors presets".

## TODO
- Make vscode, karabiner, and other nested settings files programmatically symlink
- Update `unintall.sh` to remove _all_ dotfiles and settings files
- Automate `iterm` config