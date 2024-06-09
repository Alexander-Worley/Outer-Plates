extends CharacterBody2D

var inputMap = {}
var playerNum: int = -1
var isKeyboardControl: bool = false

const SPEED: float = 120.0
# If true, the Player will not stop their animation
var isAnimationLock: bool = false
# If true, the Player will not be able to interact
var isInteractLock: bool = false
var isHolding: bool = false
var holdablesInRange: Array[Area2D] = []
var surfacesInRange: Array[Area2D] = []
var interactablesInRange: Array[Area2D] = []
var ammoDepotsInRange: Array[Area2D] = []
var teleporterInRange: Array[Area2D] = []
var holdableInHand: Area2D = null
var interactableBeingUsed: Area2D = null
# All of the player sprites divided up by player number.
# If the player is moving up, the first array is selected.
# If the player is moving down, the second array is selected.
	# For the two arrays above: the horizontal movement decides index.
	# If the player is not moving horizontally, the first index is selected.
	# If the player is moving horizontally, the second index is selected.
# If the player is only moving horizontally, the third value is selected.
# This is less than ideal, I know, but I'm forgoing redoing this due to time crunch.
var sprites = {
	-1: [["P4_Back", "P4_B_Diagonal"], ["P4_Front", "P4_F_Diagonal"], "P4_Side"],
	0: [["P1_Back", "P1_B_Diagonal"], ["P1_Front", "P1_F_Diagonal"], "P1_Side"],
	1: [["P2_Back", "P2_B_Diagonal"], ["P2_Front", "P2_F_Diagonal"], "P2_Side"],
	2: [["P3_Back", "P3_B_Diagonal"], ["P3_Front", "P3_F_Diagonal"], "P3_Side"],
	3: [["P4_Back", "P4_B_Diagonal"], ["P4_Front", "P4_F_Diagonal"], "P4_Side"],
}
@onready var interactRange: Area2D = $interactRange
@onready var holdablePosition: Area2D = $holdablePosition
@onready var playerSprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	# Set front sprite as starting sprite
	playerSprite.animation = sprites[playerNum][1][0]

# Picks up a holdable
func pickup_holdable(holdable: Area2D):
	var holdableParent = holdable.get_parent()
	# Anti-theft mechanisms
	if holdableParent.is_in_group("player"): return
	
	holdableInHand = holdable.duplicate()
	holdablePosition.add_child(holdableInHand)
	set_holdable_position()
	# Interupt cooking if needed
	if holdableParent.is_in_group("CookingStation"):
		holdableParent.stop_cooking()
	if holdableParent.is_in_group("Surfaces"):
		holdableParent.remove_holdable_from_surface(holdable)
	# Transfer cuttable properties if needed
	if holdableInHand.is_in_group("Cuttable"):
		holdableInHand.isCut = holdable.isCut
		holdableInHand.isOnPlate = holdable.isOnPlate
		holdableInHand.isEaten = holdable.isEaten
	# Transfer "doneness" if needed
	if holdableInHand.is_in_group("Cookable"):
		holdableInHand.doneness = holdable.doneness
	if holdableInHand.is_in_group("Weapons"):
		holdableInHand.ammo = holdable.ammo
	#copy ammo if needed
	# Commented out this as it causes crashes in Main Restaurant Scene
	# AW - May 25, 2024 - TODO: Fix this
	#if holdableInHand.is_in_group("Weapons"):
		#holdableInHand.ammo = holdable.ammo
		#var ammoCount = get_node("/root/Logan/Weapons/ammoCount")
		#ammoCount.text = str(holdableInHand.ammo)
	# Do not delete original holdable if it is coming from a PlateRack
	if !holdableParent.is_in_group("SpawnBox"): holdable.queue_free()
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
		if surface.is_in_group("PlateRack"):
			if holdableInHand.is_in_group("Cuttable") and holdableInHand.isCut and !holdableInHand.isOnPlate:
				holdableInHand.set_isOnPlate(true)
				break
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
func set_interact_range_position(horizontal: int, vertical: int):
	horizontal *= Global.PIXEL_DIMENSION
	vertical *= Global.PIXEL_DIMENSION
	interactRange.position = Vector2(horizontal, vertical)
	horizontal /= 4
	vertical /= 4
	holdablePosition.position = Vector2(horizontal, vertical)

