extends Node2D

@onready var Customer = preload("res://Scenes/Restaurant/NPCs/customer.tscn")
@onready var curCustomer
@onready var isTeleporting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

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
		spawn_customer()
	

func spawn_customer():
	curCustomer = Customer.instantiate()
	add_child(curCustomer)

func _on_walk_off_timer_timeout():
	isTeleporting = false
	
	#move parent to customers node
	var parent = get_node("../../Customers")
	curCustomer.reparent(parent)
	curCustomer.customersNode = parent
	
	#clean up customer reference
	curCustomer = null
