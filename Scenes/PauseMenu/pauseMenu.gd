extends Node2D

# Number of colors in each layout array
#func _on_controls_button_pressed():
	#get_tree().change_scene_to_file("res://Scenes/Conto/pauseMenu.tscn"DevMenu.tscn")


func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("pause"):
		visible = !visible
		get_tree().paused = !get_tree().paused
