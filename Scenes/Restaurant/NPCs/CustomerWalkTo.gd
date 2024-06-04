extends State
class_name CustomerWalkTo

var target

var oldPos

func Enter():
	customer.startNavigating()
	target = customer.target
	
	TweakOutTimer.start()
	print(TweakOutTimer)
	oldPos = customer.position

func Exit():
	TweakOutTimer.stop()
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	if not customer.reachedHosting:
		if customer.position.distance_to(target.global_position) < 30:
			customer.reachedHosting = true
			Transitioned.emit(self, "Idle")
	if customer.isLeaving:
		if customer.position.distance_to(target.global_position) < 40:
			Transitioned.emit(self, "TeleportOut")
	


func _on_tweak_out_timer_timeout():
	if abs(customer.position.x - oldPos.x) < 2 and abs(customer.position.y - oldPos.y) < 2:
		print("cut that out")
		collisionShape.disabled = true
		customer.position = customer.target.global_position
		
	oldPos = customer.position