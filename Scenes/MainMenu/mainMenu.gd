extends Node2D

@onready var startButton = $startButton

# Changes to the Restaurant Scene
func _on_start_button_pressed():
	const devMenuScene = preload("res://DevScenes/DevMenu.tscn")
	const AlexanderTest = preload("res://DevScenes/Alexander/Alexander.tscn")
	Global.currentScene = AlexanderTest.instantiate()
	get_tree().change_scene_to_file("res://Scenes/SceneManager/sceneManager.tscn")

func _input(event):
	if event.is_action_pressed("pickup") or event.is_action_pressed("interact"):
		startButton.button_pressed = true
		await get_tree().create_timer(0.1).timeout
		_on_start_button_pressed()
