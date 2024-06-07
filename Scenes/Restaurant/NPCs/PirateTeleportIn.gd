extends State
class_name PirateTeleportIn

func Enter():
	TeleportTimer.start()
	
	customer.modulate.a = 0
	customer.global_position = TeleportSpot.global_position
	
	customer.curTable = findFreeTable()
	customer.foundTable = true

	customer.changeTarget(customer.curTable)
	print(customer.target)

	#fade customer in
	var tween = customer.create_tween()
	tween.tween_property(customer, "modulate:a", 1, 1)


func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	pass
	


func _on_teleport_timer_timeout():
	if not customer.isLeaving:
		customer.walkTo(Vector2(BottomOfStairs.position.x, BottomOfStairs.position.y + 30), 1)
		Transitioned.emit(self, "WalkTo")

func findFreeTable():
	for table in TableManager.tables:
		if not table.hasPirate:
			table.hasPirate = true
			return table
	return -1
