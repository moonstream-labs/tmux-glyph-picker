#!/usr/bin/env bash

# ── Glyph data file ──
# Path to the shared TSV file containing glyph definitions.
# Users can override to point at a custom glyph set.
glyphs_file_option="@glyph-picker-glyphs-file"
# Default: bundled glyphs.tsv next to this script (resolved at runtime)

# ── Keybindings ──
key_new_option="@glyph-picker-key-new"
key_new_default="C-t"

key_rename_option="@glyph-picker-key-rename"
key_rename_default=","

# ── Popup styling ──
# Monochrome defaults matching session-factory's dark theme.
popup_style_option="@glyph-picker-popup-style"
popup_style_default="bg=#080909,fg=#dadada"

popup_border_style_option="@glyph-picker-popup-border-style"
popup_border_style_default="fg=#dadada"

popup_border_lines_option="@glyph-picker-popup-border-lines"
popup_border_lines_default="rounded"

# ── Popup dimensions ──
popup_width_option="@glyph-picker-popup-width"
popup_width_default="50%"

popup_height_option="@glyph-picker-popup-height"
popup_height_default="40%"

# ── fzf colors ──
# Monochrome palette matching session-factory.
fzf_colors_option="@glyph-picker-fzf-colors"
fzf_colors_default="bg:#080909,fg:#dadada,bg+:#080909,fg+:#dadada:bold,hl:#dadada:underline,hl+:#ffffff:bold:underline,pointer:#dadada,prompt:#808080,header:#595959,gutter:#080909,marker:#dadada,info:#595959,border:#dadada"

# ── Additional fzf options ──
fzf_opts_option="@glyph-picker-fzf-opts"
fzf_opts_default=""
