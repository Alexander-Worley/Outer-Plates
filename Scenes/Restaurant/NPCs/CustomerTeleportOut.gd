extends State
class_name CustomerTeleportOut

var teleporterSprite

func Enter():
	teleporterSprite = teleporter.find_child("AnimatedSprite2D")
	
	#make little dude stop pathfinding
	customer.navigate = false
	
	#necessary to allow customer to clip into teleporter seamlessly
	customer.reparent(teleporter)
	
	customer.walkTo(Vector2(TeleportSpot.position.x, TeleportSpot.position.y), 1)
	
	TeleportTimer.start()
	

func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	pass
	
func _on_teleport_timer_timeout():
	if customer.isLeaving:
		sprite.stop()
		teleporterSprite.play()
		
		#fade customer out, teleport, and annihilate
		var tween = customer.create_tween()
		await tween.tween_property(customer, "modulate:a", 0, 1).finished
		teleporterSprite.play_backwards()
		customer.queue_free()
