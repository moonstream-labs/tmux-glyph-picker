#!/usr/bin/env bash

# pick_new.sh — Create a new window and open the glyph picker.
# Trigger: C-t (root table, no prefix)
#
# Flow:
#   1. Create a new window (preserving current working directory)
#   2. Capture the new window's ID
#   3. Open the glyph picker in a popup targeting that window
#   4. If the user cancels (ESC), the window keeps its default name

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

# Create the new window and capture its unique ID
# Using #{window_id} which returns something like @42
PANE_PATH="#{pane_current_path}"
NEW_WINDOW_ID="$(tmux new-window -c "$PANE_PATH" -P -F '#{window_id}')"

# Read popup styling options
POPUP_STYLE="$(get_tmux_option "$popup_style_option" "$popup_style_default")"
POPUP_BORDER_STYLE="$(get_tmux_option "$popup_border_style_option" "$popup_border_style_default")"
POPUP_BORDER_LINES="$(get_tmux_option "$popup_border_lines_option" "$popup_border_lines_default")"
POPUP_WIDTH="$(get_tmux_option "$popup_width_option" "$popup_width_default")"
POPUP_HEIGHT="$(get_tmux_option "$popup_height_option" "$popup_height_default")"

# Open the picker in a popup, targeting the new window
tmux display-popup -E -w "$POPUP_WIDTH" -h "$POPUP_HEIGHT" \
    -s "$POPUP_STYLE" -S "$POPUP_BORDER_STYLE" -b "$POPUP_BORDER_LINES" \
    -T " Window Glyph " \
    "$CURRENT_DIR/_picker.sh new $NEW_WINDOW_ID"
