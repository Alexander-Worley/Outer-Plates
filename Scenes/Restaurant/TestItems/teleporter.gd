extends Node2D

@onready var Customer = preload("res://Scenes/Restaurant/NPCs/customer.tscn")
@onready var Pirate = preload("res://Scenes/Restaurant/NPCs/pirate.tscn")
@onready var curChild


@onready var isTeleporting = false

@onready var pirateToggle = false

@onready var numTeleports = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	$RunTeleportTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	$AnimatedSprite2D.play_backwards("default")
	
	$WalkOffTimer.start()

func teleport_in():
	if not isTeleporting:
		isTeleporting = true
		$TeleportInTimer.start()
		$AnimatedSprite2D.play("default")
		
		if pirateToggle:
			spawn_pirate()
			pirateToggle = false
		else:
			spawn_customer()
			pirateToggle = true
	

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
	
	#clean up customer reference
	curChild = null


func _on_run_teleport_timer_timeout():
	if numTeleports > 0:
		teleport_in()
		numTeleports -= 1
	else:
		$RunTeleportTimer.stop()	
	
