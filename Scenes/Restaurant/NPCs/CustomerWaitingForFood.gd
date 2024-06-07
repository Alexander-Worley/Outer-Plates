extends State
class_name CustomerWaitingForFood

func Enter():
	WaitingForFoodTimer.start()	

func Exit():
	pass
	
func Update(_delta: float):
	if customer.curTable.status == 2 or customer.curTable.status == 3:
		startEating()
		
		
	
func Physics_Update(_delta: float):
	pass


func startEating():
	Transitioned.emit(self, "Eating")


func _on_waiting_for_food_timer_timeout():
	customer.changeTarget(BottomOfStairs)
	customer.isLeaving = true
	customer.reparent(customer.customersNode)
	
	customer.curTable.status = customer.curTable.tableState.AVAILABLE
	customer.curTable.customer = null
		
	Transitioned.emit(self, "WalkTo")
