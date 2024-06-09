extends Node2D

const PLAYER_SCENE = preload("res://Scenes/Restaurant/Player/player.tscn")
var numPlayers: int
var players: Array = []
var inputMaps: Array = []

func add_player(playerNum: int, isIgnoreKeyboard: bool = false):
	# If player0 determine if it is a keyboard player
	if playerNum == 0 and !isIgnoreKeyboard and Global.isP1UsingKeyboard:
		# Check that there is not already a keyboard player
		var isFreshKeyboardPlayer: bool = true
		for player in players:
			if player.playerNum == -1:
				isFreshKeyboardPlayer = false
				break
		# If this is the first keyboard player, assign it player-1
		if isFreshKeyboardPlayer: playerNum = -1
	
	# If there are no controller inputs and this is a controller input, return
	if playerNum != -1 and !Input.get_connected_joypads().size(): return
	
	# Create a new player
	var player = PLAYER_SCENE.instantiate()
	players.append(player)
	
	# Set Controls
	build_input_map(playerNum)
	
	# If this is a keyboard player
	if playerNum == -1:
		assign_keyboard_controls(playerNum)
		player.isKeyboardControl = true
	# If this is a controller player
	else:
		assign_controller_controls(playerNum)
	
	# Give the player its unique atributes
	assign_player_properties(player, playerNum)
	
	# Create a parent node to hold players if needed
	var playerNode = find_child("Players", false, false)
	if !playerNode:
		playerNode = Node2D.new()
		playerNode.name = "Players"
		add_child(playerNode)
	playerNode.visible = true
	playerNode.z_index = 5 # Arbitrary value
	
	# Spawn the player
	playerNode.add_child(player)
	
	# If it was a keyboard player,
	# establish player0 controller player
	if playerNum == -1:
		add_player(0, true)

# Builds the input map for the inputted player
func build_input_map(playerNum: int):
	inputMaps.append({
		"moveRight{n}".format({"n":playerNum}): null,
		"moveLeft{n}".format({"n":playerNum}): null,
		"moveUp{n}".format({"n":playerNum}): null,
		"moveDown{n}".format({"n":playerNum}): null,
		"aimRight{n}".format({"n":playerNum}): null,
		"aimLeft{n}".format({"n":playerNum}): null,
		"aimUp{n}".format({"n":playerNum}): null,
		"aimDown{n}".format({"n":playerNum}): null,
		"pickup{n}".format({"n":playerNum}): null,
		"interact{n}".format({"n":playerNum}): null
		})

