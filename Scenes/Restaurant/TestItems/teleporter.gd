extends Node2D

@export var spawnString:String

@onready var Customer = preload("res://Scenes/Restaurant/NPCs/customer.tscn")
@onready var Pirate = preload("res://Scenes/Restaurant/NPCs/pirate.tscn")
@onready var curChild


@onready var isTeleporting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$RunTeleportTimer.start()

func _on_timer_timeout():
	$AnimatedSprite2D.play_backwards("default")
	
	$WalkOffTimer.start()

func teleport_in(spawnPirate):
	if not isTeleporting:
		isTeleporting = true
		$TeleportInTimer.start()
		$AnimatedSprite2D.play("default")
		
		if spawnPirate:
			spawn_pirate()
		else:
			spawn_customer()

func spawn_customer():
	curChild = Customer.instantiate()
	add_child(curChild)
	
func spawn_pirate():
	curChild = Pirate.instantiate()
	add_child(curChild)

func _on_walk_off_timer_timeout():
	isTeleporting = false
	
	#move parent to customers node
	var parent = get_node("../../Customers")
	curChild.reparent(parent)
	curChild.customersNode = parent
	curChild.canBeShot = true
	
	#clean up customer reference
	curChild = null


func _on_run_teleport_timer_timeout():
	if len(spawnString) > 0:
		if spawnString[0] == "p":
			teleport_in(true)
		elif spawnString[0] == "c":
			teleport_in(false)
		spawnString = spawnString.substr(1, len(spawnString))
	else:
		$RunTeleportTimer.stop()
		$ChangeSceneTimer.start()	
	


func _on_change_scene_timer_timeout():
	var nextScene = preload("res://Scenes/Levels/levelSelect.tscn")
	Utils.setScene(nextScene, false)
