extends Node3D


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Get the body of water
	var area_node = self

	# Connect body entered function and bind the Area3D as a parameter
	area_node.body_entered.connect(_on_area_3d_body_entered.bind(area_node))

	# Connect body exited function
	area_node.body_exited.connect(_on_area_3d_body_exited)


## Called when a Node3D enters the Area3D.
func _on_area_3d_body_entered(body: Node3D, area_node: Node3D) -> void:

	# Check if the body is a Player
	if body.is_in_group("Player"):

		# Load the scene
		var scene = load("res://scenes/skateboard.tscn")

		# Instantiate the scene
		var instance = scene.instantiate()

		# Add the instance to the player scene
		body.get_node("Visuals/SkateboardMount").add_child(instance)

		# Get the string name of the player's current state
		var current_state = body.base_state.get_state_name(body.current_state)

		# Start "skateboarding"
		body.base_state.transition(current_state, "Skateboarding")


## Called when a Node3D exits the Area3D.
func _on_area_3d_body_exited(body: Node3D) -> void:

	# Check if the body is a Player
	if body.is_in_group("Player"):
		pass
