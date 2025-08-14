#!/bin/bash
# A robust script to start a build inside a tmux session within a Nix environment.

set -e

SESSION_NAME="talos-build"

# The command that will be executed inside the tmux session.
# It's simple because the environment will already be correct.
# It ends with `exec bash` to leave a clean, usable shell after the build.
INNER_COMMAND="
set -e
echo '--- Updating repository... ---'
git pull
echo
echo '--- Starting build... ---'
make kernel i915-sriov-dkms-pkg REGISTRY=ghcr.io/ojsef39 PLATFORM=linux/amd64 PUSH=true
echo
echo '--- BUILD FINISHED ---'
echo 'This session will remain open. Press Ctrl+d or type exit to close.'
exec bash -l
"

# The main command that enters the Nix environment and then starts tmux.
# `tmux new-session ...` will create the session and run the INNER_COMMAND.
# If the session already exists, `tmux attach` will be run instead.
NIX_TMUX_COMMAND="
if tmux has-session -t ${SESSION_NAME} 2>/dev/null; then
  echo 'Build session already exists. Attaching...'
  tmux attach -t ${SESSION_NAME}
else
  echo 'Creating new build session and attaching...'
  tmux new-session -s ${SESSION_NAME} -n 'Build' \"${INNER_COMMAND}\"
fi
"

# --- Main Execution ---
# Enter the nix develop shell and execute our tmux startup command.
nix develop -c bash -c "${NIX_TMUX_COMMAND}"
