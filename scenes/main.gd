extends Node3D

var lobby_id = 0
var peer = SteamMultiplayerPeer.new()

@onready var spawner: MultiplayerSpawner = $MultiplayerSpawner


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Define custom spawner
	spawner.spawn_function = spawn_level

	# Connect "lobby_created" event to `_on_lobby_created()`
	peer.lobby_created.connect(_on_lobby_created)

	# Connect "lobby_match_list" event to `_on_lobby_match_list()`
	Steam.lobby_match_list.connect(_on_lobby_match_list)

	# Get a list of lobbies from Steam
	open_lobby_list()


## Called when the "Host" button is pressed.
func _on_host_pressed() -> void:

	# Create a public Steam lobby
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)

	# Set the current peer to handle the RPC system
	multiplayer.multiplayer_peer = peer

	# Hide the background image
	$CanvasLayer/Background.hide()
	
	# Hide the "Host" button
	$CanvasLayer/Host.hide()

	# Hide the "Refresh" button
	$CanvasLayer/Refresh.hide()

	# Hide the "Lobbies" list
	$CanvasLayer/LobbyContainer/Lobbies.hide()

	# Defer loading the level to the next frame
	call_deferred("spawn_level_deferred")


## Called when a lobby has been created.
func _on_lobby_created(connection, id):

	# Check for a connection
	if connection:

		# Set the current Lobby ID
		lobby_id = id

		# Set the lobby name
		Steam.setLobbyData(lobby_id, "name", str(Steam.getPersonaName()+"'s lobby"))

		# Set the lobby's joinable status
		Steam.setLobbyJoinable(lobby_id, true)


## Called when a list of lobbies is retrieved.
func _on_lobby_match_list(lobbies):

	# For each lobby in lobbies...
	for lobby in lobbies:

		# Get the Lobby Name
		var lobby_name = Steam.getLobbyData(lobby, "name")

		# Get the Number of Lobby Memmbers
		var members_count = Steam.getNumLobbyMembers(lobby)

		# Create a new button
		var button = Button.new()

		# Set the button text to something like, "{lobby_name} | {members_count}"
		button.set_text(str(lobby_name,"| Player Count: ", members_count))

		# Define the buttons size
		button.set_size(Vector2(100.0, 5.0))

		# Connect the "pressed" event to `join_lobby()`
		button.connect("pressed", Callable(self, "join_lobby").bind(lobby))

		# Add the button to the container
		$CanvasLayer/LobbyContainer/Lobbies.add_child(button)


## Called when the "Refresh" button is pressed.
func _on_refresh_pressed() -> void:

	# Check if there is already data
	if $CanvasLayer/LobbyContainer/Lobbies.get_child_count() > 0:

		# For each item found...
		for node in $CanvasLayer/LobbyContainer/Lobbies.get_children():

			# Remove the item
			node.queue_free()

	# Retrieve a new list
	open_lobby_list()


## Called when a player wants to join a lobby.
func join_lobby(id):

	# Connect the peer to the lobby
	peer.connect_lobby(id)

	# Set the peer to handle the RPC system
	multiplayer.multiplayer_peer = peer

	# Set the current Lobby ID
	lobby_id = id

	# Hide the background image
	$CanvasLayer/Background.hide()

	# Hide the "Host" button
	$CanvasLayer/Host.hide()

	# Hide the "Refresh" button
	$CanvasLayer/Refresh.hide()

	# Hide the "Lobbies" list
	$CanvasLayer/LobbyContainer/Lobbies.hide()


## Get a list of lobbies from Steam.
func open_lobby_list():

	# Set the physical distance for which we search lobbies
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)

	# Get a filtered list of relevant lobbies.
	Steam.requestLobbyList()


## Custom spawner.
func spawn_level(data):

	# Instantiate and then return the loaded scene
	return (load(data) as PackedScene).instantiate()


## Called when the level is ready to be spawned.
func spawn_level_deferred() -> void:

	# Spawn the new scene
	spawner.spawn("res://scenes/level.tscn")
