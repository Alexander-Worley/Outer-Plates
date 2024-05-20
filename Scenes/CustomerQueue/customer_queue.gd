extends Area2D

const MAX_QUEUE_SIZE: int = 3
const NO_SPOT_FREE: int = -1
const INTER_CUST_SPACE: int = 6
const CUSTOMER_WIDTH: int = 32


var customer_queue: Array = []
var first_spot_free: int = 0
var customer_scene = preload("res://Scenes/Restaurant/Customer/customer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_open_spot():
	# You want a ternary, don't you? Do it then. You won't.
	if first_spot_free >= MAX_QUEUE_SIZE:
		return NO_SPOT_FREE
	return first_spot_free


func _on_customer_spawn_timer_timeout():
	var spot = get_open_spot()
	if spot == NO_SPOT_FREE:
		return
	var customer = customer_scene.instantiate()
	customer.position = Vector2(position.x + spot * (CUSTOMER_WIDTH + INTER_CUST_SPACE), position.y)
	add_child(customer)
	first_spot_free += 1
