extends "res://Scenes/Restaurant/PlainSurface/plainSurface.gd"

enum tableState {
	AVAILABLE = 0,
	AWAITING_ORDER = 1,
	DINING = 2,
	CLEANUP = 3
}


@onready var tableSize = 1
@onready var needed_order_type = null # Will need to extend to an array when considering multiple tables
@onready var needed_order_phase = null
@onready var customer = null # The child customer, probably will need to be an array# Determines if this table is open for seating.
@onready var status = tableState.AVAILABLE
@onready var tableCode = null


func _ready():
	initialize()


func _process(delta):
	pass


func set_holdable_on_surface_wrapper(holdableInHand: Area2D):
	var result = set_holdable_on_surface(holdableInHand)
	return result


func get_status():
	return status

func set_order(food):
	pass


func is_served():
	""" 
	Returns a bool indicating whether table has been properly served. 
	If the table isn't awaiting an order, will return false by default.
	""" 
	if status != tableState.AWAITING_ORDER:
		return false
	if !holdablesOnSurface.is_empty():
		return false
	return true


func display_order(order):
	""" 
	Display a visual indicator of the order that is needed.
	"""
	# To be implemented, will be called by the Table Manager
	pass



