# TODO: Consolidate code that is duplicated among Surfaces such as Table, Stove, etc.
extends Area2D

const CENTER_OF_SURFACE = Vector2(0,-8)
var isHolding: bool = false
var holdableOnSurface: Area2D = null
var isCooking: bool = false
@onready var cookingTimer = $Timer

# Given a holdable, set it on the surface
func set_holdable_on_surface(holdableInHand: Area2D):
	if isHolding: return false
	holdableOnSurface = holdableInHand.duplicate()
	add_child(holdableOnSurface)
	holdableOnSurface.position = CENTER_OF_SURFACE
	holdableOnSurface.rotation = 0
	isHolding = true
	begin_cooking()
	return true

# Begin cooking
func begin_cooking():
	if isCooking: return
	print("Cooking started for: ", holdableOnSurface.name)
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
	print("Cooking stopped for: ", holdableOnSurface.name)

# Finished cooking timer
func _on_cookingTimer_timeout():
	stop_cooking()
	print("Cooking completed for: ", holdableOnSurface.name)
