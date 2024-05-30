extends ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func startMoving():
	self.visible = true
	#var cookingTween = get_tree().create_tween()	
	#cookingTween.tween_property(self, "scale", Vector2(10, 1), 9)
	#cookingTween.set_ease(Tween.EASE_OUT_IN)
