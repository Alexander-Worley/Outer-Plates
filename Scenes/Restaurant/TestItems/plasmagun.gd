extends Area2D

var Plasma = preload("res://Scenes/Restaurant/TestItems/plasma.tscn")

var maxAmmo = 10
var ammo: int = maxAmmo

func shoot():
	if ammo == 0:
		return
	var b = Plasma.instantiate()
	b.start($Muzzle.global_position, $Muzzle.global_rotation)
	get_tree().root.add_child(b)
	ammo = ammo - 1
	updateAmmoCounter()

	
func updateAmmoCounter():
	pass
	#var ammoCount = get_node("../ammoCount
	#var ammoCount = get_node("/root/Logan/Weapons/ammoCount")
	#ammoCount.text = "Ammo: " + str(ammo)
