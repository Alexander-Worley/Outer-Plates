@tool
extends "res://Scenes/Restaurant/PlainSurface/plainSurface.gd"

const STOVE_TOP_SPRITES = {
	false: preload("res://Assets/Interactables/CookingStations/stove-square-off.png"),
	true: preload("res://Assets/Interactables/CookingStations/stove-square-on.png"),
}
var isCooking: bool = false
var isOnSide: bool = false
@onready var cookingTimer = $CookingTimer
@onready var cookingBar = $CookingBarControl
@onready var stoveTop = $Surface/StoveTop
@onready var smoke = %Smoke
@onready var donenessIndex = 0

func _ready():
	initialize()
	if side in [4, 5, 6, 7]:
		isOnSide = true
		stoveTop.set_frame(0)
		var panPos = $Surface/StoveTop/Pan.position
		var newPos = panPos
		newPos.y += 9
		newPos.x += 3
		$Surface/StoveTop/Pan.position = newPos
	else:
		isOnSide = false
		stoveTop.set_frame(2)
	#stoveTop.texture = STOVE_TOP_SPRITES[isCooking]
	if isCooking:
		smoke.show()
		smoke.play()
	else:
		smoke.hide()
		smoke.stop()

# Given a holdable, set it on the surface
# Return true if successful and false if not successful
func set_holdable_on_surface_wrapper(holdableInHand: Area2D):
	if !set_holdable_on_surface(holdableInHand): return false
	for holdable: Area2D in holdablesOnSurface:
		if holdable.is_in_group("Cookable"):
			begin_cooking()
	return true

# Begin cooking
func begin_cooking():
	if isCooking or !holdablesOnSurface[0].isCookable(): return
	cookingTimer.start()
	isCooking = true
	if isOnSide: stoveTop.set_frame(1)
	else: stoveTop.set_frame(3)
	#stoveTop.texture = STOVE_TOP_SPRITES[isCooking]
	smoke.show()

	donenessIndex = holdablesOnSurface[0].get_doneness()
	cookingBar.startMoving(donenessIndex)
	
	smoke.play()
	# Cook asynchronously
	if not cookingTimer.is_connected("timeout", Callable(self, "_on_cookingTimer_timeout")):
		cookingTimer.connect("timeout", Callable(self, "_on_cookingTimer_timeout"))

# Stop cooking
func stop_cooking():
	if !isCooking: return
	cookingTimer.stop()
	isCooking = false
	if isOnSide: stoveTop.set_frame(0)
	else: stoveTop.set_frame(2)
	#stoveTop.texture = STOVE_TOP_SPRITES[isCooking]
	smoke.hide()
	smoke.stop()
	cookingBar.resetBar()

# Finished cooking timer
func _on_cookingTimer_timeout():
	stop_cooking()
	holdablesOnSurface[0].increase_doneness()
	donenessIndex = holdablesOnSurface[0].get_doneness()
	begin_cooking()
	
	#update CookingBar color
	cookingBar.set_modulate(cookingBar.COLORS[donenessIndex])
