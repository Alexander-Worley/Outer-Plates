extends Control

var raw:Color = Color("#FFEA00")
var rare:Color = Color("#ff6700")
var med_rare:Color = Color("#FF0000")
var well:Color = Color("#8B0000")
var burnt:Color = Color("#2b2d2f")
	
var colorArr = [raw, rare, med_rare, well, burnt]
var valueArr = [0, 25, 50, 75, 100]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func startMoving(doneness):
	self.visible = true
	self.set_modulate(colorArr[doneness])
	$ProgressBar.value = valueArr[doneness]
	
	$CookingBarTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_cooking_bar_timer_timeout():
	$ProgressBar.value += 1
	
func resetBar():
	$CookingBarTimer.stop()
	$ProgressBar.value = 0
	self.visible = false
