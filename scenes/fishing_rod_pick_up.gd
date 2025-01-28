extends Area3D


func _on_body_entered(body):

	# Uncomment the next line if using GodotSteam
	if !is_multiplayer_authority(): return

	if body is CharacterBody3D:

		# Get the player node that has authority
		var player_id = multiplayer.get_unique_id()
		var player = get_node("/root/Main/Level/MultiplayerSpawner").players[player_id]

		if player.is_holding_fishing_rod == false:

			player.is_holding_fishing_rod = true

			# Load the scene
			var scene = load("res://scenes/fishing_rod.tscn")

			# Instantiate the scene
			var instance = scene.instantiate()

			# Add the instance to the player scene
			player.get_node("Visuals/HeldItemMount").add_child(instance)
