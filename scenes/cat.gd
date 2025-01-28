extends CharacterBody3D


func _input(event: InputEvent) -> void:

	# Uncomment the next line if using GodotSteam
	if !is_multiplayer_authority(): return

	if event.is_action_pressed("use"):

		# Get the player node that has authority
		var player_id = multiplayer.get_unique_id()
		var player = get_node("/root/Main/Level/MultiplayerSpawner").players[player_id]

		# Check for raycast collision at different heights
		if player.raycast_lookat.is_colliding():
			player.is_animation_locked = true
			if player.raycast_high.is_colliding() and player.raycast_high.get_collider().is_in_group("Pet"):
				player.animation_player.play("Petting_Animal_High")
			elif player.raycast_middle.is_colliding() and player.raycast_middle.get_collider().is_in_group("Pet"):
				player.animation_player.play("Petting_Animal_Mid")
			elif player.raycast_low.is_colliding() and player.raycast_low.get_collider().is_in_group("Pet"):
				player.animation_player.play("Petting_Animal_Low")
		if player.animation_player.current_animation in ["Petting_Animal_High", "Petting_Animal_Mid", "Petting_Animal_Low"]:
			await get_tree().create_timer(2.0).timeout
			$AudioStreamPlayer3D.play()
			$AnimationPlayer.play("Arm_Cat|Caress_idle")


func _process(_delta: float) -> void:
	if $AnimationPlayer.current_animation == "":
		$AnimationPlayer.play("Arm_Cat|Idle_1")
