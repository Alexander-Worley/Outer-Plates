extends CharacterBody2D

const SPEED: float = 300.0
var holdableInHand: Area2D = null
var holdablesInRange: Array = []
var surfacesInRange: Array = []

# Picks up a holdable
func pickup_holdable(item: Area2D):
	holdableInHand = item.duplicate()
	item.queue_free()

# Places "holdableInHand" on a surface
func place_holdable():
	if surfacesInRange:
		var surface: Area2D = surfacesInRange.pick_random()
		surface.holdableOnSurface = holdableInHand.duplicate()
		holdableInHand = null

# Given whether the player is moving up, down, left, right, or diagonal,
# set the position of their pickup range
func set_interact_range_position(horizontal: float, vertical: float):
	horizontal *= Global.PIXEL_DIMENSION
	vertical *= Global.PIXEL_DIMENSION
	$interact_range.position = Vector2(horizontal, vertical)

func _physics_process(delta):
	# TODO: Replace "ui" variables with custom gameplay actions
	# Gets the input movements and handles the movement/deceleration.
	var horizontalMovement: float = Input.get_axis("ui_left", "ui_right")
	var verticalMovement: float = Input.get_axis("ui_up", "ui_down")
	if horizontalMovement:
		velocity.x = horizontalMovement * SPEED
		set_interact_range_position(horizontalMovement, verticalMovement)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if verticalMovement:
		velocity.y = verticalMovement * SPEED
		set_interact_range_position(horizontalMovement, verticalMovement)
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	move_and_slide()

func _input(event):
	# TODO: Replace "ui" variables with custom gameplay actions
	# TODO: Replace "ui_accept with another keystroke
	if event.is_action_pressed("ui_accept"):
		if holdableInHand: place_holdable()
		else: if holdablesInRange:
			# TODO: Replace "pick_random()" with static decisions.
				# Perhaps the item most inside of "pickup_range"?
			pickup_holdable(holdablesInRange.pick_random())

# TODO: Figure out a way to pass in functions as variables to decompose the
	# functions "_on_interact_range_area_entered" and "_on_interact_range_area_exited"
func _on_interact_range_area_entered(area):
	if area.is_in_group("Holdables"):
		holdablesInRange.append(area)
	else: if area.is_in_group("Surfaces"):
		surfacesInRange.append(area)
	print("Holdables: ", holdablesInRange) # Debug Code
	print("Surfaces: ", surfacesInRange) # Debug Code

# TODO: Figure out a way to pass in functions as variables to decompose the
	# functions "_on_interact_range_area_entered" and "_on_interact_range_area_exited"
func _on_interact_range_area_exited(area):
	if area.is_in_group("Holdables"):
		holdablesInRange.erase(area)
	else: if area.is_in_group("Surfaces"):
		surfacesInRange.erase(area)
	print("Holdables: ", holdablesInRange) # Debug Code
	print("Surfaces: ", surfacesInRange) # Debug Code
