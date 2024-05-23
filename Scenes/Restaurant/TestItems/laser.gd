extends CharacterBody2D

var speed = 700

func start(_position, _direction):
	rotation = _direction
	position = _position
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		queue_free()
		velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()

func _on_VisibilityNotifier2D_screen_exited():
	# Deletes the bullet when it exits the screen.
	queue_free()
