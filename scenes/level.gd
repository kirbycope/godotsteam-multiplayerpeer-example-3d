# level.gd
extends Node3D

const LOADING = preload("res://scenes/loading.tscn")
const RACETRACK = "res://scenes/race_track.tscn"
const TUSCANY = "res://scenes/tuscany.tscn"

var loading_instance: Node3D
var scene_to_load = RACETRACK

## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Defer the loading sequence to the next frame
	call_deferred("start_loading_sequence")


## Called during the processing step of the main loop.
func _process(_delta: float) -> void:

	# Check if the scene is done loading
	var status = ResourceLoader.load_threaded_get_status(scene_to_load)

	# Check the status
	match status:

		# The scene is loading
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			pass # Here you could update a progress bar if you want

		# The scene is loaded
		ResourceLoader.THREAD_LOAD_LOADED:

			# Get the loaded scene
			var loaded_scene = ResourceLoader.load_threaded_get(scene_to_load)

			# Instantiate the scene
			var scene_instance = loaded_scene.instantiate()

			# Add scene to the tree
			add_child(scene_instance)

			# Remove the loading scene
			if loading_instance:
				loading_instance.queue_free()

			# Stop processing
			set_process(false)

		ResourceLoader.THREAD_LOAD_FAILED:
			print("Failed to load scene")
			set_process(false)


## Start the loading sequence.
func start_loading_sequence() -> void:

	# Instantiate the loading scene
	loading_instance = LOADING.instantiate()

	# Add it as a child of the current node
	add_child(loading_instance)

	# Start loading the scene asynchronously
	ResourceLoader.load_threaded_request(scene_to_load)
