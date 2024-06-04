extends Node
var num_tables = 0
@onready var table_statuses = []
@onready var available_tables = []

enum tableState {
	AVAILABLE = 0,
	AWAITING_ORDER = 1,
	DINING = 2,
	CLEANUP = 3
}


# Called when the node enters the scene tree for the first time.
func _ready():
	num_tables = self.get_children().size()
	for i in range(num_tables):
		var table = self.get_child(i)
		table.tableCode = i
		table_statuses.append(tableState.AVAILABLE)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# This should only be call by the tables. They will provide their code to tell the parent
# of their current status
func set_table_status(code, status):
	table_statuses[code] = status
	if status == tableState.AVAILABLE:
		available_tables.push_back(code)


func get_table_status(code):
	return table_statuses[code]


# Retrieve the code of an available table
# If none are available, returns -1
# DOES NOT CHANGE THE AVAILABILITY STATUS OF THAT TABLE
func get_available_table():
	if available_tables.is_empty():
		return -1
	return available_tables[-1]
