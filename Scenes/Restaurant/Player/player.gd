extends CharacterBody2D

const SPEED: float = 120.0
var isHolding: bool = false
var holdablesInRange: Array[Area2D] = []
var surfacesInRange: Array[Area2D] = []
var interactablesInRange: Array[Area2D] = []
var ammoDepotsInRange: Array[Area2D] = []
var holdableInHand: Area2D = null
# All of the player sprites divided up by player number.
# If the player is moving up, the first array is selected.
# If the player is moving down, the second array is selected.
	# For the two arrays above: the horizontal movement decides index.
	# If the player is not moving horizontally, the first index is selected.
	# If the player is moving horizontally, the second index is selected.
# If the player is only moving horizontally, the third value is selected.
# This is less than ideal, I know, but I'm forgoing redoing this due to time crunch.
var sprites = {
	1: [["P1_Back", "P1_B_Diagonal"], ["P1_Front", "P1_F_Diagonal"], "P1_Side"],
	2: [["P2_Back", "P2_B_Diagonal"], ["P2_Front", "P2_F_Diagonal"], "P2_Side"],
	3: [["P3_Back", "P3_B_Diagonal"], ["P3_Front", "P3_F_Diagonal"], "P3_Side"],
	4: [["P4_Back", "P4_B_Diagonal"], ["P4_Front", "P4_F_Diagonal"], "P4_Side"],
}
@export_range (1, 4) var playerNum: int = 1
@onready var interactRange: Area2D = $interactRange
@onready var holdablePosition: Area2D = $holdablePosition
@onready var playerSprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	# Set front sprite as starting sprite
	playerSprite.animation = sprites[playerNum][1][0]

# Picks up a holdable
func pickup_holdable(holdable: Area2D):
	var holdableParent = holdable.get_parent()
	holdableInHand = holdable.duplicate()
	
	holdablePosition.add_child(holdableInHand)
	set_holdable_position()
	# Interupt cooking if needed
	if holdableParent.is_in_group("CookingStation"):
		holdableParent.stop_cooking()
	if holdableParent.is_in_group("Surfaces"):
		holdableParent.remove_holdable_from_surface(holdable)
	# Transfer "doneness" if needed
	if holdableInHand.is_in_group("Cookable"):
		holdableInHand.doneness = holdable.doneness
	# Transfer "isCut" if needed
	if holdableInHand.is_in_group("Cuttable"):
		holdableInHand.isCut = holdable.isCut
	#copy ammo if needed
	# Commented out this as it causes crashes in Main Restaurant Scene
	# AW - May 25, 2024 - TODO: Fix this
	#if holdableInHand.is_in_group("Weapons"):
		#holdableInHand.ammo = holdable.ammo
		#var ammoCount = get_node("/root/Logan/Weapons/ammoCount")
		#ammoCount.text = str(holdableInHand.ammo)
	# Do not delete original holdable if it is coming from a PlateRack
	if !holdableParent.is_in_group("PlateRack"): holdable.queue_free()
	isHolding = true

# Set holdableInHand's position and z-index
func set_holdable_position():
	holdableInHand.position = Vector2(0,0)
	for i in 2:
		if playerSprite.animation == sprites[playerNum][0][i]:
			holdableInHand.z_index = 0
			return
	holdableInHand.z_index = 1

# Places "holdableInHand" on a surface
func place_holdable():
	for surface: Area2D in surfacesInRange:
		if surface.is_in_group("TrashCan"):
			holdableInHand.queue_free()
			isHolding = false
			break
		elif surface.set_holdable_on_surface_wrapper(holdableInHand):
			holdableInHand.queue_free()
			isHolding = false
			break

# Given whether the player is moving up, down, left, right, or diagonal,
# set the position of their pickup range and any holdables in their hand
func set_interact_range_position(horizontal: float, vertical: float):
	horizontal *= Global.PIXEL_DIMENSION
	vertical *= Global.PIXEL_DIMENSION
	interactRange.position = Vector2(horizontal, vertical)
	horizontal /= 4
	vertical /= 4
	holdablePosition.position = Vector2(horizontal, vertical)

# Animates the player
func animate_player(horizontal: float, vertical: float):
	if horizontal:
		# Flip Player sprite if facing opposite direction of the spirte's default direction
		playerSprite.flip_h = true if horizontal == 1 else false
		if !vertical:
			# If moving sideways, set Side Sprite
			playerSprite.play(sprites[playerNum][2])
	if vertical:
		var verticalDirection = (vertical + 1) / 2 # 0 if up, 1 if down
		var horizontalDirection = abs(horizontal) # 0 if only vertical, 1 if horizontal
		playerSprite.play(sprites[playerNum][verticalDirection][horizontalDirection])
		# Move holdableInHand sprite above or below the player as needed
		if isHolding: holdableInHand.z_index = 1 if verticalDirection else 0

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
		if !horizontalMovement: playerSprite.stop()
	
	move_and_slide()

func _input(event):
	if event.is_action_pressed("pickup"):
		if isHolding: place_holdable()
		else: if holdablesInRange:
			# TODO: Replace "pick_random()" with static decisions.
				# Perhaps the item most inside of "pickup_range"?
			pickup_holdable(holdablesInRange.pick_random())
	if event.is_action_pressed("interact"):
		for interactable in interactablesInRange:
			if !isHolding and interactable.begin_interaction(): break
		if isHolding && holdableInHand.is_in_group("Weapons"):
			weapon_logic()

func weapon_logic():
	if not ammoDepotsInRange:holdableInHand.shoot()
	elif ammoDepotsInRange[0].ammoCount > 0:
		var ammoNeeded
		if ammoDepotsInRange[0].ammoCount < holdableInHand.maxAmmo:
			ammoNeeded = ammoDepotsInRange[0].ammoCount
		else: 
			ammoNeeded = holdableInHand.maxAmmo - holdableInHand.ammo
		holdableInHand.ammo += ammoNeeded
		ammoDepotsInRange[0].ammoCount -= ammoNeeded
		holdableInHand.updateAmmoCounter()

# Handles inRange lists
func _on_interact_range_area_entered(area):
	check_interact_range(area, "append")
func _on_interact_range_area_exited(area):
	check_interact_range(area, "erase")
func check_interact_range(area, operation):
	if area.is_in_group("Holdables"):
		update_in_range(holdablesInRange, area, operation)
	if area.is_in_group("Surfaces"):
		update_in_range(surfacesInRange, area, operation)
	if area.is_in_group("Interactable"):
		update_in_range(interactablesInRange, area, operation)
	if area.is_in_group("ammoDepots"):
		update_in_range(ammoDepotsInRange, area, operation)
func update_in_range(listToUpdate, areaToUpdate, operation):
	if operation == "append":
		listToUpdate.append(areaToUpdate)
	elif operation == "erase":
		listToUpdate.erase(areaToUpdate)
