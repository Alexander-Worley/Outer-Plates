extends Area2D

var Plasma = preload("res://Scenes/Restaurant/TestItems/plasma.tscn")
var ammo: int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	pass

func shoot():
	if ammo == 0:
		return
	var b = Plasma.instantiate()
	b.start($Muzzle.global_position, $Muzzle.global_rotation)
	get_tree().root.add_child(b)
	ammo = ammo - 1
	updateAmmoCounter()

	
func updateAmmoCounter():
	var ammoCount = get_node("/root/Logan/Weapons/ammoCount")
	ammoCount.text = str(ammo)