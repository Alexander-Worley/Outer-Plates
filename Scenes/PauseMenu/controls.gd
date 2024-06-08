extends Node2D

func _input(event):
	if event.is_action_pressed("pause"):
		self.visible = false
