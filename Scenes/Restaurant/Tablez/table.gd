extends "res://Scenes/Restaurant/PlainSurface/plainSurface.gd"

enum tableState {
	AVAILABLE = 0,
	AWAITING_ORDER = 1,
	DINING = 2,
	CLEANUP = 3
}


@onready var tableSize = 1
@onready var needed_order_type = null # Will need to extend to an array when considering multiple tables
@onready var customer = null # The child customer, probably will need to be an array# Determines if this table is open for seating.
@onready var status = tableState.AVAILABLE
@onready var tableCode = null


func _ready():
	initialize()


func _process(delta):
	if get_status() == tableState.AVAILABLE:
		set_order("meat")
		print("Table with the following code wants plated cooked orange food: ", tableCode)
		set_status(tableState.AWAITING_ORDER)
	elif get_status() == tableState.AWAITING_ORDER and is_served():
		set_status(tableState.DINING)
		# Need to restrict the holdable from being picked up.
		# Probably can be done with a variable
	elif get_status() == tableState.DINING:
		set_status(tableState.CLEANUP)
		holdablesOnSurface[0].set_isEaten(true)
	elif get_status() == tableState.CLEANUP and !holdablesOnSurface[0]:
		set_status(tableState.AVAILABLE)
		set_order(null)
		var manager = get_parent()
		manager.push_new_table_code(tableCode)
		print("Table successfully cleaned!")
	
	


func set_holdable_on_surface_wrapper(holdableInHand: Area2D):
	var result = set_holdable_on_surface(holdableInHand)
	return result


func set_status(new_status):
	status = new_status


func get_status():
	return status

func set_code(code):
	tableCode = code

func get_code():
	return tableCode


func set_order(type):
	needed_order_type = type


func is_served():
	""" 
	Returns a bool indicating whether table has been properly served. 
	If the table isn't awaiting an order, will return false by default.
	""" 
	if status != tableState.AWAITING_ORDER:
		return false
	if !holdablesOnSurface[0]:
		return false
	if !holdablesOnSurface[0].isReady():
		return false
	if holdablesOnSurface[0].type != needed_order_type:
		return false
	return true


func display_order(order):
	""" 
	Display a visual indicator of the order that is needed.
	"""
	# To be implemented, will be called by the Table Manager
	pass



