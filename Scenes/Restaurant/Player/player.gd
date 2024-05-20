extends CharacterBody2D

const SPEED: float = 120.0
var isHolding: bool = false
var holdablesInRange: Array = []
var surfacesInRange: Array = []
var holdableInHand: Area2D = null
@onready var interactRange: Area2D = $interactRange

# Picks up a holdable
func pickup_holdable(holdable: Area2D):
	var holdableParent = holdable.get_parent()
	holdableInHand = holdable.duplicate()
	interactRange.add_child(holdableInHand)
	holdableInHand.position = Vector2(0,0)
	# Interupt cooking if needed
	if holdableParent.is_in_group("CookingStation"):
		holdableParent.stop_cooking()
	if holdableParent.is_in_group("Surfaces"):
		holdableParent.isHolding = false
	if holdableInHand.is_in_group("ForStove"):
		holdableInHand.doneness = holdable.doneness
	holdable.queue_free()
	isHolding = true

# Places "holdableInHand" on a surface
func place_holdable():
	for surface: Area2D in surfacesInRange:
		if surface.set_holdable_on_surface(holdableInHand):
			holdableInHand.queue_free()
			isHolding = false
			break

# Given whether the player is moving up, down, left, right, or diagonal,
# set the position of their pickup range
func set_interact_range_position(horizontal: float, vertical: float):
	horizontal *= Global.PIXEL_DIMENSION
	vertical *= Global.PIXEL_DIMENSION
	interactRange.position = Vector2(horizontal, vertical)
	get_node("AnimatedSprite2D").play("Walk_Groudon")

func tilt_weapon(horizontal: float, vertical: float):
	if !isHolding: return
	const DIAGONAL_ANGLE = 45
	var rotationDegrees = DIAGONAL_ANGLE * horizontal * vertical
	# if aiming up or down
	if !horizontal and vertical:
		rotationDegrees = -2 * DIAGONAL_ANGLE
	holdableInHand.rotation_degrees = rotationDegrees


func _physics_process(delta):
	# Fetch movement input
	var horizontalMovement: float = Input.get_axis("left", "right")
	var verticalMovement: float = Input.get_axis("up", "down")
	
	# Fetch aiming input
	var horizontalFacing: float = Input.get_axis("face_left", "face_right")
	var verticalFacing: float = Input.get_axis("face_up", "face_down")
	
	# Sanitize movement input
	if horizontalMovement > 0: horizontalMovement = 1
	elif horizontalMovement < 0: horizontalMovement = -1
	if verticalMovement > 0: verticalMovement = 1
	elif verticalMovement < 0: verticalMovement = -1
	
	# Sanitize aiming input
	if horizontalFacing > 0: horizontalFacing = 1
	elif horizontalFacing < 0: horizontalFacing = -1
	if verticalFacing > 0: verticalFacing = 1
	elif verticalFacing < 0: verticalFacing = -1
	
	# Move interactRange
	var interactRange_x: float = 0
	var interactRange_y: float = 0
	# If aiming input, use aiming input
	if horizontalFacing or verticalFacing:
		interactRange_x = horizontalFacing
		interactRange_y = verticalFacing
	# If no aiming input, use movement input
	elif horizontalMovement or verticalMovement:
		interactRange_x = horizontalMovement
		interactRange_y = verticalMovement
	# Move interactRange if any input
	if interactRange_x or interactRange_y:
		set_interact_range_position(interactRange_x, interactRange_y)
		# Rotate any Weapon being held
		if isHolding and holdableInHand.is_in_group("Weapons"):
			tilt_weapon(interactRange_x, interactRange_y)
	
	# Flip Player sprite if facing left
	var flipSprite: bool = true if (horizontalFacing == -1 or horizontalMovement == -1) else false
	get_node("AnimatedSprite2D").flip_h = flipSprite
	
	# Flip holdableInHand sprite if needed
	if isHolding and interactRange_x:
		holdableInHand.scale.x = interactRange_x
	elif isHolding and interactRange_y:
		holdableInHand.scale.x = -interactRange_y
	
	# Player movement
	if horizontalMovement:
		velocity.x = horizontalMovement * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if verticalMovement:
		velocity.y = verticalMovement * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		# if no movement at all
		if !horizontalMovement: get_node("AnimatedSprite2D").stop()
	
	move_and_slide()

func _input(event):
	if event.is_action_pressed("pickup"):
		if isHolding: place_holdable()
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

# TODO: Figure out a way to pass in functions as variables to decompose the
	# functions "_on_interact_range_area_entered" and "_on_interact_range_area_exited"
func _on_interact_range_area_exited(area):
	if area.is_in_group("Holdables"):
		holdablesInRange.erase(area)
	else: if area.is_in_group("Surfaces"):
		surfacesInRange.erase(area)
