extends Control

const MESSAGE_SCENE : PackedScene = preload("res://scenes/message.tscn")
var should_show_messages: bool = false

@onready var chat_display = $VBoxContainer/ChatDisplay/MessageContainer
@onready var input_container = $VBoxContainer/InputContainer
@onready var input_field = $VBoxContainer/InputContainer/MessageInput
@onready var scroll_container = $VBoxContainer/ChatDisplay
@onready var send_button = $VBoxContainer/InputContainer/SendButton


## Called when there is an input event.
func _input(event: InputEvent) -> void:

	# [chat] button _released_
	if event.is_action_pressed("dpad_right") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:

		# Show the mouse
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

		# Show the chat input
		input_container.show()
		input_field.grab_focus()

	# [cancel] button _pressed_
	if event.is_action_pressed("ui_cancel"):

			# Hide the chat input
			input_container.hide()


func _ready() -> void:
	# Connect mouse enter/exit signals for the scroll container
	scroll_container.mouse_entered.connect(_on_chat_display_mouse_entered)
	scroll_container.mouse_exited.connect(_on_chat_display_mouse_exited)


func _on_chat_display_mouse_entered() -> void:
	# Show all messages
	for message in chat_display.get_children():
		if message is Message:
			message.show()


func _on_chat_display_mouse_exited() -> void:
	# Hide messages that should be hidden (timer expired)
	for message in chat_display.get_children():
		if message is Message and message.hide_timer.is_stopped():
			message.hide()


func _on_send_button_pressed() -> void:
	send_message()


func _on_message_input_text_submitted(_text: String) -> void:
	send_message()


func send_message() -> void:

	var message_text = input_field.text.strip_edges()

	if message_text.is_empty():
		return

	# Always create message locally first for immediate feedback
	create_message_for_all.rpc(str(Steam.getPersonaName()), message_text)

	# Clear input and refocus
	input_field.text = ""
	input_field.grab_focus()


@rpc("any_peer", "call_local")
func create_message_for_all(sender: String, message_text: String) -> void:

	var message = MESSAGE_SCENE.instantiate()
	chat_display.add_child(message)
	message.set_message(sender, message_text)

	# Ensure proper display update
	await get_tree().process_frame

	# Scroll to bottom
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value
