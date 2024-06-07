extends Node2D

var scene: Node2D

func _ready():
	# Load Scene
	scene = Global.currentScene
	add_child(scene)
	
	var numDevices: int = Input.get_connected_joypads().size()
	scene.numPlayers = numDevices
	
	for deviceNum in range(numDevices):
		scene.erase_input_map(deviceNum)
	
	# Add Current Players
	for deviceNum in range(numDevices):
		scene.add_player(deviceNum)
	
	# Establish callback when players connect or disconnect
	var _input: int = Input.connect("joy_connection_changed", Callable(self, "_on_joy_connection_changed"))

# When a player connects or disconnects
func _on_joy_connection_changed(deviceNum: int, isConnected: bool):
	print(Input.get_connected_joypads().size())
	scene.numPlayers = Input.get_connected_joypads().size()
	if isConnected:
		scene.add_player(deviceNum)
	else:
		scene.remove_player(deviceNum)
