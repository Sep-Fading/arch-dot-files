#!/bin/zsh

CACHE_WALLPAPER="$HOME/.cache/wal/current_wallpaper.jpg"
CACHE_CONF="$HOME/.cache/wal/sddm-theme.conf"
THEME_DIR="/usr/share/sddm/themes/sddm-eucalyptus-drop/"
THEME_DIR_BG="/usr/share/sddm/themes/sddm-eucalyptus-drop/Backgrounds"

if [ ! -d "$THEME_DIR" ]; then
    echo "Error: Sugar Candy theme not found at $THEME_DIR"
    echo "Please install 'sddm-eucalyptus-drop'."
    exit 1
fi

echo "Syncing SDDM theme..."
echo "Source Wallpaper: $CACHE_WALLPAPER"

if [ ! -f "$CACHE_WALLPAPER" ]; then
    echo "Error: Wallpaper file not found at $CACHE_WALLPAPER"
    echo "Make sure your wal setup creates this file or run your wallpaper setter."
    exit 1
fi

if [ ! -f "$CACHE_CONF" ]; then
    echo "Error: Config file not found at $CACHE_CONF"
    echo "Run 'wal -R' to generate the sddm-theme.conf from your template."
    exit 1
fi

echo ">> Asking for sudo permission to write to /usr/share/sddm/..."

sudo cp "$CACHE_WALLPAPER" "$THEME_DIR/current_wallpaper.jpg"

sudo cp "$CACHE_CONF" "$THEME_DIR/theme.conf"

echo ">> Fixing permissions..."
sudo chmod 644 "$THEME_DIR/current_wallpaper.jpg"
sudo chmod 644 "$THEME_DIR/theme.conf"

echo "Done! Your login screen is synced."
