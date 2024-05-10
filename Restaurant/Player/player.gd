extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta):
	# TODO: Replace "ui" variables with custom gameplay actions
	# Gets the input movements and handles the movement/deceleration.
	var horizontalMovement = Input.get_axis("ui_left", "ui_right")
	if horizontalMovement:
		velocity.x = horizontalMovement * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	var verticalMovement = Input.get_axis("ui_up", "ui_down")
	if verticalMovement:
		velocity.y = verticalMovement * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	move_and_slide()
