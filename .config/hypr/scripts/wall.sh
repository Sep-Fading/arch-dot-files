#!/usr/bin/env zsh

# 1. Check for image
if [[ -z "$1" ]]; then
    echo "Error: Please provide a path to an image."
    echo "Usage: wall path/to/image.jpg"
    exit 1
fi

# 2. Set Wallpaper (swww)
swww img "$1" --transition-type grow --transition-pos 0.854,0.977 --transition-step 45

# 3. Generate Colors (Pywal)
wal -i "$1" -n -q

# 4. Handle Firefox Wallpaper (FFUltima)
# Update this path to match your actual profile folder name
FF_PROFILE="$HOME/.mozilla/firefox/s33zc28o.default-release"
WALLS_DIR="$FF_PROFILE/chrome/theme/color-schemes/walls"

# Create directory if missing
mkdir -p "$WALLS_DIR"

# Convert/Copy the image to 'current_wallpaper.jpg'
# We use magick to ensure it's a valid JPG even if source is PNG/WEBP
magick "$1" "$WALLS_DIR/current_wallpaper.jpg"

# 5. Update Firefox Theme Colors
pywalfox update

# 6. Reload Waybar
killall -SIGUSR2 waybar

restart-walker

echo ":: Wallpaper and colors updated."
