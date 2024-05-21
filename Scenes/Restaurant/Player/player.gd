extends CharacterBody2D

const SPEED: float = 120.0
var isHolding: bool = false
var holdablesInRange: Array[Area2D] = []
var surfacesInRange: Array[Area2D] = []
var holdableInHand: Area2D = null
var sprites = {
	1: ["P1_Back", "P1_Forward"],
	2: ["P2_Back", "P2_Forward"],
	3: ["P3_Back", "P3_Forward"],
	4: ["P4_Back", "P4_Forward"]
}
@export_range (1, 4) var playerNum: int = 1
@onready var interactRange: Area2D = $interactRange

func _ready():
	# TODO: The line below is temporary until proper animations are added
	get_node("AnimatedSprite2D").play(sprites[playerNum][1])

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
		holdableParent.remove_holdable_from_surface(holdable)
	if holdableInHand.is_in_group("ForStove"):
		holdableInHand.doneness = holdable.doneness
	holdable.queue_free()
	isHolding = true

# Places "holdableInHand" on a surface
func place_holdable():
	for surface: Area2D in surfacesInRange:
		if surface.set_holdable_on_surface_wrapper(holdableInHand):
			holdableInHand.queue_free()
			isHolding = false
			break

# Given whether the player is moving up, down, left, right, or diagonal,
# set the position of their pickup range
func set_interact_range_position(horizontal: float, vertical: float):
	const DISTANCE = Global.PIXEL_DIMENSION / 2.0
	horizontal *= DISTANCE
	vertical *= DISTANCE
	interactRange.position = Vector2(horizontal, vertical)

func animate_player(horizontal: float, vertical: float):
	if horizontal:
		# Flip Player sprite if facing opposite direction of the spirte's default direction
		get_node("AnimatedSprite2D").flip_h = true if horizontal == 1 else false
	if vertical:
		var direction = (vertical + 1) / 2
		get_node("AnimatedSprite2D").play(sprites[playerNum][direction])

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
	
	# Animates the Player
	animate_player(interactRange_x, interactRange_y)
	
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

# Handles inRange lists
func _on_interact_range_area_entered(area):
	check_interact_range(area, "append")
func _on_interact_range_area_exited(area):
	check_interact_range(area, "erase")
func check_interact_range(area, operation):
	if area.is_in_group("Holdables"):
		update_in_range(holdablesInRange, area, operation)
	elif area.is_in_group("Surfaces"):
		update_in_range(surfacesInRange, area, operation)
func update_in_range(listToUpdate, areaToUpdate, operation):
	if operation == "append":
		listToUpdate.append(areaToUpdate)
	elif operation == "erase":
		listToUpdate.erase(areaToUpdate)
