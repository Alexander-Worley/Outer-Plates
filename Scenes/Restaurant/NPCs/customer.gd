extends CharacterBody2D

@export var target: Node2D

@onready var sprite = $AnimatedSprite2D

var hit_points = 10
var label_move_duration = 4
var navigate = false
var speed = 100

var reachedHosting = true
var reachedSeat = false
var isLeaving = false
var ate = false

#context based steering shenanigans
@export var steer_force = 0.2
@export var look_ahead = 75
@export var num_rays = 12
var path_direction

# context array
var ray_directions = []
var interest = []
var danger = []

var chosen_dir = Vector2.ZERO
var acceleration = Vector2.ZERO

var curTable
var customersNode

var canBeShot = false

@onready var MoneyLabel = get_node("../../../MoneyLabel")

func _ready():
	print(MoneyLabel)
	#prepare steering rays
	interest.resize(num_rays)
	danger.resize(num_rays)
	ray_directions.resize(num_rays)
	for i in num_rays:
		var angle = i * 2 * PI / num_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)
	
func _on_interact():
	pass
	#sprite.frame = 1 if sprite.frame == 0 else 0

func _process(delta):
	if hit_points <= 0:
		die()
	
func _physics_process(_delta:float) -> void:	
	if navigate:
		#more context based steering stuff
		set_interest()
		set_danger()
		choose_direction()
		var desired_velocity = chosen_dir.rotated(rotation) * speed
		velocity = velocity.lerp(desired_velocity, steer_force)
		#rotation = velocity.angle()
		move_and_slide()
		
		if velocity.x > 1:
			sprite.flip_h = false
		else:
			sprite.flip_h = true

func hit(type):
	if not canBeShot:
		return
	if type == "laser":
		hit_points -= 5
	elif type == "plasma":
		hit_points -= 10
	elif type == "star":
		hit_points -= 1
	if hit_points <= 0:
		die()
		
	var message = doLocalizedDamage()
	
	if message != "":
		doHitLabel(message)

	
func doHitLabel(message):
	$HitLabel.position.y = -30
	$HitLabel.visible = true
	$HitLabel.text = message
	$HitLabel.MoveLabel()

func doLocalizedDamage():
	var randy = randi() % 100
	
	if randy < 10:
		return "critical arm injury"
	elif randy > 10 and randy < 20:
		return "critical leg injury"
	elif randy > 20 and randy < 30:
		return "critical head injury"
		die()
	else:
		return ""

#kills
func die():
	print("ded")
	MoneyLabel.money -= 100
	self.queue_free()

func walkTo(location, time):
	var tween = self.create_tween()
	$AnimatedSprite2D.play("default")
	tween.tween_property(self, "position", location, time)
	
func _on_path_timer_timeout():
	pass

func startNavigating():
	navigate = true

	$AnimatedSprite2D.play("default")

func changeTarget(newTarget):
	target = newTarget
	
func stopNavigating():
	navigate = false

func set_interest():
	# Set interest in each slot based on world direction
	path_direction = (target.global_position - position)
	for i in num_rays:
		var d = ray_directions[i].rotated(rotation).dot(path_direction)
		interest[i] = max(0, d)

func set_danger():
	# Cast rays to find danger directions
	var space_state = get_world_2d().direct_space_state
	for i in num_rays:
		var query = PhysicsRayQueryParameters2D.create(position, position + ray_directions[i].rotated(rotation)*look_ahead)
		var result = space_state.intersect_ray(query)
	
		danger[i] = 1.0 if result else 0.0
	
func choose_direction():
	# Eliminate interest in slots with danger
	for i in num_rays:
		if danger[i] > 0.0:
			#todo: use danger rays to influence choice of the opposite direction
			interest[i] = 0.0
	# Choose direction based on remaining interest
	chosen_dir = Vector2.ZERO
	for i in num_rays:
		chosen_dir += ray_directions[i] * interest[i]
	chosen_dir = chosen_dir.normalized()
