extends "res://Scenes/Restaurant/PlainSurface/plainSurface.gd"

enum tableState {
	AVAILABLE = 0,
	AWAITING_ORDER = 1,
	DINING = 2,
	CLEANUP = 3
}

@onready var tableSize = 1
@onready var order = null  # Will need to extend to an array when considering multiple tables
@onready var customer = null # The child customer, probably will need to be an array
@onready var test_tag = "Original tag"
@onready var available = true # Determines if this table is open for seating.
@onready var needed_food = null
@onready var status = tableState.AVAILABLE




func _ready():
	initialize()


func set_holdable_on_surface_wrapper(holdableInHand: Area2D):
	var result = set_holdable_on_surface(holdableInHand)
	print(test_tag)
	return result


func get_status():
	print(status)


func is_served():
	# Checks if a table has been properly served. 
	# Right now, it will only check that a holdable is on it, will make more sophisticated
	return holdablesOnSurface.size() > 0 and holdablesOnSurface[0] != null


func display_order(order):
	""" 
	Display a visual indicator of the order that is needed.
	"""
	# To be implemented, will be called by the Table Manager
	pass



