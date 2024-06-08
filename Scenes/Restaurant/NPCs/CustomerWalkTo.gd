extends State
class_name PirateWalkTo

var target

var oldPos

func Enter():
	customer.startNavigating()
	target = customer.target
	
	TweakOutTimer.start()
	oldPos = customer.position

func Exit():
	TweakOutTimer.stop()
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	if not customer.reachedSeat:
		if customer.position.distance_to(target.global_position) < 5:
			customer.reachedSeat = true
			Transitioned.emit(self, "Pondering")
	if not customer.reachedHosting:
		if customer.position.distance_to(target.global_position) < 5:
			customer.reachedHosting = true
			Transitioned.emit(self, "Idle")
	if customer.isLeaving:
		if customer.position.distance_to(target.global_position) < 40:
			Transitioned.emit(self, "TeleportOut")
		if not customer.ate:
			AngryTimer.start()
			customer.find_child("ThinkingBubble").visible = true
			customer.find_child("DialogueBox").visible = false
			customer.find_child("ThinkingBubble").play("angry")

func _on_tweak_out_timer_timeout():
	if abs(customer.position.x - oldPos.x) < 2 and abs(customer.position.y - oldPos.y) < 2:
		collisionShape.disabled = true
		customer.position = customer.target.global_position
		
	oldPos = customer.position



func _on_angry_timer_timeout():
	customer.find_child("ThinkingBubble").visible = false
