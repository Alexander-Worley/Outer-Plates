extends CharacterBody2D

const SPEED: float = 300.0
var isCarryingItem: bool = false
var itemsInRange: Array = []
var itemInHand: Area2D = null

func pickup_item(item: Area2D):
	isCarryingItem = true
	itemInHand = item
	item.queue_free()

func place_item():
	itemInHand = null
	isCarryingItem = false

# Given whether the player is moving up, down, left, right, or diagonal,
# set the position of their pickup range
func set_pickup_range_position(horizontal: float, vertical: float):
	horizontal *= Global.PIXEL_DIMENSION
	vertical *= Global.PIXEL_DIMENSION
	$pickup_range.position = Vector2(horizontal, vertical)

func _physics_process(delta):
	# TODO: Replace "ui" variables with custom gameplay actions
	# Gets the input movements and handles the movement/deceleration.
	var horizontalMovement: float = Input.get_axis("ui_left", "ui_right")
	var verticalMovement: float = Input.get_axis("ui_up", "ui_down")
	if horizontalMovement:
		velocity.x = horizontalMovement * SPEED
		set_pickup_range_position(horizontalMovement, verticalMovement)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if verticalMovement:
		velocity.y = verticalMovement * SPEED
		set_pickup_range_position(horizontalMovement, verticalMovement)
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	move_and_slide()

func _input(event):
	# TODO: Replace "ui" variables with custom gameplay actions
	# TODO: Replace "ui_accept with another keystroke
	if event.is_action_pressed("ui_accept"):
		if isCarryingItem: place_item()
		else: if !itemsInRange.is_empty():
			# TODO: Replace "pick_random()" with static decisions.
				# Perhaps the item most inside of "pickup_range"?
			pickup_item(itemsInRange.pick_random())

func _on_pickup_range_area_entered(area):
	if area.is_in_group("TestFood"):
		itemsInRange.append(area)

func _on_pickup_range_area_exited(area):
	if area.is_in_group("TestFood"):
		itemsInRange.erase(area)
