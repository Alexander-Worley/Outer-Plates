extends State
class_name CustomerWaitingForFood

func Enter():
	customer.navigate = false
	
	customer.reparent(customer.curTable)
	

func Exit():
	pass
	
func Update(_delta: float):
	if customer.curTable.status == 2 or customer.curTable.status == 3:
		startEating()
		
	
func Physics_Update(_delta: float):
	pass


func startEating():
	Transitioned.emit(self, "Eating")
