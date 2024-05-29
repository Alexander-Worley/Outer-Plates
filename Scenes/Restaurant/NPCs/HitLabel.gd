extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func MoveLabel():
	$Timer.wait_time = 3
	$Timer.start()
	
	var tween = create_tween()
	tween.tween_property(self, "position", position - Vector2(0, 25), 5)
	

	
