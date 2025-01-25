#!/bin/bash

# Set variables
godot=$(grep -o '"godotTools.editorPath.godot4": *"[^"]*"' .vscode/settings.json | cut -d '"' -f 4)
preset="Windows Desktop"
project=$(basename "$(pwd)")
export_dir="$(pwd)/export"

# Print the command before running it
echo "\"$godot\" --headless --export-release \"$preset\" \"${export_dir}/${project}.exe\""

# Run Godot headless and export the project as a release windows build
"$godot" --headless --export-release "$preset" "$export_dir/${project}.exe"
