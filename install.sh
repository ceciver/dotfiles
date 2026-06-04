#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
  cat <<'USAGE'
Usage: ./install.sh [options]

Options:
  --dry-run              Print the changes without modifying files.
  --install-packages     Install packages from packages/apt.txt with apt-get.
  --no-bootstrap-tools   Do not clone Oh My Zsh, zsh-autosuggestions, or TPM.
  --repo URL             Git URL used when this script is run outside a checkout.
  -h, --help             Show this help.

Remote bootstrap example:
  DOTFILES_REPO=git@github.com:ceciver/dotfiles.git bash install.sh
USAGE
}

ORIGINAL_ARGS=("$@")
DRY_RUN=0
INSTALL_PACKAGES=0
BOOTSTRAP_TOOLS=1
DOTFILES_REPO="${DOTFILES_REPO:-}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

while (($#)); do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      ;;
    --install-packages)
      INSTALL_PACKAGES=1
      ;;
    --no-bootstrap-tools)
      BOOTSTRAP_TOOLS=0
      ;;
    --repo)
      shift
      if (($# == 0)); then
        echo "--repo needs a Git URL" >&2
        exit 2
      fi
      DOTFILES_REPO="$1"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

run() {
  if ((DRY_RUN)); then
    printf 'dry-run:'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" 2>/dev/null && pwd -P || pwd -P)"

if [[ ! -d "$SCRIPT_DIR/home" || ! -f "$SCRIPT_DIR/dotfiles.manifest" ]]; then
  if [[ -z "$DOTFILES_REPO" ]]; then
    cat >&2 <<'EOF'
This copy of install.sh is not inside a dotfiles checkout.
Set DOTFILES_REPO to your GitHub repository and run it again, for example:
  DOTFILES_REPO=git@github.com:ceciver/dotfiles.git bash install.sh
EOF
    exit 1
  fi

  if ((DRY_RUN)); then
    printf 'dry-run: would clone or update %s at %s\n' "$DOTFILES_REPO" "$DOTFILES_DIR"
    exit 0
  fi

  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    git -C "$DOTFILES_DIR" pull --ff-only
  elif [[ -e "$DOTFILES_DIR" ]]; then
    echo "$DOTFILES_DIR exists but is not a Git checkout" >&2
    exit 1
  else
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  fi

  exec "$DOTFILES_DIR/install.sh" "${ORIGINAL_ARGS[@]}"
fi

DOTFILES_ROOT="$SCRIPT_DIR"
MANIFEST_FILE="$DOTFILES_ROOT/dotfiles.manifest"
BACKUP_ROOT="${DOTFILES_BACKUP_DIR:-$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)}"
BACKUP_USED=0

trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

install_packages() {
  local package_file="$DOTFILES_ROOT/packages/apt.txt"

  [[ -f "$package_file" ]] || return 0
  if ! command -v apt-get >/dev/null 2>&1; then
    echo "Skipping packages: apt-get was not found."
    return 0
  fi
  if ! command -v sudo >/dev/null 2>&1; then
    echo "Skipping packages: sudo was not found."
    return 0
  fi

  mapfile -t packages < <(sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "$package_file")
  ((${#packages[@]})) || return 0

  run sudo apt-get update
  run sudo apt-get install -y "${packages[@]}"
}

clone_if_missing() {
  local repo="$1"
  local dest="$2"

  if [[ -d "$dest/.git" ]]; then
    printf 'already present: %s\n' "$dest"
    return 0
  fi
  if [[ -e "$dest" ]]; then
    printf 'skipping existing non-git path: %s\n' "$dest"
    return 0
  fi

  run mkdir -p "$(dirname "$dest")"
  run git clone --depth=1 "$repo" "$dest"
}

bootstrap_tools() {
  if ! command -v git >/dev/null 2>&1; then
    echo "Skipping tool bootstrap: git was not found."
    return 0
  fi

  clone_if_missing "https://github.com/ohmyzsh/ohmyzsh.git" "$HOME/.oh-my-zsh"
  clone_if_missing "https://github.com/zsh-users/zsh-autosuggestions.git" "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
  clone_if_missing "https://github.com/tmux-plugins/tpm.git" "$HOME/.tmux/plugins/tpm"

  local tpm_installer="$HOME/.tmux/plugins/tpm/bin/install_plugins"
  if [[ -x "$tpm_installer" ]]; then
    run "$tpm_installer"
  fi

  if command -v zsh >/dev/null 2>&1 && [[ "${SHELL:-}" != "$(command -v zsh)" ]]; then
    printf 'zsh is installed. To make it your login shell, run: chsh -s %s\n' "$(command -v zsh)"
  fi
}

link_path() {
  local rel="$1"
  local src="$DOTFILES_ROOT/home/$rel"
  local dst="$HOME/$rel"
  local backup="$BACKUP_ROOT/$rel"

  if [[ "$rel" = /* || "$rel" = *"/../"* || "$rel" = ../* || "$rel" = "." || -z "$rel" ]]; then
    echo "Refusing unsafe manifest path: $rel" >&2
    exit 1
  fi
  if [[ ! -e "$src" && ! -L "$src" ]]; then
    echo "Missing source for manifest path: $rel" >&2
    exit 1
  fi

  if [[ -L "$dst" && "$(readlink -f "$dst")" == "$(readlink -f "$src")" ]]; then
    printf 'linked: %s\n' "$rel"
    return 0
  fi

  if [[ -e "$dst" || -L "$dst" ]]; then
    run mkdir -p "$(dirname "$backup")"
    run mv "$dst" "$backup"
    BACKUP_USED=1
    printf 'backed up: %s -> %s\n' "$rel" "$backup"
  fi

  run mkdir -p "$(dirname "$dst")"
  run ln -s "$src" "$dst"
  printf 'installed: %s\n' "$rel"
}

link_manifest() {
  local rel

  while IFS= read -r rel || [[ -n "$rel" ]]; do
    rel="$(trim "${rel%%#*}")"
    [[ -n "$rel" ]] || continue
    link_path "$rel"
  done < "$MANIFEST_FILE"

  if ((BACKUP_USED)); then
    printf 'Backups saved in %s\n' "$BACKUP_ROOT"
  fi
}

if ((INSTALL_PACKAGES)); then
  install_packages
fi

link_manifest

if ((BOOTSTRAP_TOOLS)); then
  bootstrap_tools
fi

echo "Dotfiles install complete."
