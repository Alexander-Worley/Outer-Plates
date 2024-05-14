extends Area2D

const CENTER_OF_SURFACE = Vector2(0,-8)

# Given a holdable, set it on the surface
func set_holdable_on_surface(holdableInHand: Area2D):
	add_child(holdableInHand)
	holdableInHand.name = "holdableOnSurface"
	$holdableOnSurface.position = CENTER_OF_SURFACE
