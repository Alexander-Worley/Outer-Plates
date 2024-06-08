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
	
	MoneyLabel.money += 100
	
	customer.changeTarget(BottomOfStairs)
	
	customer.reparent(customer.customersNode)
	
	customer.curTable.status = customer.curTable.tableState.AVAILABLE
	customer.curTable.customer = null
	
	Transitioned.emit(self, "WalkTo")
