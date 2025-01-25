extends AudioStreamPlayer

func _ready():
	# Connect the "finished" signal to our custom function
	connect("finished", _on_audio_finished)


func _on_audio_finished():
	# Restart playback when the audio finishes
	play()
