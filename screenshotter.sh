#!/bin/zsh
# Ensure directory exists
mkdir -p ~/Pictures/Screenshots

# Select region (slurp) -> Capture (grim) -> Save to File (tee) -> Copy to Clipboard (wl-copy)
grim -g "$(slurp)" - | tee "$HOME/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S.png')" | wl-copy
