extends Node

@export var transitionRoute = 'none'
var currentScene = null
var teleporter = null
var customers = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if false:
		const nextScene = preload("res://DayScenes/Day3G.tscn")
		Utils.setScene(nextScene)
