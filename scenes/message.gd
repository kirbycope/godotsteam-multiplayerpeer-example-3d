extends PanelContainer

class_name Message

const HIDE_DELAY: float = 30.0

@onready var content_label: Label = %ContentLabel
@onready var hide_timer: Timer = Timer.new()
@onready var sender_label: Label = %SenderLabel

func _ready():
	# Clear the contents
	sender_label.text = ""
	content_label.text = ""

	# Setup and start the timer
	add_child(hide_timer)
	hide_timer.one_shot = true
	hide_timer.timeout.connect(_on_hide_timer_timeout)

func set_message(sender: String, content: String) -> void:
	# Set the content
	sender_label.text = sender
	content_label.text = content

	# Start the hide timer when message is set
	hide_timer.start(HIDE_DELAY)
	show()  # Ensure message is visible when first set

func _on_hide_timer_timeout() -> void:
	# Hide the message
	hide()
