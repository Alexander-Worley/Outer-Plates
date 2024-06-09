extends Node

@export var transitionRoute = 'none'
var currentScene = null
var teleporter = null
var customers = null

# Called when the node enters the scene tree for the first time.
func _ready():
	currentScene = self.get_parent()
	teleporter = currentScene.find_child("Teleporter")
	customers = currentScene.find_child("Customers")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var numCustomers = customers.get_children().size()
	var spawnString = teleporter.spawnString
	print(numCustomers)
	if (len(spawnString) == 0 and numCustomers == 0):
		const nextScene = preload("res://DayScenes/Day3G.tscn")
		Utils.setScene(nextScene)
