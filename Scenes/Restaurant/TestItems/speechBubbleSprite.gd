extends AnimatedSprite2D

const NUM_FRAMES: int = 7
@onready var animationTimer = $AnimationTimer

func _ready():
	frame = 0
	animationTimer.start()
	animationTimer.connect("timeout", Callable(self, "_on_animationTimer_timeout"))

func _on_animationTimer_timeout():
	frame += 1
