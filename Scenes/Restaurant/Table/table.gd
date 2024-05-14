extends Area2D

# Given a holdable, set it on the surface
func set_holdable_on_surface(holdableInHand: Area2D):
	add_child(holdableInHand)
	holdableInHand.name = "holdableOnSurface"
	$holdableOnSurface.position = Vector2(0,0)
