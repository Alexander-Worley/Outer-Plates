@tool
extends "res://Scenes/Restaurant/PlainSurface/plainSurface.gd"

var isCooking: bool = false
@onready var cookingTimer = $CookingTimer

# Given a holdable, set it on the surface
# Return true if successful and false if not successful
func set_holdable_on_surface_wrapper(holdableInHand: Area2D):
	if !set_holdable_on_surface(holdableInHand): return false
	for holdable: Area2D in holdablesOnSurface:
		if holdable.is_in_group("ForStove"):
			holdable.doneness = holdableInHand.doneness
			begin_cooking()
	return true

# Begin cooking
func begin_cooking():
	if isCooking or holdablesOnSurface[0].isBurnt(): return
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
	holdablesOnSurface[0].increase_doneness()
	begin_cooking()

func _physics_process(_delta):
	# Update sprite in the editor interface
	if Engine.is_editor_hint(): _ready()
