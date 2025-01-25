#!/bin/bash

# Set variables
godot=$(grep -o '"godotTools.editorPath.godot4": *"[^"]*"' .vscode/settings.json | cut -d '"' -f 4)
preset="Windows Desktop"
project=$(basename "$(pwd)")
export_dir="$(pwd)/export"

# Check if the path ends with Godot.app and modify it accordingly
if [[ "$godot" == */Godot.app ]]; then
    godot="${godot}/Contents/MacOS/Godot"
fi

# Print the command before running it
echo "\"$godot\" --headless --export-release \"$preset\" \"$export_dir/${project}.exe\""

# Run Godot headless and export the project as a release HTML5 build
"$godot" --headless --export-release "$preset" "$export_dir/${project}.exe"
