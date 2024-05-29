extends Node
var available_nums = [14, 19, 21]


# Called when the node enters the scene tree for the first time.
func _ready():
	for N in self.get_children():
		#N.test_tag = "new tag"
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for table in self.get_children():
		if table.is_served():
			pass
			#print("Dish has been served")
			#print("This table has been served")
