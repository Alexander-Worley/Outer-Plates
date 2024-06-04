extends Node
var num_tables = 0

var tables = [] # We need an array of the tables, so we can inquire about the position of the table
@onready var available_table_codes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	num_tables = self.get_children().size()
	for i in range(num_tables):
		var table = self.get_child(i)
		table.set_code(i)
		tables.push_back(table)
		available_table_codes.push_back(i)
		print("Set code: ", i)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_table(code):
	return tables[code]


# Retrieve the code of an available table and removes it from
# available_table_codes array. Returns the code.
# If none are available, returns -1
# DOES NOT CHANGE THE AVAILABILITY STATUS OF THAT TABLE
func get_available_table_code():
	if available_table_codes.is_empty():
		return -1
	
	var code = available_table_codes[-1]
	available_table_codes.pop_back()
	return code


func push_new_table_code(code):
	available_table_codes.push_back(code)


