#!/usr/bin/env bash
set -euo pipefail

# =========================
# yt-dlp Easy Downloader
# =========================

# ---------- Colors ----------
BRed="\e[1;31m"
BGreen="\e[1;32m"
BYellow="\e[1;33m"
BCyan="\e[1;36m"
NColor="\e[0m"

# ---------- App ----------
APP="yt-dlp"

# ---------- Dependency Check ----------
if ! command -v "$APP" >/dev/null 2>&1; then
    echo -e "${BRed}Error:${NColor} yt-dlp is not installed."
    echo "Install it from https://github.com/yt-dlp/yt-dlp"
    exit 1
fi

# ---------- Usage ----------
usage() {
    echo -e "${BYellow}Usage:${NColor} yde <URL>"
    exit 1
}

# ---------- Arguments ----------
[ $# -eq 1 ] || usage
URL="$1"

# ---------- yt-dlp Options ----------
OPT=(
    -o "%(title)s.%(ext)s"
    --restrict-filenames
    --windows-filenames
    --merge-output-format mp4
    --remux-video mp4
    --embed-thumbnail
    --concurrent-fragments 8
    --no-part
)

# ---------- Header ----------
echo -e "${BCyan}=== yt-dlp Easy Downloader ===${NColor}\n"

# ---------- Format Listing ----------
echo -e "${BYellow}Available formats:${NColor}\n"
"$APP" -F "$URL"

echo
read -rp "Enter format ID (press Enter for best): " ID || {
    echo -e "${BRed}Input cancelled.${NColor}"
    exit 1
}

echo
echo -e "${BYellow}Starting download...${NColor}\n"

# ---------- Download ----------
if [ -z "$ID" ]; then
    "$APP" "$URL" "${OPT[@]}"
else
    "$APP" -f "$ID" "$URL" "${OPT[@]}"
fi

# ---------- Result ----------
echo -e "\n${BGreen}Download completed successfully!${NColor}"

