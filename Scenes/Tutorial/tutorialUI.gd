extends Area2D

@export_category("Tutorial tools")
@export_enum("controller", "keyboard") var inputType: int = 0
@export_enum("move", "aim", "pick up", "interact", "esc") var control: int = 0

var endFrame = 6
var currentFrame = 0
var frame_timer: float = 0.0
var frame_duration: float = 0.1  # Duration for each frame in seconds
var is_animating: bool = false

@onready var speechBubble: AnimatedSprite2D = $speechBubble

# Called when the node enters the scene tree for the first time.
func _ready():
	#speechBubble.visible = false
	inputType = Global.isP1UsingKeyboard
	if inputType:
		endFrame = 0
	else:
		endFrame = 5
	endFrame += control
	speechBubble.set_frame(endFrame)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if is_animating:
	#	frame_timer += delta
	#	if frame_timer >= frame_duration:
	#		frame_timer = 0.0
	#		currentFrame += 1
	#		if currentFrame > endFrame:
	#			is_animating = false
	#		else:
	#			speechBubble.frame = currentFrame

func become_visible():
	speechBubble.visible = true
	play_animation()

func play_animation():
	currentFrame = 0
	speechBubble.frame = currentFrame
	is_animating = true

func become_invisible():
	speechBubble.visible = false
	is_animating = false
