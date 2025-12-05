#!/bin/bash

# --- Configuration ---
SOURCE_DIR="$HOME"
DEST_DIR="$HOME/dotfiles"

# List of folders in ~/.config/ to backup
CONFIG_FOLDERS=(
    "hypr"
    "waybar"
    "kitty"
    "nvim"
    "imv"
    "mpv"
    "wal"
    "fontconfig"
    "walker"
)

# List of individual files to backup
HOME_FILES=(
    ".zshrc"
    ".local/bin/screenshotter.sh"
)

# --- Setup ---
# Check if rsync is installed
if ! command -v rsync &> /dev/null; then
    echo "Error: rsync is not installed. Please run 'sudo pacman -S rsync'"
    exit 1
fi

echo ":: Starting Backup to $DEST_DIR..."
mkdir -p "$DEST_DIR/.config"

# --- 1. Backup Config Folders (Smart Sync) ---
for folder in "${CONFIG_FOLDERS[@]}"; do
    if [ -d "$SOURCE_DIR/.config/$folder" ]; then
        echo "   + Backing up .config/$folder (excluding .git)"
        # rsync flags:
        # -a: archive (keeps permissions/dates)
        # -v: verbose
        # --delete: remove files in backup that were deleted in source
        # --exclude: ignore git history
        rsync -av --delete --exclude '.git' "$SOURCE_DIR/.config/$folder" "$DEST_DIR/.config/"
    else
        echo "   ! Warning: ~/.config/$folder not found"
    fi
done

# --- 2. Backup Individual Files ---
for file in "${HOME_FILES[@]}"; do
    if [ -f "$SOURCE_DIR/$file" ]; then
        echo "   + Backing up $file"
        cp "$SOURCE_DIR/$file" "$DEST_DIR/"
    else
        echo "   ! Warning: ~/$file not found"
    fi
done

# --- 3. Backup Starship (Special Case) ---
if [ -f "$SOURCE_DIR/.config/starship.toml" ]; then
    echo "   + Backing up starship.toml"
    cp "$SOURCE_DIR/.config/starship.toml" "$DEST_DIR/.config/"
fi

# --- 4. Backup Firefox (Smart Find) ---
echo ":: Detecting Firefox Profile..."
FF_CHROME_PATH=$(find "$SOURCE_DIR/.mozilla/firefox" -maxdepth 2 -name "chrome" -type d 2>/dev/null | head -n 1)

if [ -n "$FF_CHROME_PATH" ]; then
    FF_PROFILE_DIR=$(dirname "$FF_CHROME_PATH")
    PROFILE_NAME=$(basename "$FF_PROFILE_DIR")
    
    echo "   + Found active profile: $PROFILE_NAME"
    mkdir -p "$DEST_DIR/firefox"
    
    # Copy chrome folder using rsync to exclude git (some themes are git repos)
    echo "   + Backing up userChrome.css and user.js"
    rsync -av --delete --exclude '.git' "$FF_PROFILE_DIR/chrome" "$DEST_DIR/firefox/"
    cp "$FF_PROFILE_DIR/user.js" "$DEST_DIR/firefox/" 2>/dev/null
else
    echo "   ! Error: Could not find a Firefox profile with a chrome folder."
fi

# --- 5. Dump Package List (Arch) ---
echo ":: Dumping package list..."
pacman -Qqe > "$DEST_DIR/pkglist.txt"

echo ":: Backup Complete!"
