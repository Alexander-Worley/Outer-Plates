extends Area2D

var Plate = preload("res://Scenes/Restaurant/Holdables/Food/Plate/plate.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func begin_interaction(player: CharacterBody2D):
	print("hi")
	if is_instance_valid(player.holdableInHand) and (player.holdableInHand.is_in_group("Cookable") or player.holdableInHand.is_in_group("Cuttable")):
		$Timer.start()
		$Surface.play()
		
		#make plate instance
		var plate = Plate.instantiate()
		
		player.holdablePosition.remove_child(player.holdableInHand)
		
		player.holdableInHand = plate
		player.holdablePosition.add_child(plate)
		
		



func _on_timer_timeout():
	$Surface.stop()
