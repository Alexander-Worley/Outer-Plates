extends Area2D

# True after being cut at a cuttingBoard
var isCut: bool = false
# True if plated
var isOnPlate: bool = false
# True if eaten by a customer
var isEaten: bool = false

# Set the isCut bool of this holdable
func set_isCut(newCut: bool):
	isCut = newCut
	update_sprite()

# Set the isOnPlate bool of this holdable
func set_isOnPlate(newOnPlate: bool):
	isOnPlate = newOnPlate
	update_sprite()

# Set the isEaten bool of this holdable
func set_isEaten(newEaten: bool):
	isEaten = newEaten
	update_sprite()

# Change sprite
func update_sprite():
	var sprite = get_node("AnimatedSprite2D")
	if !isCut: sprite.set_frame(0) # If not cut
	elif !isOnPlate: sprite.set_frame(1) # If cut and not plated
	elif !isEaten: sprite.set_frame(2) # If plated and not eaten
	else: sprite.set_frame(3) # If eaten
