#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
# The name for your tmux session
SESSION_NAME="talos-build"

# The command to run inside tmux (now without plain output)
BUILD_COMMAND="make kernel i915-sriov-dkms-pkg REGISTRY=ghcr.io/ojsef39 PLATFORM=linux/amd64 PUSH=true"

# --- Script Logic ---

echo "Updating the repository..."
git pull

echo "Starting the build process in a new tmux session named '$SESSION_NAME'..."
echo "The script will wait here until the build is finished."

# Create a new tmux session and run the build command.
# The script will block until the tmux session is closed (i.e., the build finishes).
tmux new-session -s "$SESSION_NAME" "$BUILD_COMMAND"

# --- Post-build ---

echo
echo "Build process finished."

# Check if fzf is installed
if ! command -v fzf &>/dev/null; then
  echo "fzf is not installed. Skipping log prompt."
  echo "To view logs manually, run: docker buildx history logs"
  exit 0
fi

# Ask the user if they want to see the logs using fzf
CHOICE=$(printf "No\nYes" | fzf --height 3 --prompt="View build logs? " --border=rounded --margin=1)

# Check the choice and show logs if requested
if [ "$CHOICE" = "Yes" ]; then
  echo "Fetching build logs..."
  docker buildx history logs
else
  echo "Not showing logs. Exiting."
fi
