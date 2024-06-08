extends Node2D

func _on_day_1_pressed():
	var day1Scene = preload("res://Scenes/Levels/Day1.tscn")
	Utils.setScene(day1Scene)
