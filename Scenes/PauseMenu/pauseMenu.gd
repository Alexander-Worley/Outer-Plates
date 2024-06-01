extends Node2D

# Number of colors in each layout array

func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("pause"):
		visible = !visible
		get_tree().paused = !get_tree().paused