# Assigns Controls for Keyboard Input
func assign_keyboard_controls(playerNum: int):
	var moveRight: String = "moveRight{n}".format({"n":playerNum})
	var moveRightEvent = InputEventKey.new()
	var moveLeft: String = "moveLeft{n}".format({"n":playerNum})
	var moveLeftEvent = InputEventKey.new()
	var moveUp: String = "moveUp{n}".format({"n":playerNum})
	var moveUpEvent = InputEventKey.new()
	var moveDown: String = "moveDown{n}".format({"n":playerNum})
	var moveDownEvent = InputEventKey.new()
	var aimRight: String = "aimRight{n}".format({"n":playerNum})
	var aimRightEvent = InputEventKey.new()
	var aimLeft: String = "aimLeft{n}".format({"n":playerNum})
	var aimLeftEvent = InputEventKey.new()
	var aimUp: String = "aimUp{n}".format({"n":playerNum})
	var aimUpEvent = InputEventKey.new()
	var aimDown: String = "aimDown{n}".format({"n":playerNum})
	var aimDownEvent = InputEventKey.new()
	var pickup: String = "pickup{n}".format({"n":playerNum})
	var pickupEvent = InputEventKey.new()
	var interact: String = "interact{n}".format({"n":playerNum})
	var interactEvent = InputEventKey.new()
	
	# Keyboard - D
	InputMap.add_action(moveRight)
	moveRightEvent.device = playerNum
	moveRightEvent.keycode = KEY_D
	InputMap.action_add_event(moveRight, moveRightEvent)
	
	# Keyboard - A
	InputMap.add_action(moveLeft)
	moveLeftEvent.device = playerNum
	moveLeftEvent.keycode = KEY_A
	InputMap.action_add_event(moveLeft, moveLeftEvent)
	
	# Keyboard - W
	InputMap.add_action(moveUp)
	moveUpEvent.device = playerNum
	moveUpEvent.keycode = KEY_W
	InputMap.action_add_event(moveUp, moveUpEvent)
	
	# Keyboard - S
	InputMap.add_action(moveDown)
	moveDownEvent.device = playerNum
	moveDownEvent.keycode = KEY_S
	InputMap.action_add_event(moveDown, moveDownEvent)
	
	# Keyboard - Right Arrow
	InputMap.add_action(aimRight)
	aimRightEvent.device = playerNum
	aimRightEvent.keycode = KEY_RIGHT
	InputMap.action_add_event(aimRight, aimRightEvent)
	
	# Keyboard - Left Arrow
	InputMap.add_action(aimLeft)
	aimLeftEvent.device = playerNum
	aimLeftEvent.keycode = KEY_LEFT
	InputMap.action_add_event(aimLeft, aimLeftEvent)
	
	# Keyboard - Up Arrow
	InputMap.add_action(aimUp)
	aimUpEvent.device = playerNum
	aimUpEvent.keycode = KEY_UP
	InputMap.action_add_event(aimUp, aimUpEvent)
	
	# Keyboard - Down Arrow
	InputMap.add_action(aimDown)
	aimDownEvent.device = playerNum
	aimDownEvent.keycode = KEY_DOWN
	InputMap.action_add_event(aimDown, aimDownEvent)
	
	# Keyboard - E
	InputMap.add_action(pickup)
	pickupEvent.device = playerNum
	pickupEvent.keycode = KEY_E
	InputMap.action_add_event(pickup, pickupEvent)
	
	# Keyboard - Space
	pickupEvent = InputEventKey.new()
	pickupEvent.device = playerNum
	pickupEvent.keycode = KEY_SPACE
	InputMap.action_add_event(pickup, pickupEvent)
	
	# Keyboard - Q
	InputMap.add_action(interact)
	interactEvent.device = playerNum
	interactEvent.keycode = KEY_Q
	InputMap.action_add_event(interact, interactEvent)
	
	# Keyboard - Shift
	interactEvent = InputEventKey.new()
	interactEvent.device = playerNum
	interactEvent.keycode = KEY_SHIFT
	InputMap.action_add_event(interact, interactEvent)

# Assigns Controls for Controller Input
func assign_controller_controls(playerNum: int):
	assign_move_controls(playerNum)
	assign_aim_controls(playerNum)
	assign_pickup_controls(playerNum)
	assign_interact_controls(playerNum)

