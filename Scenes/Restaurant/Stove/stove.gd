@tool
extends "res://Scenes/Restaurant/PlainSurface/plainSurface.gd"

const STOVE_TOP_SPRITES = {
	false: preload("res://Assets/Interactables/CookingStations/stove-square-off.png"),
	true: preload("res://Assets/Interactables/CookingStations/stove-square-on.png"),
}
var isCooking: bool = false
@onready var cookingTimer = $CookingTimer
@onready var cookingBar = $CookingBarControl
@onready var stoveTop = $Surface/StoveTop
@onready var smoke = $Surface/StoveTop/Pan/Smoke

@onready var donenessIndex = 0
#@onready var progressValue = 0

func _ready():
	initialize()
	stoveTop.texture = STOVE_TOP_SPRITES[isCooking]
	if isCooking:
		smoke.show()
		get_node("Surface/StoveTop/Pan/Smoke").play()
	else:
		smoke.hide()
		get_node("Surface/StoveTop/Pan/Smoke").stop()
		
func _process(delta):
	pass
	
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
	stoveTop.texture = STOVE_TOP_SPRITES[isCooking]
	smoke.show()

	cookingBar.startMoving()
	
	get_node("Surface/StoveTop/Pan/Smoke").play()
	# Cook asynchronously
	if not cookingTimer.is_connected("timeout", Callable(self, "_on_cookingTimer_timeout")):
		cookingTimer.connect("timeout", Callable(self, "_on_cookingTimer_timeout"))
	

# Stop cooking
func stop_cooking():
	if !isCooking: return
	cookingTimer.stop()
	isCooking = false
	stoveTop.texture = STOVE_TOP_SPRITES[isCooking]
	smoke.hide()
	get_node("Surface/StoveTop/Pan/Smoke").stop()
	
	#food is burnt
	if donenessIndex == 3:
		reset_progress_bar()

# Finished cooking timer
func _on_cookingTimer_timeout():
	stop_cooking()
	holdablesOnSurface[0].increase_doneness()
	donenessIndex += 1
	begin_cooking()
	
	#update CookingBar color
	cookingBar.set_modulate(cookingBar.colorArr[donenessIndex])

func reset_progress_bar():
	cookingBar.resetBar()
