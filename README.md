![Thumbnail](/ci/thumbnail.png)

# godotsteam-multiplayerpeer-example-3d
An example for GodotSteam MultiplayerPeer.

## Download MultiplayerPeer
https://github.com/GodotSteam/MultiPlayerPeer/releases/latest
- macOS - macos-gXX-sXXX-gsXXX-mp.zip
    1. Unarchive the contents by double-clicking the downloaded file
    1. Unarchive the editor by double-clicking "macos_editor.zip"
    1. Drag the GodotSteam application into your Applications directory
    1. Launch the application
        - If you get an error when opening
            1. Click the Apple icon in the OS toolbar
            1. Select "System Settings"
            1. Select the "Privacy and Security" tab
            1. Scroll down to the "Secuirty" section
            1. Allow GodotSteam to be opened
        - If you get an error when trying to use the Steam API
            - Make sure you have a [steam_appid](steam_appid.txt) in the root of your project
                - `480` is a test app ID provided by Valve
        - If you get a bunch of file/folder permission prompts
            - Move sure the project directory is not in "Desktop", "Documents", or "Downloads"
                - `cd ~/GitHub` would be a good place
- Windows - win64-gXX-sXXX-gsXXX-mp.zip
    - Extract contents to `C:\Godot\godotsteam` as seen in [.vscode/settings.json](.vscode/settings.json)
    - The exe and dll need to be together for the Steam fatures to work in the editor
    - The templates will be used in exporting the builds

## Exporting to macOS Using Godot
1. [One-time Setup] Select "Project > Project Settings..."
1. [One-time Setup] Select "Rendering > Textures"
1. [One-time Setup] Enable "Import ETC2 ASTC" and restart
1. Select "Project" > "Export..."
1. Select "Add" > "macOS"
1. [One-time Setup] For "Options" > "Custom Template" > "Debug", select the template "macos.zip" from the unarchived folder
1. [One-time Setup] Repeat the process for the "Release" using the same template
1. [One-time Setup] Enter a value for "Options> Application > Bundle Identifier"
1. [One-time Setup] Under "Options > Entitlements" enable, "Allow Dyld Environment Variable" and "Disable Library Validation"
1. Select "Export Project..."
1. Create/Select a new folder called "export"
1. Unselect "Export With Debug" unless you want the console to open with your app
1. Change the type to "macOS Export(*.app)"
1. Select "Save"
1. Open the terminal in VS Code and run, [macos-add-steam.sh](ci/macos-add-steam.sh)
    - If you get a permission error
        - Run `sudo chmod 755 '{file_name}'`, replacing the `{file}` with the path to the ".sh" file

## Exporting to Windows Using Godot
1. Open GodotSteam
1. Select "Project" > "Export..."
1. Select "Windows Desktop"
    - Ignore the warning about the icon (for now)
1. [One-time Setup] For "Options" > "Custom Template" > "Debug", select the template from the unarchived folder
1. [One-time Setup] Repeat the process for the "Release" template
1. Select "Export Project..."
1. Create/Select a new folder called "export"
1. Unselect "Export With Debug" unless you want the console to open with your app
1. Select "Save"
    - Again, ignore rcedit warnings
1. If you get an error on Launch, it is becuase you need the [steam_api64.dll](export/steam_api64.dll) next to the `.exe`

### Fixing RCEDIT Warnings
1. Download [rcedit](https://github.com/electron/rcedit/releases)
1. Open GodotSteam
1. Select "Editor" > "Editor Settings..."
1. Select "Export" > "Windows"
1. Open the rcedit file

## Exporting to Windows Using Bash
1. Open the root folder using [VS Code](https://code.visualstudio.com/)
	- If you use GitHub Desktop, select the "Open in Visual Studio" button
1. Open the [integrated terminal](https://code.visualstudio.com/docs/editor/integrated-terminal) using the "Git Bash" profile
1. Run the following command, `bash ci/export-windows.sh`
