extends Node
## A globally accessible manager for device-specific actions using SteamInput for any controller
## and standard Godot Input for the keyboard.
##
## All methods in this class that have a "device" parameter can accept -1
## which means the keyboard device.

# The actions defined in the Steam .vdf file are listed here
# with true or false indicating if input is analog or digital.
# False is digital (buttons), true is analog (joysticks, triggers, etc).
var action_names := {
	"Move": true,
	"Up": false,
	"Down": false,
	"Left": false,
	"Right": false,
	"Jump": false,
	"Pause": false,
}

# Track if we've gotten the handles yet.
var got_handles := false

# The action set handles and the current action set.
var game_action_set
var current_action_set

# Store the resulting handles for each action.
var actions = {}

# Store the state of each action and the frame it entered that state.
var action_states := {}


## Call this after calling `Steam.inputInit()` and `Steam.enableDeviceCallbacks()`
func init() -> void:
	Steam.input_device_connected.connect(_on_steam_input_device_connected)
	Steam.input_device_disconnected.connect(_on_steam_input_device_disconnected)

func _on_steam_input_device_connected(input_handle: int) -> void:
	if not got_handles:
		get_handles()
	Steam.activateActionSet(input_handle, current_action_set)
	print("Device connected %s" % str(input_handle))

func _on_steam_input_device_disconnected(input_handle: int) -> void:
	print("Device disconnected %s" % str(input_handle))

func get_handles() -> void:
	got_handles = true
	game_action_set = Steam.getActionSetHandle("GameControls")
	current_action_set = game_action_set
	get_action_handles(action_names)

func get_action_handles(action_names: Dictionary) -> void:
	for action in action_names.keys():
		# If true, analog
		if action_names[action]:
			actions[action] = Steam.getAnalogActionHandle(action)
		else:
			actions[action] = Steam.getDigitalActionHandle(action)

func get_controllers() -> Array[int]:
	var controllers: Array[int] = [-1]
	var steam_controllers = Steam.getConnectedControllers()
	if steam_controllers:
		controllers.append_array(steam_controllers)
	return controllers

func get_action_strength(device: int, action: StringName, exact_match: bool = false) -> float:
	if device >= 0:
		if not got_handles: return 0
		# getAnalogActionData returns only the x axis for single axis inputs such as triggers.
		var action_data = Steam.getAnalogActionData(device, actions[action])
		return action_data.x
	return Input.get_action_strength(action, exact_match)

func get_axis(device: int, negative_action: StringName, positive_action: StringName) -> float:
	if device >= 0:
		if not got_handles: return 0
		# getAnalogActionData returns only the x axis for single axis inputs such as triggers.
		var negative = Steam.getAnalogActionData(device, actions[negative_action])
		var positive = Steam.getAnalogActionData(device, actions[positive_action])
		return positive.x - negative.x
	return Input.get_axis(negative_action, positive_action)

## This is equivalent to Input.get_vector except it will only check the relevant device.
func get_vector(device: int, negative_x: StringName, positive_x: StringName, negative_y: StringName, positive_y: StringName, deadzone: float = -1.0) -> Vector2:
	if device >= 0:
		if not got_handles: return Vector2.ZERO
		var negative_x_val = Steam.getAnalogActionData(device, actions[negative_x])
		var positive_x_val = Steam.getAnalogActionData(device, actions[positive_x])
		var negative_y_val = Steam.getAnalogActionData(device, actions[negative_y])
		var positive_y_val = Steam.getAnalogActionData(device, actions[positive_y])
		# Steam's y axis is inverted compared to Godot
		return Vector2(positive_x_val - negative_x_val, -(positive_y_val - negative_y_val)).normalized()
	return Input.get_vector(negative_x, positive_x, negative_y, positive_y, deadzone)

func get_move_input(device: int) -> Vector2:
	if device >= 0:
		if not got_handles: return Vector2.ZERO
		# Get the analog stick movement
		var action_data = Steam.getAnalogActionData(device, actions["Move"])
		return Vector2(action_data.x, -action_data.y).normalized()
	return Vector2(Input.get_axis("Left", "Right"), Input.get_axis("Up", "Down")).normalized()

func get_action_state(device: int, action: String) -> Dictionary:
	# Get the current action, but create the defaults along the way if they don't exist.
	if not action_states.get(device):
		action_states[device] = {}
	if not action_states[device].get(action):
		action_states[device][action] = { "held": false, "press_frame": -1, "release_frame": -1 }
	return action_states[device][action]

func set_action_state(device: int, action: StringName, currently_held: bool, current_frame: int) -> Dictionary:
	# Get the state of the action last frame
	var previous_action_state = get_action_state(device, action)

	# If we're pressing the action now and we weren't pressing it last frame,
	# track that we pressed the action this frame.
	if currently_held and not previous_action_state.held:
		action_states[device][action].held = true
		action_states[device][action].press_frame = current_frame
	# If we're not pressing it this frame but we were pressing it last frame,
	# track that we released the action this frame.
	elif not currently_held and previous_action_state.held:
		action_states[device][action].held = false
		action_states[device][action].release_frame = current_frame

	# Return the current state of the action
	return action_states[device][action]

func is_action_pressed(device: int, action: StringName, exact_match: bool = false) -> bool:
	if device >= 0:
		if not got_handles: return false
		var current_frame = Engine.get_process_frames()
		var currently_held = Steam.getDigitalActionData(device, actions[action]).state
		set_action_state(device, action, currently_held, current_frame)
		return currently_held
	# If keyboard, use normal Godot input system.
	return Input.is_action_pressed(action, exact_match)

func is_action_just_pressed(device: int, action: StringName, exact_match: bool = false) -> bool:
	if device >= 0:
		if not got_handles: return false
		var current_frame = Engine.get_process_frames()
		var currently_held = Steam.getDigitalActionData(device, actions[action]).state
		var action_state = set_action_state(device, action, currently_held, current_frame)
		return currently_held and action_state.press_frame == current_frame
	# If keyboard, use normal Godot input system.
	return Input.is_action_just_pressed(action, exact_match)

func is_action_just_released(device: int, action: StringName, exact_match: bool = false) -> bool:
	if device >= 0:
		if not got_handles: return false
		var current_frame = Engine.get_process_frames()
		var currently_held = Steam.getDigitalActionData(device, actions[action]).state
		var action_state = set_action_state(device, action, currently_held, current_frame)
		return not currently_held and action_state.release_frame == current_frame
	# If keyboard, use normal Godot input system.
	return Input.is_action_just_released(action, exact_match)

### CHECK ALL CONTROLLER ACTIONS

func any_just_pressed(action: StringName) -> Dictionary:
	if not got_handles: return {"result": false, "controller": null }
	for controller in get_controllers():
		if is_action_just_pressed(controller, action):
			return {"result": true, "controller": controller}
	return { "result": false, "controller": null }

func any_just_released(action: StringName) -> Dictionary:
	if not got_handles: return {"result": false, "controller": null }
	for controller in get_controllers():
		if is_action_just_released(controller, action):
			return {"result": true, "controller": controller}
	return { "result": false, "controller": null }
	
func any_pressed(action: StringName) -> Dictionary:
	if not got_handles: return {"result": false, "controller": null }
	for controller in get_controllers():
		if is_action_pressed(controller, action):
			return {"result": true, "controller": controller}
	return { "result": false, "controller": null }
