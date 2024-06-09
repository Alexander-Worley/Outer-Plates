extends State
class_name CustomerPondering

@onready var decided = false

func Enter():
	customer.navigate = false
	customer.reparent(customer.curTable)
	
	ThinkingTimer.start()
	thinkingBubbleSprite.visible = true
	thinkingBubbleSprite.play("default")
	

func Exit():
	ThinkingTimer.stop()
	
func Update(_delta: float):
	pass
		
	
func Physics_Update(_delta: float):
	pass

func _on_thinking_timer_timeout():
	if not decided:
		decided = true
		
		customer.curTable.set_order("generate")	
		customer.order = customer.curTable.get_order()
		customer.showOrder()
	else:
		Transitioned.emit(self, "WaitingForFood")
