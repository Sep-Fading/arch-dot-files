#!/usr/bin/env zsh

if [[ -z "$1" ]]; then
    echo "Error: Please provide a path to an image."
    echo "Usage: wall path/to/image.jpg"
    exit 1
fi

swww img "$1" --transition-type grow --transition-pos 0.5,0.5 --transition-step 45 --transition-fps 240 --transition-duration 0.75

wal -i "$1" -n -q

FF_PROFILE="$HOME/.mozilla/firefox/s33zc28o.default-release"
WALLS_DIR="$FF_PROFILE/chrome/theme/color-schemes/walls"
mkdir -p "$WALLS_DIR"

rm -f "$WALLS_DIR"/*.jpg "$WALLS_DIR"/*.png "$WALLS_DIR"/*.jpeg
magick "$1" "$WALLS_DIR/current_wallpaper.jpg"
magick "$1" "$HOME/.cache/wal/current_wallpaper.jpg"

pywalfox update

killall -SIGUSR2 waybar
restart-walker
~/.local/bin/sddm-sync.sh

CURRENT_WALLPAPER_FILE="$HOME/.cache/current_wallpaper.txt"
echo "$1" > "$CURRENT_WALLPAPER_FILE"

echo ":: Wallpaper and colors updated."
echo ":: Rotation queue will update automatically on next cycle."
