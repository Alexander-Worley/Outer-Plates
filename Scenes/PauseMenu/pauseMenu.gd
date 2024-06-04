extends Node2D

var controls_scene = preload("res://Scenes/PauseMenu/controls.tscn")
var controls_instance = null

func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://DevScenes/DevMenu.tscn")

func _on_continue_button_pressed():
	visible = !visible
	get_tree().paused = !get_tree().paused

func _on_controls_button_pressed():
	if controls_instance == null:
		controls_instance = controls_scene.instantiate()
		add_child(controls_instance)
	controls_instance.visible = true


func _ready():
	pass

func _input(event):
	if event.is_action_pressed("pause"):
		visible = !visible
		get_tree().paused = !get_tree().paused
