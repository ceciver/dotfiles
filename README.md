# Dotfiles

Personal dotfiles managed as symlinks from this repository into `$HOME`.

## What Is Tracked

The managed paths are listed in `dotfiles.manifest`. Files live under `home/`
using the same relative paths they have in `$HOME`.

This repo intentionally avoids browser profiles, cookies, caches, history,
telemetry tokens, private keys, and other machine-local state.

## Install On This Machine

```sh
cd ~/dotfiles
./install.sh
```

The installer backs up any existing destination files to
`~/.dotfiles-backup/<timestamp>/`, then symlinks each manifest path.

To install the optional Ubuntu/Debian package list first:

```sh
cd ~/dotfiles
./install.sh --install-packages
```

## Recover A Fresh Machine

After you push this repo to GitHub, replace the URL below with your repo:

```sh
git clone git@github.com:ceciver/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh --install-packages
```

For a one-command bootstrap using the raw script, set `DOTFILES_REPO`:

```sh
curl -fsSL https://raw.githubusercontent.com/ceciver/dotfiles/main/install.sh | DOTFILES_REPO=git@github.com:ceciver/dotfiles.git bash -s -- --install-packages
```

## Push To GitHub

Create an empty GitHub repository, then run:

```sh
cd ~/dotfiles
git remote add origin git@github.com:ceciver/dotfiles.git
git push -u origin main
```

## Before Pushing

Run the audit helper:

```sh
cd ~/dotfiles
./scripts/audit-secrets.sh
```

Then review:

```sh
git status
git diff --cached
```