# Set isAnimationLock
func set_is_animation_lock(isLock: bool):
	isAnimationLock = isLock

# Set isInteractLock
func set_is_interact_lock(isLock: bool):
	isInteractLock = isLock

# Play current Player Sprite Animation
func play_animation():
	playerSprite.play()

# Animates the player
func animate_player(horizontal: int, vertical: int):
	if horizontal:
		# Flip Player sprite if facing opposite direction of the spirte's default direction
		playerSprite.flip_h = true if horizontal == 1 else false
		if !vertical:
			# If moving sideways, set Side Sprite
			playerSprite.play(sprites[playerNum][2])
	if vertical:
		var verticalDirection = (vertical + 1) / 2.0 # 0 if up, 1 if down
		var horizontalDirection = abs(horizontal) # 0 if only vertical, 1 if horizontal
		playerSprite.play(sprites[playerNum][verticalDirection][horizontalDirection])
		# Move holdableInHand sprite above or below the player as needed
		if isHolding: holdableInHand.z_index = 1 if verticalDirection else 0

func tilt_weapon(horizontal: int, vertical: int):
	if !isHolding: return
	const DIAGONAL_ANGLE = 45
	var rotationDegrees = DIAGONAL_ANGLE * horizontal * vertical
	# if aiming up or down
	if !horizontal and vertical:
		rotationDegrees = -2 * DIAGONAL_ANGLE
	holdableInHand.rotation_degrees = rotationDegrees

# Inputs that are read every frame they are inputted
# (such as movement) are read here
func get_continuous_input(input: String):
	var moveRight = "moveRight{n}".format({"n":playerNum})
	var moveLeft = "moveLeft{n}".format({"n":playerNum})
	var moveUp = "moveUp{n}".format({"n":playerNum})
	var moveDown = "moveDown{n}".format({"n":playerNum})
	var aimRight = "aimRight{n}".format({"n":playerNum})
	var aimLeft = "aimLeft{n}".format({"n":playerNum})
	var aimUp = "aimUp{n}".format({"n":playerNum})
	var aimDown = "aimDown{n}".format({"n":playerNum})
	match input:
		moveRight:
			return "moveRight"
		moveLeft:
			return "moveLeft"
		moveUp:
			return "moveUp"
		moveDown:
			return "moveDown"
		aimRight:
			return "aimRight"
		aimLeft:
			return "aimLeft"
		aimUp:
			return "aimUp"
		aimDown:
			return "aimDown"
	return null

# Inputs that are only read on the first frame they are inputted
# (such as pickup) are read here
func get_frame_one_input(input: String):
	var pickupInput = "pickup{n}".format({"n":playerNum})
	var interactInput = "interact{n}".format({"n":playerNum})
	match input:
		pickupInput:
			return "pickup"
		interactInput:
			return "interact"
	return null

# Given an input, return an array of move and aim values:
# [0] = horizontalMovement
# [1] = verticalMovement
# [2] = horizontalFacing
# [3] = verticalFacing
func read_move_and_aim_values(action: String) -> Array:
	var input = get_continuous_input(action)
	var horizontalMovement: int
	var verticalMovement: int
	var horizontalFacing: int
	var verticalFacing: int
	match input:
		"moveRight":
			horizontalMovement = 1 # right
		"moveLeft":
			horizontalMovement = -1 # left
		"moveUp":
			verticalMovement = -1 # up
		"moveDown":
			verticalMovement = 1 # down
		"aimRight":
			horizontalFacing = 1 # right
		"aimLeft":
			horizontalFacing = -1 # left
		"aimUp":
			verticalFacing = -1 # up
		"aimDown":
			verticalFacing = 1 # down
	return [horizontalMovement, verticalMovement, horizontalFacing, verticalFacing]

