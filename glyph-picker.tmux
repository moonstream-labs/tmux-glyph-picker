#!/usr/bin/env bash

# tmux-glyph-picker — TPM entry point
# This file is executed by TPM on plugin load.
# It sources helpers, and registers key bindings for
# new-window-with-glyph and rename-window-with-glyph.
#
# NOTE: Do NOT use set -euo pipefail here. TPM expects
# the entry point to succeed even if individual commands
# have minor issues.

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"
source "$CURRENT_DIR/scripts/variables.sh"

# Read configurable key bindings
KEY_NEW="$(get_tmux_option "$key_new_option" "$key_new_default")"
KEY_RENAME="$(get_tmux_option "$key_rename_option" "$key_rename_default")"

# Register key bindings
# New window: root table (-n) since C-t arrives without prefix from Ghostty
tmux bind-key -n "$KEY_NEW" run-shell "$CURRENT_DIR/scripts/pick_new.sh"

# Rename window: prefix table (overrides default prefix + ,)
tmux bind-key "$KEY_RENAME" run-shell "$CURRENT_DIR/scripts/pick_rename.sh"
