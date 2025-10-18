#!/bin/bash

# Aerospace workspace windows indicator
# This script updates workspace labels to show app icons for windows in each workspace

export RELPATH=$(dirname $0)/../..
source "$RELPATH/../icon_map.sh"

update_workspace_windows() {
  local workspace_id=$1

  # Get apps in this workspace
  apps=$(aerospace list-windows --workspace "$workspace_id" --format '%{app-name}' 2>/dev/null | sort -u)

  icon_strip=" "
	if [ "${apps}" != "" ]; then
		while read -r app; do
			icon_strip+=" $(
				__icon_map "$app"
				echo $icon_result
			)"
		done <<<"${apps}"
    sketchybar --set space.$workspace_id label="$icon_strip" label.drawing=on

		FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)

		if ! [ "$FOCUSED_WORKSPACE" = "$workspace_id" ];then 
			sketchybar --set space.$workspace_id background.drawing=on
		else 
			sketchybar --set space.$workspace_id background.drawing=off
		fi

  else
    # No apps in workspace, hide label
		icon_strip=" -"
    sketchybar --set space.$workspace_id label.drawing=off background.drawing=off
  fi
}

# Update all workspaces
update_all_workspace_windows() {
  workspaces=$(aerospace list-workspaces --all 2>/dev/null)
  for workspace in $workspaces; do
    update_workspace_windows "$workspace"
  done
}

# Main logic
if [ -n "$1" ]; then
  # Update specific workspace
  update_workspace_windows "$1"
else
  # Update all workspaces
  update_all_workspace_windows
fi