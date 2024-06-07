extends Node2D

const MAX_PLAYERS: int = 4
var scene: Node2D

func _ready():
	# Load Scene
	scene = Global.currentScene
	add_child(scene)
	
	# Return if there are no players in this scene
	if !Global.isPlayersInScene: return
	
	# Add Pause Menu
	const pauseMenu = preload("res://Scenes/PauseMenu/pauseMenu.tscn")
	add_child(pauseMenu.instantiate())
	
	var numDevices: int = Input.get_connected_joypads().size()
	if numDevices >= MAX_PLAYERS: numDevices = MAX_PLAYERS - int(Global.isP1UsingKeyboard)
	# If this crashes, you are attempting to laod a scene with players
	# and forgot to attach the playerManager.gd script to the scene node!
	scene.numPlayers = numDevices + int(Global.isP1UsingKeyboard)
	
	# Remove Depricated Inputs
	for deviceNum in range(numDevices):
		scene.erase_input_map(deviceNum)
	
	# Add Current Players
	for deviceNum in range(numDevices):
		scene.add_player(deviceNum)
	
	# If there are no controller inputs but a single keyboard input,
	# create a keyboard player
	if !numDevices and Global.isP1UsingKeyboard: scene.add_player(0)
	
	# Establish callback when players connect or disconnect
	var _input: int = Input.connect("joy_connection_changed", Callable(self, "_on_joy_connection_changed"))

# When a player connects or disconnects
func _on_joy_connection_changed(deviceNum: int, isConnected: bool):
	var numDevices: int = Input.get_connected_joypads().size()
	if numDevices >= MAX_PLAYERS: numDevices = MAX_PLAYERS - int(Global.isP1UsingKeyboard)
	
	scene.numPlayers = numDevices + int(Global.isP1UsingKeyboard)
	
	if isConnected:
		# If there are already enough players, return
		if deviceNum >= numDevices: return
		scene.add_player(deviceNum)
	else:
		scene.remove_player(deviceNum)
