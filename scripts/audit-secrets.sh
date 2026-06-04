#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"

if ! command -v rg >/dev/null 2>&1; then
  echo "ripgrep is required for this audit script." >&2
  exit 1
fi

pattern='(BEGIN (RSA|OPENSSH|EC|DSA|PGP) PRIVATE KEY|(^|[^[:alnum:]_])(token|password|passwd|secret|api[_-]?key|access[_-]?key|private[_-]?key|client[_-]?secret)[[:space:]_-]*(=|:))'

echo "Scanning tracked dotfile content for common secret markers..."
if rg -n --hidden --no-ignore-vcs -S "$pattern" "$ROOT/home"; then
  echo "Review the matches above before pushing." >&2
  exit 1
fi

echo "No common secret markers found."