# Assigns Move Controls for the inputted player
func assign_move_controls(playerNum: int):
	var moveRight: String = "moveRight{n}".format({"n":playerNum})
	var moveRightEvent = InputEventJoypadMotion.new()
	var moveLeft: String = "moveLeft{n}".format({"n":playerNum})
	var moveLeftEvent = InputEventJoypadMotion.new()
	var moveUp: String = "moveUp{n}".format({"n":playerNum})
	var moveUpEvent = InputEventJoypadMotion.new()
	var moveDown: String = "moveDown{n}".format({"n":playerNum})
	var moveDownEvent = InputEventJoypadMotion.new()
	
	# Controller - Left Joystick - Right
	InputMap.add_action(moveRight)
	moveRightEvent.device = playerNum
	moveRightEvent.axis = JOY_AXIS_LEFT_X # horizontal axis
	moveRightEvent.axis_value =  1.0 # right
	InputMap.action_add_event(moveRight, moveRightEvent)
	
	# Controller - D-pad - Right
	moveRightEvent = InputEventJoypadButton.new()
	moveRightEvent.device = playerNum
	moveRightEvent.button_index = JOY_BUTTON_DPAD_RIGHT
	InputMap.action_add_event(moveRight, moveRightEvent)
	
	# Controller - Left Joystick - Left
	InputMap.add_action(moveLeft)
	moveLeftEvent.device = playerNum
	moveLeftEvent.axis = JOY_AXIS_LEFT_X # horizontal axis
	moveLeftEvent.axis_value = -1.0 # left
	InputMap.action_add_event(moveLeft, moveLeftEvent)
	
	# Controller - D-pad - Left
	moveLeftEvent = InputEventJoypadButton.new()
	moveLeftEvent.device = playerNum
	moveLeftEvent.button_index = JOY_BUTTON_DPAD_LEFT
	InputMap.action_add_event(moveLeft, moveLeftEvent)
	
	# Controller - Left Joystick - Up
	InputMap.add_action(moveUp)
	moveUpEvent.device = playerNum
	moveUpEvent.axis = JOY_AXIS_LEFT_Y # vertical axis
	moveUpEvent.axis_value = -1.0 # up
	InputMap.action_add_event(moveUp, moveUpEvent)
	
	# Controller - D-pad - Up
	moveUpEvent = InputEventJoypadButton.new()
	moveUpEvent.device = playerNum
	moveUpEvent.button_index = JOY_BUTTON_DPAD_UP
	InputMap.action_add_event(moveUp, moveUpEvent)
	
	# Controller - Left Joystick - Down
	InputMap.add_action(moveDown)
	moveDownEvent.device = playerNum
	moveDownEvent.axis = JOY_AXIS_LEFT_Y # vertical axis
	moveDownEvent.axis_value =  1.0 # down
	InputMap.action_add_event(moveDown, moveDownEvent)
	
	# Controller - D-pad - Down
	moveDownEvent = InputEventJoypadButton.new()
	moveDownEvent.device = playerNum
	moveDownEvent.button_index = JOY_BUTTON_DPAD_DOWN
	InputMap.action_add_event(moveDown, moveDownEvent)

# Assigns Aim Controls for the inputted player
func assign_aim_controls(playerNum: int):
	var aimRight: String = "aimRight{n}".format({"n":playerNum})
	var aimRightEvent = InputEventJoypadMotion.new()
	var aimLeft: String = "aimLeft{n}".format({"n":playerNum})
	var aimLeftEvent = InputEventJoypadMotion.new()
	var aimUp: String = "aimUp{n}".format({"n":playerNum})
	var aimUpEvent = InputEventJoypadMotion.new()
	var aimDown: String = "aimDown{n}".format({"n":playerNum})
	var aimDownEvent = InputEventJoypadMotion.new()
	
	# Controller - Right Joystick - Right
	InputMap.add_action(aimRight)
	aimRightEvent.device = playerNum
	aimRightEvent.axis = JOY_AXIS_RIGHT_X # horizontal axis
	aimRightEvent.axis_value =  1.0 # right
	InputMap.action_add_event(aimRight, aimRightEvent)
	
	# Controller - Right Joystick - Left
	InputMap.add_action(aimLeft)
	aimLeftEvent.device = playerNum
	aimLeftEvent.axis = JOY_AXIS_RIGHT_X # horizontal axis
	aimLeftEvent.axis_value = -1.0 # left
	InputMap.action_add_event(aimLeft, aimLeftEvent)
	
	# Controller - Right Joystick - Up
	InputMap.add_action(aimUp)
	aimUpEvent.device = playerNum
	aimUpEvent.axis = JOY_AXIS_RIGHT_Y # vertical axis
	aimUpEvent.axis_value = -1.0 # up
	InputMap.action_add_event(aimUp, aimUpEvent)
	
	# Controller - Right Joystick - Down
	InputMap.add_action(aimDown)
	aimDownEvent.device = playerNum
	aimDownEvent.axis = JOY_AXIS_RIGHT_Y # vertical axis
	aimDownEvent.axis_value =  1.0 # down
	InputMap.action_add_event(aimDown, aimDownEvent)