# Read actions on the first frame they are inputted
func read_pickup_and_interact_values(action: String):
	var input = get_frame_one_input(action)
	match input:
		"pickup":
			pickup()
		"interact":
			interact()

# Only called when accepting all input
func all_input_mode_move_and_aim() -> Array:
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
	
	return [horizontalMovement, verticalMovement, horizontalFacing, verticalFacing]

func _process(_delta):
	var horizontalMovement: int = 0
	var verticalMovement: int = 0
	var horizontalFacing: int = 0
	var verticalFacing: int = 0
	for action in inputMap:
		# Read move and aim values every frame
		if !Input.is_action_pressed(action): continue
		var moveAndAimValues: Array = read_move_and_aim_values(action)
		if moveAndAimValues[0]: horizontalMovement = moveAndAimValues[0]
		if moveAndAimValues[1]: verticalMovement = moveAndAimValues[1]
		if moveAndAimValues[2]: horizontalFacing = moveAndAimValues[2]
		if moveAndAimValues[3]: verticalFacing = moveAndAimValues[3]
		
		# Read pickup and interact values only on the first frame of a new input
		if !Input.is_action_just_pressed(action): continue
		read_pickup_and_interact_values(action)
	
	# If accepting all inputs
	if Global.isAcceptAllInput:
		var moveAndAimValues: Array = all_input_mode_move_and_aim()
		if moveAndAimValues[0]: horizontalMovement = moveAndAimValues[0]
		if moveAndAimValues[1]: verticalMovement = moveAndAimValues[1]
		if moveAndAimValues[2]: horizontalFacing = moveAndAimValues[2]
		if moveAndAimValues[3]: verticalFacing = moveAndAimValues[3]
	
	# Move interactRange
	var interactRange_x: int = 0
	var interactRange_y: int = 0
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
		# For things like the cutting board
		if interactableBeingUsed:
			if interactableBeingUsed.is_in_group("Accepts Movement Signals"):
				interactableBeingUsed.move_signal()
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
		# If both directions, adjust speed
		if horizontalMovement: velocity = velocity / 4 * 3
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		# if no movement at all
		if !horizontalMovement and !isAnimationLock: playerSprite.stop()
	
	move_and_slide()

# Only used when accepting all inputs
func _input(event):
	if !Global.isAcceptAllInput: return
	if event.is_action_pressed("pickup"):
		pickup()
	if event.is_action_pressed("interact"):
		interact()

# On pickup input
func pickup():
	if isHolding: place_holdable()
	else: if holdablesInRange:
		# TODO: Replace "pick_random()" with static decisions.
			# Perhaps the item most inside of "pickup_range"?
		pickup_holdable(holdablesInRange.pick_random())

# On interact input
func interact():
	if isInteractLock: return
	for interactable in interactablesInRange:
		if !isHolding and interactable.begin_interaction(self): break
		# I know these following lines ugly sorry - Andreea :(
		if isHolding and interactable.is_in_group("DrinkTube"):
			if interactable.begin_interaction(self): break
		if isHolding and interactable.is_in_group("Sink") or interactable.is_in_group("PlateRack"):
			if interactable.begin_interaction(self): break
	if teleporterInRange:
		teleporterInRange[0].teleport_in(false)
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
	elif area.is_in_group("Teleporter"):
		update_in_range(teleporterInRange, area, operation)
func update_in_range(listToUpdate, areaToUpdate, operation):
	if operation == "append":
		listToUpdate.append(areaToUpdate)
	elif operation == "erase":
		listToUpdate.erase(areaToUpdate)
