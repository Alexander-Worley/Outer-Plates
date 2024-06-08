extends AnimatedSprite2D

const NUM_FRAMES: int = 7
@onready var animationTimer = $AnimationTimer

func _ready():
	pass
	#animationTimer.start()
	#animationTimer.connect("timeout", Callable(self, "_on_animationTimer_timeout"))

func _on_animationTimer_timeout():
	frame = randi() % NUM_FRAMES

func start_animation(endFrame: int):
	animationTimer.start()
	animationTimer.connect("timeout", Callable(self, "_on_animationTimer_timeout"))