# Assigns Pickup Controls for the inputted player
func assign_pickup_controls(playerNum: int):
	var pickup: String = "pickup{n}".format({"n":playerNum})
	var pickupEvent = InputEventJoypadButton.new()
	
	# Controller - Sony Cross, Xbox A, Nintendo B
	InputMap.add_action(pickup)
	pickupEvent.device = playerNum
	pickupEvent.button_index = JOY_BUTTON_A
	InputMap.action_add_event(pickup, pickupEvent)
	
	# Controller - Sony Circle, Xbox B, Nintendo A
	pickupEvent = InputEventJoypadButton.new()
	pickupEvent.device = playerNum
	pickupEvent.button_index = JOY_BUTTON_B
	InputMap.action_add_event(pickup, pickupEvent)
	
	# Controller - Left Shoulder Button
	pickupEvent = InputEventJoypadButton.new()
	pickupEvent.device = playerNum
	pickupEvent.button_index = JOY_BUTTON_LEFT_SHOULDER
	InputMap.action_add_event(pickup, pickupEvent)
	
	# Controller - Left Trigger Button
	pickupEvent = InputEventJoypadMotion.new()
	pickupEvent.device = playerNum
	pickupEvent.axis = JOY_AXIS_TRIGGER_LEFT
	InputMap.action_add_event(pickup, pickupEvent)
	
	# Controller - Paddle 3 Button
	pickupEvent = InputEventJoypadButton.new()
	pickupEvent.device = playerNum
	pickupEvent.button_index = JOY_BUTTON_PADDLE3
	InputMap.action_add_event(pickup, pickupEvent)
	
	# Controller - Paddle 4 Button
	pickupEvent = InputEventJoypadButton.new()
	pickupEvent.device = playerNum
	pickupEvent.button_index = JOY_BUTTON_PADDLE4
	InputMap.action_add_event(pickup, pickupEvent)

# Assigns Pickup Controls for the inputted player
func assign_interact_controls(playerNum: int):
	var interact: String = "interact{n}".format({"n":playerNum})
	var interactEvent = InputEventJoypadButton.new()
	
	# Controller - Sony Square, Xbox X, Nintendo Y
	InputMap.add_action(interact)
	interactEvent.device = playerNum
	interactEvent.button_index = JOY_BUTTON_X
	InputMap.action_add_event(interact, interactEvent)
	
	# Controller - Sony Triangle, Xbox Y, Nintendo X
	interactEvent = InputEventJoypadButton.new()
	interactEvent.device = playerNum
	interactEvent.button_index = JOY_BUTTON_Y
	InputMap.action_add_event(interact, interactEvent)
	
	# Controller - Right Shoulder Button
	interactEvent = InputEventJoypadButton.new()
	interactEvent.device = playerNum
	interactEvent.button_index = JOY_BUTTON_RIGHT_SHOULDER
	InputMap.action_add_event(interact, interactEvent)
	
	# Controller - Right Trigger Button
	interactEvent = InputEventJoypadMotion.new()
	interactEvent.device = playerNum
	interactEvent.axis = JOY_AXIS_TRIGGER_RIGHT
	InputMap.action_add_event(interact, interactEvent)
	
	# Controller - Paddle 1 Button
	interactEvent = InputEventJoypadButton.new()
	interactEvent.device = playerNum
	interactEvent.button_index = JOY_BUTTON_PADDLE1
	InputMap.action_add_event(interact, interactEvent)
	
	# Controller - Paddle 2 Button
	interactEvent = InputEventJoypadButton.new()
	interactEvent.device = playerNum
	interactEvent.button_index = JOY_BUTTON_PADDLE2
	InputMap.action_add_event(interact, interactEvent)

