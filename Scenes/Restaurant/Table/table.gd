extends Area2D

const CENTER_OF_SURFACE = Vector2(0,-8)
var isHolding: bool = false

# Given a holdable, set it on the surface
func set_holdable_on_surface(holdableInHand: Area2D):
	if isHolding: return false
	var holdableOnSurface: Area2D = holdableInHand.duplicate()
	holdableOnSurface.name = "holdableOnSurface"
	add_child(holdableOnSurface)
	$holdableOnSurface.position = CENTER_OF_SURFACE
	$holdableOnSurface.rotation = 0
	isHolding = true
	return true
