extends State
class_name CustomerWaitingForFood

func Enter():
	WaitingForFoodTimer.start()	
	customer.curTable.set_status(2) # This corresponds to a new table state (NEED_SERVING)

func Exit():
	pass
	
func Update(_delta: float):
	if customer.curTable.status == customer.curTable.tableState.DINING:
		print("we finna eat")
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
