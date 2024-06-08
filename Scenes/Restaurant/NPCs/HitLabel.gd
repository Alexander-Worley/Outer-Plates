extends Label

func MoveLabel():
	$Timer.wait_time = 3
	$Timer.start()
	
	var tween = create_tween()
	tween.tween_property(self, "position", position - Vector2(0, 25), 5)
