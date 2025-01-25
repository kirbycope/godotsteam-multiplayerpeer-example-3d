extends Control

const MESSAGE_SCENE : PackedScene = preload("res://scenes/message.tscn")
var should_show_messages: bool = false

@onready var chat_display = $VBoxContainer/ChatDisplay/MessageContainer
@onready var input_field = $VBoxContainer/InputContainer/MessageInput
@onready var scroll_container = $VBoxContainer/ChatDisplay
@onready var send_button = $VBoxContainer/InputContainer/SendButton


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Connect mouse enter/exit signals for the scroll container
	scroll_container.mouse_entered.connect(_on_chat_display_mouse_entered)
	scroll_container.mouse_exited.connect(_on_chat_display_mouse_exited)


## Called when mouse enters the chat display area.
func _on_chat_display_mouse_entered() -> void:
	# Show all messages
	for message in chat_display.get_children():
		if message is Message:
			message.show()


## Called when mouse exits the chat display area.
func _on_chat_display_mouse_exited() -> void:
	# Hide messages that should be hidden (timer expired)
	for message in chat_display.get_children():
		if message is Message and message.hide_timer.is_stopped():
			message.hide()


## Called when the "Send" button is pressed.
func _on_send_button_pressed() -> void:

	# Send the messsage
	send_message()


## Called when the input is submitted ([Enter] _pressed_ while editing).
func _on_message_input_text_submitted(_text: String) -> void:

	# Send the messsage
	send_message()


## Send the message to the message container.
func send_message() -> void:

	# Trim the message
	var message_text = input_field.text.strip_edges()

	# Check if the message is empty
	if message_text.is_empty():
		return

	# Create a new Message
	var message = MESSAGE_SCENE.instantiate()

	# Add the message to the message container
	chat_display.add_child(message)

	# Set the message's content
	message.set_message(str(Steam.getPersonaName()), message_text)

	# Clear the input
	input_field.text = ""

	# Grab the focus for the input
	input_field.grab_focus()

	# Wait until the next frame to scroll
	await get_tree().process_frame

	# Sometimes need an extra frame
	await get_tree().process_frame

	# Make sure we scroll to the bottom
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value
