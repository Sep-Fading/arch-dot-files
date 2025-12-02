#!/usr/bin/env zsh
#
echo "I was started by process: $(ps -p $PPID -o comm=)"

# check if an image was provided
if [[ -z "$1" ]]; then
    echo "Error: Please provide a path to an image."
    echo "Usage: wall path/to/image.jpg"
    exit 1
fi

# 1. Set the wallpaper (swww)
swww img "$1" --transition-type grow --transition-pos 0.854,0.977 --transition-step 90

# 2. Generate Colors (Pywal)
# -n skips the wallpaper set (since swww does it)
# -q is quiet mode
wal -i "$1" -n -q

# 3. Update Firefox (Pywalfox)
pywalfox update

# 4. Reload Waybar to pick up colors
killall -SIGUSR2 waybar

# 5. Output success message
echo ":: Wallpaper and colors updated."

