extends "res://Scenes/Restaurant/PlainSurface/plainSurface.gd"

var full = 4
var count = 4

# Function override
func remove_holdable_from_surface(_holdable: Area2D):
	if count:
		print("removing holdable")
		print(count)
		count -= 1
		update_sprite()
		pass

# Function override
func set_holdable_on_surface_wrapper(holdableInHand: Area2D):
	print("put holdable")
	print(count)
	count +=1
	update_sprite()
	return true

func update_sprite():
	if count == 0: 
		$Surface/Stack.set_frame(4)
	elif count <= full/4: $Surface/Stack.set_frame(3)
	elif count <= full/2: $Surface/Stack.set_frame(2)
	elif count <= full*3/4: $Surface/Stack.set_frame(1)
	else: $Surface/Stack.set_frame(0)
