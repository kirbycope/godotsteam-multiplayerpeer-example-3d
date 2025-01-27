extends Label3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !is_multiplayer_authority():
		return
	text = str(Steam.getPersonaName())
