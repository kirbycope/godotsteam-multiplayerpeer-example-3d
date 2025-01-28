extends Node


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Set the Steam App ID
	OS.set_environment("SteamAppID", str(480))

	# Set the Steam Game ID
	OS.set_environment("SteamGameID", str(480))

	# Initialize the Steamworks SDK
	Steam.steamInitEx()


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	# Retrieve callbacks from Steamworks
	Steam.run_callbacks()
