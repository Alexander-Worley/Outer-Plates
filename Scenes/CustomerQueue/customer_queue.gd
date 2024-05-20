extends Area2D

const CUSTOMER_QUEUE_SIZE = 3
var customer_queue = [false, false, false]
var first_spot_free = 0
var customer_scene = preload("res://Scenes/Restaurant/Customer/customer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	var customer = customer_scene.instance()
	
	# customer.position = Vector2() SET THE POSITION
	
	
func get_open_spot():
	# Yes, you can do a ternary.
	if first_spot_free >= CUSTOMER_QUEUE_SIZE:
		return -1
	return first_spot_free


