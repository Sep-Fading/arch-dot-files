#!/usr/bin/env zsh

# Update Walker Theme
# 1. Check if walker is running
if pgrep -x "walker" > /dev/null; then
    # 2. Restart the service to force reload config and CSS
    # If using systemd (common on Arch):
    #systemctl --user restart walker.service
    
    # OR if running standalone:
    pkill walker && walker --gapplication-service &
fi
