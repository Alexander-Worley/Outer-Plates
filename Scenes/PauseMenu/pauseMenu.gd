extends Node2D

var controls_scene = preload("res://Scenes/PauseMenu/controls.tscn")
var controls_instance = null

func _on_quit_button_pressed():
	toggle_pause()
	Global.isAcceptAllInput = true
	Global.isP1UsingKeyboard = true
	const mainMenuScene = preload("res://Scenes/MainMenu/mainMenu.tscn")
	Utils.setScene(mainMenuScene, false)

func _on_continue_button_pressed():
	toggle_pause()

func _on_controls_button_pressed():
	if controls_instance == null:
		controls_instance = controls_scene.instantiate()
		add_child(controls_instance)
	controls_instance.visible = true

func toggle_pause():
	visible = !visible
	get_tree().paused = !get_tree().paused

func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()
