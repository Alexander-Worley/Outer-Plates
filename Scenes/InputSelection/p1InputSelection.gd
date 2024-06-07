extends Node2D

const playerSelection = preload("res://Scenes/InputSelection/playerSelection.tscn")

func _on_keyboard_input_zone_body_entered(body):
	Global.isAcceptAllInput = false
	Global.isP1UsingKeyboard = true
	Utils.setScene(playerSelection)


func _on_controller_input_zone_body_entered(body):
	Global.isAcceptAllInput = false
	Global.isP1UsingKeyboard = false
	Utils.setScene(playerSelection)
