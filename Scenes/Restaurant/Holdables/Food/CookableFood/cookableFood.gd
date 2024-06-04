extends "res://Scenes/Restaurant/Holdables/Food/food.gd"

var type = "meat"

# Returns whether this food is ready to be served or not
func isReady():
	if isCut:
		if isOnPlate:
			if doneness == 1: # This food should be cooked and not burnt
				if !isEaten:
					return true
	return false
