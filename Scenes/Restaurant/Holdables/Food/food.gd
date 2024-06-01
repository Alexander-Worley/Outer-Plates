extends Area2D

# Call function "isReady()" to get a bool as to whether
# this specific food is "finished" based on MVP specs.

const MAX_COOKING_LEVEL: int = 2
# 0: Raw, 1: Cooked, 2: Burnt
var doneness: int = 0
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

# Returns whether the food can be cooked or not
func isCookable():
	return (isCut and !isOnPlate and doneness < 2)

# Increases doneness by 1
func increase_doneness():
	if doneness >= MAX_COOKING_LEVEL: return
	doneness += 1
	update_sprite()
	
func get_doneness():
	return doneness

# Change sprite
func update_sprite():
	var sprite = get_node("AnimatedSprite2D")
	if !isCut: sprite.set_frame(0) # If not cut
	elif !isOnPlate: sprite.set_frame(1 + doneness) # If cut and not plated
	elif !isEaten: sprite.set_frame(4 + doneness) # If plated and not eaten
	else: sprite.set_frame(7) # If eaten
