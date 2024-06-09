extends Area2D

signal display_orders

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func begin_interaction(player: CharacterBody2D):
	display_orders.emit()
