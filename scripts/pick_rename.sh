#!/usr/bin/env bash

# pick_rename.sh — Open the glyph picker to rename the current window.
# Trigger: prefix + , (overrides default tmux rename-window prompt)
#
# Flow:
#   1. Open the glyph picker in a popup
#   2. If the user selects a glyph, rename the current window
#   3. If the user cancels (ESC), no change is made

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

# Read popup styling options
POPUP_STYLE="$(get_tmux_option "$popup_style_option" "$popup_style_default")"
POPUP_BORDER_STYLE="$(get_tmux_option "$popup_border_style_option" "$popup_border_style_default")"
POPUP_BORDER_LINES="$(get_tmux_option "$popup_border_lines_option" "$popup_border_lines_default")"
POPUP_WIDTH="$(get_tmux_option "$popup_width_option" "$popup_width_default")"
POPUP_HEIGHT="$(get_tmux_option "$popup_height_option" "$popup_height_default")"

# Open the picker in a popup (rename mode = current window)
tmux display-popup -E -w "$POPUP_WIDTH" -h "$POPUP_HEIGHT" \
    -s "$POPUP_STYLE" -S "$POPUP_BORDER_STYLE" -b "$POPUP_BORDER_LINES" \
    -T " Window Glyph " \
    "$CURRENT_DIR/_picker.sh rename"
