extends State
class_name CustomerEating

var teleporterSprite

func Enter():
	EatingTimer.start()
	

func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	pass


func _on_eating_timer_timeout():
	customer.ate = true
	customer.isLeaving = true
	customer.changeTarget(BottomOfStairs)
	
	customer.reparent(customer.customersNode)
	print(customer.get_parent())
	
	Transitioned.emit(self, "WalkTo")
