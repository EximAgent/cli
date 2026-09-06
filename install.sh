#!/usr/bin/env sh
# eximagent installer — pins v0.1.700.
set -eu
os=$(uname -s | tr A-Z a-z)
case "$os" in linux|darwin) ;; *) echo "eximagent: unsupported OS $os" >&2; exit 1 ;; esac
arch=$(uname -m)
case "$arch" in
  arm64|aarch64) arch=arm64 ;;
  x86_64|amd64) arch=amd64 ;;
  *) echo "eximagent: unsupported arch $arch" >&2; exit 1 ;;
esac
dir="${EXIMAGENT_INSTALL_DIR:-${HOME}/.eximagent/bin}"
mkdir -p "$dir"
bin="${dir}/eximagent-${os}-${arch}"
tmp="${bin}.download.$$"
asset="eximagent-${os}-${arch}"
url="https://github.com/EximAgent/cli/releases/download/v0.1.700/${asset}"
tag="v0.1.700"
echo "[eximagent] downloading v0.1.700 for ${os}-${arch}..." >&2
if ! curl -fsSL "$url" -o "$tmp"; then
  # only the newest release is kept, so a cached copy of this script outlives its pin
  url="https://github.com/EximAgent/cli/releases/latest/download/${asset}"
  tag=""
  echo "[eximagent] v0.1.700 is no longer published; falling back to the latest release" >&2
  curl -fsSL "$url" -o "$tmp"
fi
curl -fsSL "$url.sha256" -o "$tmp.sha256"
if command -v sha256sum >/dev/null 2>&1; then got=$(sha256sum "$tmp" | awk '{print $1}')
elif command -v shasum >/dev/null 2>&1; then got=$(shasum -a 256 "$tmp" | awk '{print $1}')
else got=$(openssl dgst -sha256 "$tmp" | awk '{print $NF}'); fi
if [ "$(cat "$tmp.sha256")" != "$got" ]; then
  echo "eximagent: checksum mismatch — refusing tampered download" >&2
  rm -f "$tmp" "$tmp.sha256"; exit 1
fi
rm -f "$tmp.sha256"
chmod +x "$tmp"
mv -f "$tmp" "$bin"
ln -sf "$bin" "${dir}/eximagent"
EXIMAGENT_INSTALL_DIR="$dir" EXIMAGENT_EXPECTED_TAG="$tag" EXIMAGENT_BACKEND="https://cli.eximagent.ai" "${dir}/eximagent" install "$@"
if command -v eximagent >/dev/null 2>&1; then
  echo "[eximagent] ready on PATH: $(command -v eximagent)" >&2
else
  echo "[eximagent] installed to ${dir}; open a new terminal," >&2
  echo "[eximagent] or run now: export PATH=\"${dir}:\$PATH\"" >&2
fi
