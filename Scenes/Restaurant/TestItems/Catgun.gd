extends Area2D

var redStar = preload("res://Scenes/Restaurant/TestItems/Stars/Redstar.tscn")
var orangeStar = preload("res://Scenes/Restaurant/TestItems/Stars/Orangestar.tscn")
var yellowStar = preload("res://Scenes/Restaurant/TestItems/Stars/Yellowstar.tscn")
var greenStar = preload("res://Scenes/Restaurant/TestItems/Stars/Greenstar.tscn")
var cyanStar = preload("res://Scenes/Restaurant/TestItems/Stars/Cyanstar.tscn")
var indigoStar = preload("res://Scenes/Restaurant/TestItems/Stars/Indigostar.tscn")
var violetStar = preload("res://Scenes/Restaurant/TestItems/Stars/Violetstar.tscn")

var starArr = [redStar, orangeStar, yellowStar, greenStar, cyanStar, indigoStar, violetStar]
var idx = 0

var starsShot = 0

var maxAmmo = 28
var ammo: int = maxAmmo

func shoot():
	$Timer.start()

func shootHelper():
	$AnimatedSprite2D.play("default")
	if ammo == 0:
		return
		
	var b = starArr[idx].instantiate()
	idx += 1
	if idx > 6:
		idx = 0
	
	b.start($Muzzle.global_position, $Muzzle.global_rotation)
	get_tree().root.add_child(b)
	ammo = ammo - 1
	#updateAmmoCounter()
	

func updateAmmoCounter():
	print(self.get_path())
	var ammoCount = get_node("/root/Logan/Weapons/ammoCount")
	ammoCount.text = "Ammo: " + str(ammo)


func _on_timer_timeout():
	starsShot += 1
	if starsShot < 8:
		shootHelper()
	else:
		starsShot = 0
		$Timer.stop()
