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
	pass
	
func Update(_delta: float):
	pass
		
	
func Physics_Update(_delta: float):
	pass

func _on_thinking_timer_timeout():
	ThinkingTimer.stop()
	if not decided:
		decided = true
		thinkingBubbleSprite.stop()
		
		customer.curTable.set_order("generate")	
		customer.order = customer.curTable.get_order()
		
		customer.showOrder()
	else:
		thinkingBubbleSprite.visible = false
		Transitioned.emit(self, "WaitingForFood")
