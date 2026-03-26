#!/usr/bin/env bash

# Shared utility functions for tmux-glyph-picker.
# Sourced by all scripts — do NOT set -euo pipefail here.

# ── Guard against double-sourcing ──
[[ -n "${_GLYPH_PICKER_HELPERS_LOADED:-}" ]] && return
_GLYPH_PICKER_HELPERS_LOADED=1

# ── Read a tmux user option, returning a default if unset ──
get_tmux_option() {
    local option="$1"
    local default_value="$2"
    local option_value
    option_value="$(tmux show-option -gqv "$option")"
    if [[ -z "$option_value" ]]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

# ── Resolve the glyphs data file path ──
# Checks the tmux option first, falls back to the bundled glyphs.tsv.
get_glyphs_file() {
    local scripts_dir="$1"
    local custom
    custom="$(get_tmux_option "$glyphs_file_option" "")"
    if [[ -n "$custom" && -f "$custom" ]]; then
        echo "$custom"
    else
        echo "$scripts_dir/glyphs.tsv"
    fi
}

# ── Convert a hex codepoint string to its UTF-8 character ──
# Usage: codepoint_to_char "0xF489"
# Works with both 4-digit BMP and 5-digit supplementary plane codepoints.
codepoint_to_char() {
    local hex="$1"
    # Strip 0x prefix if present
    hex="${hex#0x}"
    hex="${hex#0X}"
    # Zero-pad to 8 digits for \U escape (printf %08s pads with spaces, not zeros)
    local padded
    padded="$(printf '%08X' "0x$hex")"
    printf "\\U$padded"
}
