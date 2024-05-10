extends Node2D

# Closes the application
func _on_quit_pressed():
	get_tree().quit()

# Changes to the Restaurant Scene
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Restaurant/restaurant.tscn")
