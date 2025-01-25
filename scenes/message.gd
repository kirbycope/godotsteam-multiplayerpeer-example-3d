extends PanelContainer

class_name Message

const HIDE_DELAY: float = 30.0

@onready var content_label: Label = %ContentLabel
@onready var hide_timer: Timer = Timer.new()
@onready var sender_label: Label = %SenderLabel


## Called when the node enters the scene tree for the first time.
func _ready():

	# Clear the contents
	sender_label.text = ""
	content_label.text = ""

	# Setup and start the timer
	add_child(hide_timer)
	hide_timer.one_shot = true
	hide_timer.timeout.connect(_on_hide_timer_timeout)


## Set the message content.
func set_message(sender: String, content: String) -> void:

	# Set the content
	sender_label.text = sender
	content_label.text = content

	# Start the hide timer when message is set
	hide_timer.start(HIDE_DELAY)


## Called when the hide timer times out
func _on_hide_timer_timeout() -> void:

	# Hide the message
	hide()
