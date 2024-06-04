extends State
class_name CustomerIdle

var move_direction : Vector2
var wander_time : float

func randomize_wander():
	move_direction = Vector2(randf_range(-1,1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1,2)

func Enter():
	customer.navigate = false
	customer.speed = 10
	
	randomize_wander()
	WaitForTableTimer.start()
		
func Exit():
		customer.speed = 100

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()
	

func Physics_Update(delta: float):
	customer.velocity = move_direction * customer.speed	
	customer.move_and_slide()
	sprite.play("default")


func _on_wait_for_table_timer_timeout():
	customer.isLeaving = true
	customer.changeTarget(BottomOfStairs)
	Transitioned.emit(self, "WalkTo")

