extends Node2D

var nextLevel

func _on_level_1_pressed():
	nextLevel = preload("res://DayScenes/Day1T.tscn")
	load_level()

func _on_level_2_pressed():
	nextLevel = preload("res://DayScenes/Day2T.tscn")
	load_level()

func _on_level_3_pressed():
	nextLevel = preload("res://DayScenes/Day3T.tscn")
	load_level()

func _on_level_4_pressed():
	nextLevel = preload("res://DayScenes/Day4T.tscn")
	load_level()

func _on_level_5_pressed():
	nextLevel = preload("res://DayScenes/Day5T.tscn")
	load_level()

func load_level():
	var timer = get_tree().create_timer(0.1)
	if not timer.is_connected("timeout", Callable(self, "_on_timer_timeout")):
		timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _on_timer_timeout():
	Utils.setScene(nextLevel)
