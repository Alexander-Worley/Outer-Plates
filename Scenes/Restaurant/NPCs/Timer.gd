extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	timeout.connect(_on_Timer_timeout)

func _on_Timer_timeout():
	get_parent().visible = false
	self.stop()
