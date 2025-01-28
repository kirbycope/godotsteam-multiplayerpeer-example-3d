extends PanelContainer

class_name Message

const HIDE_DELAY: float = 30.0

@export var message_id: int = 0

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

	# Set up network synchronization
	if multiplayer.has_multiplayer_peer():

		# Make this node network-aware
		set_multiplayer_authority(multiplayer.get_unique_id())


@rpc("any_peer", "reliable")
func sync_message(sender: String, content: String, msg_id: int) -> void:
	message_id = msg_id
	set_message(sender, content)


## Set the message content.
func set_message(sender: String, content: String) -> void:

	# If we're the authority, sync to other peers
	if is_multiplayer_authority():
		message_id = randi()  # Generate unique message ID
		rpc("sync_message", sender, content, message_id)

	# Set the content
	sender_label.text = sender
	content_label.text = content

	# Start the hide timer when message is set
	hide_timer.start(HIDE_DELAY)


@rpc("any_peer", "reliable")
func sync_hide() -> void:
	hide()


## Called when the hide timer times out
func _on_hide_timer_timeout() -> void:

	if is_multiplayer_authority():
		rpc("sync_hide")

	# Hide the message
	hide()
