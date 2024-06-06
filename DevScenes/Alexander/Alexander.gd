extends Node2D

const PLAYER_SCENE = preload("res://Scenes/Restaurant/Player/player.tscn")
var numPlayers: int
var players: Array = []
var inputMaps: Array = []

func _ready():
	for playerNum in numPlayers:
		add_player(playerNum)

func add_player(playerNum: int):
	# Create a new player
	var player = PLAYER_SCENE.instantiate()
	players.append(player)
	
	# Set Controls
	build_input_map(playerNum)
	assign_move_controls(playerNum)
	assign_aim_controls(playerNum)
	assign_test_controls(playerNum) # TESTING
	
	# Give the player its unique atributes
	assign_player_properties(player, playerNum)
	
	# Spawn the player
	add_child(player)

func assign_test_controls(playerNum: int):
	var pickup: String = "pickup{n}".format({"n":playerNum})
	var pickupEvent = InputEventJoypadButton.new()
	
	InputMap.add_action(pickup)
	pickupEvent.device = playerNum
	pickupEvent.button_index = JOY_BUTTON_A
	print(pickup)
	InputMap.action_add_event(pickup, pickupEvent)
	print(pickup)

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
		"pickup{n}".format({"n":playerNum}): null
		})

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
	
	# Controller - Left Joystick - Left
	InputMap.add_action(moveLeft)
	moveLeftEvent.device = playerNum
	moveLeftEvent.axis = JOY_AXIS_LEFT_X # horizontal axis
	moveLeftEvent.axis_value = -1.0 # left
	InputMap.action_add_event(moveLeft, moveLeftEvent)
	
	# Controller - Left Joystick - Up
	InputMap.add_action(moveUp)
	moveUpEvent.device = playerNum
	moveUpEvent.axis = JOY_AXIS_LEFT_Y # vertical axis
	moveUpEvent.axis_value = -1.0 # up
	InputMap.action_add_event(moveUp, moveUpEvent)
	
	# Controller - Left Joystick - Down
	InputMap.add_action(moveDown)
	moveDownEvent.device = playerNum
	moveDownEvent.axis = JOY_AXIS_LEFT_Y # vertical axis
	moveDownEvent.axis_value =  1.0 # down
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

func assign_player_properties(player: CharacterBody2D, playerNum: int):
	set_player_starting_position(player, playerNum)
	player.playerNum = playerNum
	player.inputMap = inputMaps[playerNum]

func set_player_starting_position(player: CharacterBody2D, offset: int):
	const DEFAULT_STARTING_POSITION = Vector2(336, 304)
	var xOffset = Global.PIXEL_DIMENSION * offset
	var yOffset = Global.PIXEL_DIMENSION * offset
	var positionOffset = Vector2(xOffset, yOffset)
	player.position = DEFAULT_STARTING_POSITION + positionOffset

func remove_player(playerNum: int):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
