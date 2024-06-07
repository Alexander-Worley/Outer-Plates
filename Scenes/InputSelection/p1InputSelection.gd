extends Node2D

func _on_keyboard_input_zone_body_entered(body):
	Global.isAcceptAllInput = false
	Global.isP1UsingKeyboard = true
	var timer = get_tree().create_timer(0.1)
	if not timer.is_connected("timeout", Callable(self, "_on_timer_timeout")):
		timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _on_controller_input_zone_body_entered(body):
	Global.isAcceptAllInput = false
	Global.isP1UsingKeyboard = false
	var timer = get_tree().create_timer(0.1)
	if not timer.is_connected("timeout", Callable(self, "_on_timer_timeout")):
		timer.connect("timeout", Callable(self, "_on_timer_timeout"))

# This timer is necessary to safely unload everything from the scene
func _on_timer_timeout():
	const playerSelection = preload("res://Scenes/InputSelection/playerSelection.tscn")
	Utils.setScene(playerSelection)
