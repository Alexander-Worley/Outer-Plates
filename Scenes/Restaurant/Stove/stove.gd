extends "res://Scenes/Restaurant/PlainSurfaces/plainSurface.gd"

var isCooking: bool = false
@onready var cookingTimer = $CookingTimer

# Given a holdable, set it on the surface
func set_holdable_on_surface(holdableInHand: Area2D):
	if isHolding: return false
	holdableOnSurface = holdableInHand.duplicate()
	add_child(holdableOnSurface)
	holdableOnSurface.position = CENTER_OF_SURFACE
	holdableOnSurface.rotation = 0
	isHolding = true
	if holdableOnSurface.is_in_group("ForStove"):
		holdableOnSurface.doneness = holdableInHand.doneness
		begin_cooking()
	return true

# Begin cooking
func begin_cooking():
	if isCooking or holdableOnSurface.isBurnt(): return
	cookingTimer.start()
	isCooking = true
	# Cook asynchronously
	if not cookingTimer.is_connected("timeout", Callable(self, "_on_cookingTimer_timeout")):
		cookingTimer.connect("timeout", Callable(self, "_on_cookingTimer_timeout"))

# Stop cooking
func stop_cooking():
	if !isCooking: return
	cookingTimer.stop()
	isCooking = false

# Finished cooking timer
func _on_cookingTimer_timeout():
	stop_cooking()
	holdableOnSurface.increase_doneness()
	begin_cooking()
