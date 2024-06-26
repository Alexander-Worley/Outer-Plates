@tool
extends "res://Scenes/Restaurant/PlainSurface/plainSurface.gd"

enum tableState {
	AVAILABLE = 0,
	AWAITING_ORDER = 1,
	NEED_SERVING = 2,
	DINING = 3,
	CLEANUP = 4
}

var threshold = 0.5

@onready var tableSize = 1
@onready var needed_order_type = null # Will need to extend to an array when considering multiple tables
@onready var customer = null # The child customer, probably will need to be an array# Determines if this table is open for seating.
@onready var status = tableState.AVAILABLE
@onready var tableCode = null
@onready var isBar = true
@onready var chair = get_child(3)
var rng = RandomNumberGenerator.new()

@onready var hasPirate = false

@export_category("Developer Tools :0")
@export_enum("Left", "Middle", "Right") var barSide: int = 0

func _ready():
	initialize_wrapper()


func initialize_wrapper():
	$Surface.region_rect = Rect2(barSide*32, 24, 32, 40)
	initialize()
	
func _process(_delta):
	if get_status() == tableState.AVAILABLE or get_status() == tableState.AWAITING_ORDER:
		pass
	elif get_status() == tableState.NEED_SERVING and is_served():
		set_status(tableState.DINING)
	elif get_status() == tableState.DINING:
		holdablesOnSurface[0].set_isEaten(true)
		set_status(tableState.CLEANUP)
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
	if type != 'generate':
		needed_order_type = type
	
	var choiceNum = rng.randf_range(0, 1)

	if isBar:
		needed_order_type = 'red' if choiceNum < threshold else  'green'
		needed_order_type = 'red'
	else:
		needed_order_type = 'meat' if choiceNum < threshold else 'salad'


func is_served():
	""" 
	Returns a bool indicating whether table has been properly served. 
	If the table isn't awaiting an order, will return false by default.
	"""
	if hasPirate:
		return false
	if status != tableState.NEED_SERVING:
		return false
	if !holdablesOnSurface[0]:
		return false
	if !holdablesOnSurface[0].isReady():
		return false
	if holdablesOnSurface[0].type != needed_order_type:
		return false
	return true


func display_order():
	""" 
	Display a visual indicator of the order that is needed.
	"""
	# To be implemented, will be called by the Table Manager
	if customer == null:
		return
	print("display_order called from table code: ", tableCode)
	customer.showOrder()

func get_order():
	return needed_order_type 
