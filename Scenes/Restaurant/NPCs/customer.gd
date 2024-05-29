extends CharacterBody2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $AnimatedSprite2D

var hit_points = 10
var time_elapsed = 0
var label_move_duration = 4

func _ready():
	pass
	
func _on_interact():
	sprite.frame = 1 if sprite.frame == 0 else 0

func _process(delta):
	time_elapsed += delta

func hit(type):
	if type == "laser":
		hit_points -= 5
	elif type == "plasma":
		hit_points -= 10
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
	sprite.frame = 1
