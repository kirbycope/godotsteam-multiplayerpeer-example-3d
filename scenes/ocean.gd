extends Node3D


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Get the body of water
	var area_node = $Area3D

	# Connect body entered function and bind the Area3D as a parameter
	area_node.body_entered.connect(_on_area_3d_body_entered.bind(area_node))

	# Connect body exited function
	area_node.body_exited.connect(_on_area_3d_body_exited)


func _on_area_3d_body_entered(body: Node3D, area_node: Node3D) -> void:
	if body is CharacterBody3D:
		body.is_swimming = true
		body.swimming_in = area_node


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		body.is_swimming = false
		body.swimming_in = null