# Assigns variables specific to this player
func assign_player_properties(player: CharacterBody2D, playerNum: int):
	assign_input_map(player, playerNum)
	set_player_starting_position(player, playerNum)
	player.name = "player{n}".format({"n":playerNum})
	player.playerNum = playerNum
	player.z_index = playerNum

# Assigns the appropriate input map to the player
func assign_input_map(player: CharacterBody2D, playerNum: int):
	var index = inputMaps.find({
		"moveRight{n}".format({"n":playerNum}): null,
		"moveLeft{n}".format({"n":playerNum}): null,
		"moveUp{n}".format({"n":playerNum}): null,
		"moveDown{n}".format({"n":playerNum}): null,
		"aimRight{n}".format({"n":playerNum}): null,
		"aimLeft{n}".format({"n":playerNum}): null,
		"aimUp{n}".format({"n":playerNum}): null,
		"aimDown{n}".format({"n":playerNum}): null,
		"pickup{n}".format({"n":playerNum}): null,
		"interact{n}".format({"n":playerNum}): null
		})
	player.inputMap = inputMaps[index]

# Sets the location where the player first spawns
func set_player_starting_position(player: CharacterBody2D, offset: int):
	const DEFAULT_STARTING_POSITION = Vector2(336, 304)
	var xOffset = Global.PIXEL_DIMENSION * offset
	var yOffset = Global.PIXEL_DIMENSION * offset
	var positionOffset = Vector2(xOffset, yOffset)
	player.position = DEFAULT_STARTING_POSITION + positionOffset

# Remove the player from the world
func remove_player(playerNum: int):
	var playerNode = find_child("Players", false, false)
	if !playerNode: return
	for player in players:
		# Find the player and erase them
		if player.playerNum == playerNum:
			erase_input_map(playerNum)
			playerNode.remove_child(player)
			players.erase(player)

# Erases the input map associated with this player
func erase_input_map(playerNum: int):
	# Define input map for this player
	var moveRight: String = "moveRight{n}".format({"n":playerNum})
	var moveLeft: String = "moveLeft{n}".format({"n":playerNum})
	var moveUp: String = "moveUp{n}".format({"n":playerNum})
	var moveDown: String = "moveDown{n}".format({"n":playerNum})
	var aimRight: String = "aimRight{n}".format({"n":playerNum})
	var aimLeft: String = "aimLeft{n}".format({"n":playerNum})
	var aimUp: String = "aimUp{n}".format({"n":playerNum})
	var aimDown: String = "aimDown{n}".format({"n":playerNum})
	var pickup: String = "pickup{n}".format({"n":playerNum})
	var interact: String = "interact{n}".format({"n":playerNum})
	# If that input map does not exist, return
	if !InputMap.has_action(moveRight): return
	# If that input map exists, erase it
	inputMaps.erase({
		moveRight: null,
		moveLeft: null,
		moveUp: null,
		moveDown: null,
		aimRight: null,
		aimLeft: null,
		aimUp: null,
		aimDown: null,
		pickup: null,
		interact: null
		})
	# Erase the associated InputMap for that player
	InputMap.erase_action(moveRight)
	InputMap.erase_action(moveLeft)
	InputMap.erase_action(moveUp)
	InputMap.erase_action(moveDown)
	InputMap.erase_action(aimRight)
	InputMap.erase_action(aimLeft)
	InputMap.erase_action(aimUp)
	InputMap.erase_action(aimDown)
	InputMap.erase_action(pickup)
	InputMap.erase_action(interact)

func _process(_delta):
	set_player_z_index()

# Update players' z indexes
func set_player_z_index():
	players.sort_custom(Callable(self, "sort_by_y_position"))
	for i in range(numPlayers):
		players[i].z_index = i * 2

# Given two players, sort them by their position.y values
func sort_by_y_position(a, b):
	if a.position.y < b.position.y:
		return true
	return false
