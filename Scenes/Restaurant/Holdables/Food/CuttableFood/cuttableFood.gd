extends "res://Scenes/Restaurant/Holdables/Food/food.gd"

# Returns whether this food is ready to be served or not
func isReady():
	if isCut:
		if isOnPlate:
			if doneness == 0: # This food should not be cooked
				if !isEaten:
					return true
	return false
