# Dotfiles

My i3, Vim, Neovim, and tmux configuration is in this repository. The full
collection also contains shell and desktop settings. Each file under `home/`
has the same relative path it uses in `$HOME`.

## Set up another PC

On Ubuntu or Debian, install Git, then clone the public repository:

```sh
sudo apt-get install git
git clone https://github.com/ceciver/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh --only i3,vim,tmux --install-packages
```

`--only i3,vim,tmux` links the i3 config and its supporting desktop configs,
`~/.vimrc`, `~/.config/nvim`, and `~/.tmux.conf`. The package option installs the
optional Ubuntu/Debian list in `packages/apt.txt`. Omit it if the programs are
already installed or you use another package manager. The installer fetches
tmux's TPM plugin manager when tmux is selected. Neovim fetches its plugins
when first opened.

To preview the links without changing files:

```sh
./install.sh --only i3,vim,tmux --dry-run --no-bootstrap-tools
```

Existing destinations are moved into `~/.dotfiles-backup/<timestamp>/` before
the links are created. Running the installer again leaves correct links alone.
The full `./install.sh` installs every path in `dotfiles.manifest`, including
personal shell and desktop settings.

## Notes for other machines

- `~/.vimrc` contains the core Vim settings and mappings. The Neovim Lua config
  under `~/.config/nvim` has additional plugins and LSP features.
- i3 uses `HDMI-1` and `eDP-1` for the current laptop's workspace layout, with
  the primary display as a fallback. Its display script uses `xrandr --auto`
  when those connectors are absent. Adjust the monitor names or preferred
  resolutions in `home/.config/i3` for a different layout.
- The i3 browser shortcut starts `google-chrome-stable`; install it separately
  or change `$browser` in the i3 config.
- tmux uses the login shell set on the destination PC.

## Keep PCs in sync

Edit the linked files as usual. On the PC with changes, review and push them:

```sh
cd ~/dotfiles
./scripts/audit-secrets.sh
git status
git add home/.config/i3 home/.config/nvim home/.config/picom home/.config/polybar home/.vimrc home/.tmux.conf
git commit -m "Update desktop dotfiles"
git push
```

On another PC, run `git -C ~/dotfiles pull --ff-only`. The links pick up edits
automatically. Run the installer again if the manifest gained new paths.

Do not add private keys, credentials, browser profiles, caches, or histories to
the repository. The audit helper scans for common secret markers before a push.
