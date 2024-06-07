extends Area2D

var Laser = preload("res://Scenes/Restaurant/TestItems/laser.tscn")

var maxAmmo = 20
var ammo: int = maxAmmo

func shoot():
	if ammo == 0:
		return
	var b = Laser.instantiate()
	b.start($Muzzle.global_position, $Muzzle.global_rotation)
	get_tree().root.add_child(b)
	ammo = ammo - 1
	updateAmmoCounter()
	
func updateAmmoCounter():
	var ammoCount = get_node("/root/Logan/Weapons/ammoCount")
	ammoCount.text = "Ammo: " + str(ammo)
