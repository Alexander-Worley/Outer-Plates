extends Node2D

var restaurant: Node2D

func _ready():
	const restaurantScene = preload("res://DevScenes/Alexander/Alexander.tscn")
	restaurant = restaurantScene.instantiate()
	add_child(restaurant)
	var _input: int = Input.connect("joy_connection_changed", Callable(self, "_on_joy_connection_changed"))

func _on_joy_connection_changed(deviceNum: int, isConnected: bool):
	restaurant.numPlayers = Input.get_connected_joypads().size()
	if isConnected:
		restaurant.add_player(deviceNum)
	else:
		restaurant.remove_player(deviceNum)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
