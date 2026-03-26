#!/usr/bin/env bash

# _picker.sh — Internal: fzf glyph picker.
# Called from pick_new.sh or pick_rename.sh inside a tmux display-popup.
#
# Usage: _picker.sh <mode> [window_id]
#   mode:      "new" or "rename"
#   window_id: target window (required for "new" mode, current window for "rename")

set -euo pipefail

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

MODE="${1:-rename}"
TARGET_WINDOW="${2:-}"

GLYPHS_FILE="$(get_glyphs_file "$CURRENT_DIR")"

if [[ ! -f "$GLYPHS_FILE" ]]; then
    echo "  Glyph data file not found: $GLYPHS_FILE"
    sleep 2
    exit 1
fi

FZF_COLOR_SCHEME="$(get_tmux_option "$fzf_colors_option" "$fzf_colors_default")"
FZF_COLORS="--color=$FZF_COLOR_SCHEME"
FZF_EXTRA_OPTS="$(get_tmux_option "$fzf_opts_option" "$fzf_opts_default")"

# ── Build fzf input ──
# Read the TSV and convert codepoints to rendered glyphs.
# fzf input format: <glyph_char>\t<label>\t[<section>]
# The glyph character is the actual rendered Nerd Font icon.

INPUT=""

while IFS=$'\t' read -r section label codepoint; do
    # Skip comments and empty lines
    [[ "$section" =~ ^#.*$ ]] && continue
    [[ -z "$section" ]] && continue

    glyph="$(codepoint_to_char "$codepoint")"
    INPUT+="${glyph}	${label}	[${section}]"$'\n'
done < "$GLYPHS_FILE"

# Remove trailing newline
INPUT="${INPUT%$'\n'}"

if [[ -z "$INPUT" ]]; then
    echo "  No glyphs found in data file."
    sleep 1
    exit 0
fi

# ── Run fzf ──

SELECTION="$(echo "$INPUT" | fzf \
    --ansi \
    --no-multi \
    --delimiter=$'\t' \
    --with-nth='1,2,3' \
    --header="  Select a glyph for window name (ESC to skip)" \
    --no-info \
    --reverse \
    --margin=1,2 \
    $FZF_COLORS \
    $FZF_EXTRA_OPTS \
)" || exit 0

# ── Extract the glyph character (first field) ──
GLYPH="$(echo "$SELECTION" | cut -f1)"

if [[ -z "$GLYPH" ]]; then
    exit 0
fi

# ── Rename the window ──
if [[ "$MODE" == "new" && -n "$TARGET_WINDOW" ]]; then
    tmux rename-window -t "$TARGET_WINDOW" "$GLYPH"
else
    # Rename current window
    tmux rename-window "$GLYPH"
fi
